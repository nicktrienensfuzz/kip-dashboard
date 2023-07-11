//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/23/23.
//

import Foundation
import Hummingbird
import HummingbirdFoundation
import HummingbirdAuth
import JSON


class Metric: Codable, CustomDebugStringConvertible {
    init(name: String,displayName: String = "", labels: [JSON] = [], data: [JSON] = []) {
        self.name = name
        self.displayName = displayName
        self.labels = labels
        self.data = data
    }
    
    var name: String
    var displayName: String
    var labels: [JSON]
    var data: [JSON]
    
    var debugDescription: String {
        return "Metric: \(name)\nLabels: \(labels)\nData: \(data)"
    }
}

extension kip_dashboard {
    struct DataRange {
        let start: Date
        let end: Date
        let label: String
    }
    
    func addRoutes(to app: HBApplication, jwtAuthenticator: JWTAuthenticator) {
        
        app.router
            .group("api")
//            .add(middleware: jwtAuthenticator)
            .get("itemSalesTrend.json", use: self.itemTrends )
        
        app.router
            .group("api")
        //.add(middleware: jwtAuthenticator)
            .get("/itemModification.json", use: self.itemModification )
    }
    
    func itemTrends(request: HBRequest) async throws -> HBResponse {
        let d = try await ProductMetrics.itemData()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        
        // print((d.aggregations.orders.buckets.array ?? []).count)
        var array: [JSON] = (d.aggregations.orders.buckets.array ?? [])
        array.removeLast()
        array.removeFirst()
        // print(array.count)
        let convertedBody = array.map{ product -> JSON in
            print(product)
            var productJ = JSON()
            productJ["id"] = JSON(UUID().uuidString)
            productJ["name"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd"))
            productJ["date"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd/yyyy"))
            
            productJ["placedToCompletion"] = product.placedToCompletion.value
            productJ["claimedToCompletion"] = product.claimedToCompletion.value
            productJ["modifierCount"] = product.modifierCount.value
            
            return productJ
        }
        
        class Metric: Codable, CustomDebugStringConvertible {
            init(name: String,displayName: String = "", labels: [JSON] = [], data: [JSON] = []) {
                self.name = name
                self.displayName = displayName
                self.labels = labels
                self.data = data
            }
            
            var name: String
            var displayName: String
            var labels: [JSON]
            var data: [JSON]
            
            var debugDescription: String {
                return "Metric: \(name)\nLabels: \(labels)\nData: \(data)"
            }
        }
        
        var mappings = [String: Metric]()
        convertedBody.forEach { json in
            let keys = [ "placedToCompletion", "modifierCount", "claimedToCompletion"]
            keys.forEach { key in
                let name = key //json.name.string ?? "unknown"
                let item = mappings[key] ?? Metric(name: name)
                item.displayName = key.trainCaseToTitleCase()
                item.labels.append(json.name)
                item.data.append(json[key])
                mappings[key] = item
            }
        }
        print(mappings)
        let group = try mappings.values
            .sorted(by: { a, b in
                a.displayName < b.displayName
            })
            .reversed()
            .map({ try $0.json() })
        
        let bothWays = json { [
            "list": convertedBody,
            "grouped": group
        ]}
        return try HBResponse(status: .ok,
                              headers: .init([("contentType", "application/json")]),
                              body: .data( bothWays.toData()))
        
    }
    
    func itemModification(request: HBRequest) async throws -> HBResponse {
        let withoutModification = try await ProductMetrics.itemModificationData()
        let withModification = try await ProductMetrics.itemModificationData(modified: true)
        
        var summary: [JSON] = [JSON]()
        if let withoutArray = withoutModification.aggregations.items.buckets.array,
           let withArray = withModification.aggregations.items.buckets.array {
            
            // print(withArray)
            for (index, with) in withArray.enumerated() {
                let without = withoutArray[index]
                let withCount = with.doc_count.int ?? 0
                let withoutCount = without.doc_count.int ?? 0

                summary.append( json {[
                    "total": JSON (withCount + withoutCount),
                    "percentModified": JSON( Double(withCount * 100) / Double(withCount + withoutCount)),
                    "nonModified": JSON(withoutCount),
                    "modified": JSON(withCount),
                    "date": JSON(Date(timeIntervalSince1970: Double((with.key.int ?? 0 )/1000)).formatted("M/dd/yyyy")),
                    "name": JSON(Date(timeIntervalSince1970: Double((with.key.int ?? 0 )/1000)).formatted("M/dd"))
                ]})
            }
        }
        summary.removeLast()
        summary.removeFirst()
        
        let metric = Metric(name: "% of Items Modified",
                            displayName: "% of Items Modified",
                            labels: summary.map({$0.name}),
                            data: summary.map({$0.percentModified}))
                
        return try HBResponse(status: .ok,
                              headers: .init([("contentType", "application/json")]),
                              body: .data( metric.toData()))
        
    }
    
    func ranges() throws -> [DataRange] {
        return try [DataRange(start: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                              end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 0.weeks,
                              label: "Last Week"),
                    DataRange(start: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks,
                              end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                              label: "2 Weeks Ago"),
                    DataRange(start: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 3.weeks,
                              end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks,
                              label: "3 Weeks Ago"),
                    DataRange(start: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 4.weeks,
                              end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 3.weeks,
                              label: "4 Weeks Ago")]
    }
    func configureApi(_ app: HBApplication, jwtAuthenticator: JWTAuthenticator) {
        
        app.router
            .group("api")
            .add(middleware: jwtAuthenticator)
            .get("/itemMetrics.json") { request -> HBResponse in
                
                let d = try await ProductMetrics.productTable()
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.currencyCode = "USD"
                let convertedBody = d.aggregations.products.buckets.array?.map{ product -> JSON in
                    
                    
                    var productJ = JSON()
                    productJ["id"] = JSON(UUID().uuidString)
                    productJ["name"] = product.key
                    productJ["modifierCount"] = product.modifierCount.value
                    if let formattedNumber = numberFormatter.string(from: NSNumber(value: (product.cost.value.float ?? Float(product.cost.value.int ?? 0) )/100)) {
                        productJ["cost"] = JSON( formattedNumber )
                    }else {
                        productJ["cost"] = JSON( "$\((product.cost.value.float ?? Float(product.cost.value.int ?? 0) )/100)" )
                    }
                    
                    productJ["placedToCompletion"] = product.placedToCompletion.value
                    productJ["claimedToCompletion"] = product.claimedToCompletion.value
                    
                    return productJ
                } ?? []
                
                return try HBResponse(status: .ok,
                                      headers: .init([("contentType", "application/json")]),
                                      body: .data( convertedBody.toData()))
                
            }
        
        
        
        app.router
            .group("api")
            //.add(middleware: jwtAuthenticator)
            .get("/orderSalesTrend.json") { request -> HBResponse in
                let d = try await ProductMetrics.orderData()
                //            print(d.aggregations.orders.buckets)
                //print(d.Dates)
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.currencyCode = "USD"
                
                // print((d.aggregations.orders.buckets.array ?? []).count)
                var array: [JSON] = (d.aggregations.orders.buckets.array ?? [])
                array.removeLast()
                array.removeFirst()
                // print(array.count)
                let convertedBody = array.map{ product -> JSON in
                    var productJ = JSON()
                    productJ["id"] = JSON(UUID().uuidString)
                    productJ["name"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd"))
                    productJ["date"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd/yyyy"))
                    productJ["itemCount"] = product.itemCount.value
                    productJ["avgItemCount"] = product.avgItemCount.value
                    productJ["placedToCompletion"] = product.placedToCompletion.value
                    productJ["modifierCount"] = product.modifierCount.value
                    productJ["orderCount"] = product.doc_count
                    //                if let formattedNumber = numberFormatter.string(from: NSNumber(value: (product.totalCost.value.float ?? Float(product.totalCost.value.int ?? 0) )/100)) {
                    //                    productJ["sales"] = JSON( formattedNumber )
                    //                } else {
                    productJ["sales"] = JSON( "\((product.totalCost.value.float ?? Float(product.totalCost.value.int ?? 0) )/100)" )
                    //                }
                    
                    return productJ
                }
                
               
                
                var mappings = [String: Metric]()
                convertedBody.forEach { json in
                    let keys = ["itemCount", "orderCount", "sales", "placedToCompletion", "modifierCount","avgItemCount"]
                    keys.forEach { key in
                        let name = key //json.name.string ?? "unknown"
                        let item = mappings[key] ?? Metric(name: name)
                        item.displayName = key.trainCaseToTitleCase()
                        item.labels.append(json.name)
                        item.data.append(json[key])
                        mappings[key] = item
                    }
                }
                print(mappings)
                let group = try mappings.values
                    .sorted(by: { a, b in
                        a.displayName < b.displayName
                    })
                    .reversed()
                    .map({ try $0.json() })
                
                let bothWays = json { [
                    "list": convertedBody,
                    "grouped": group
                ]}
                return try HBResponse(status: .ok,
                                      headers: .init([("contentType", "application/json")]),
                                      body: .data( bothWays.toData()))
            }
        
        app.router
            .group("api")
            .add(middleware: jwtAuthenticator)
            .get("/locations2.json") { request -> HBResponse in
                
                let stores = Configuration.locations(ordered: true)
                let ranges = try ranges().reversed()
                let colors = ColorAssigner()
                
                let dataSets = try await ranges.asyncMap { range -> JSON in
                    let data = try await stores.asyncMap { location -> JSON in
                        return try await OpenSearchMetrics.ordersCount(
                            startDate: range.start,
                            endDate: range.end,
                            locationId: location.id)
                    }
                    let color = colors.take()
                    return json {
                        [
                            "name": range.label,
                            "backgroundColor": color ,
                            "borderColor": color,
                            "data": data
                        ]
                    }
                }
                //           .sorted(by: { a, b in
                //                a.data.array?.first?.int ?? 0 > b.data.array?.first?.int ?? 0
                //            })
                
                let convertedBody = JSON {
                    [
                        "labels": JSON(stores.map{ JSON($0.name) }),
                        "stores": dataSets
                    ]
                }
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( convertedBody.toData()))
            }
        
        app.router.group("api")
            .add(middleware: jwtAuthenticator)
            .get("/locations.json") { request -> HBResponse in
                
                let body = Configuration.locations()
                let data = try await body.asyncMap({ loc -> JSON in
                    let location = loc
                    let lastWeek = try await OpenSearchMetrics.ordersCount(
                        startDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                        endDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped(),
                        locationId: loc.id)
                    
                    let twoWeeksAgo = try await OpenSearchMetrics.ordersCount(
                        startDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks,
                        endDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                        locationId: loc.id)
                    
                    let threeWeeksAgo = try await OpenSearchMetrics.ordersCount(startDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 3.weeks,
                                                                                endDate:Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks, locationId: loc.id)
                    
                    return json {
                        [
                            "name": loc.name,
                            "backgroundColor": location.colorString,
                            "borderColor": location.colorString,
                            "data": [threeWeeksAgo,
                                     twoWeeksAgo,
                                     lastWeek,
                                    ]
                        ]
                    }
                    
                    //return location
                }).sorted(by: { a, b in
                    a.data.array?.first?.int ?? 0 > b.data.array?.first?.int ?? 0
                })
                let convertedBody = JSON {
                    ["labels": JSON([
                        "3 weeks ago",
                        "2 weeks ago",
                        "last week"
                    ]),
                     "stores": data]
                }
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( convertedBody.toData()))
            }
        
        app.router
            .group("api")
            .add(middleware: jwtAuthenticator)
            .get("allLocationsOrdersByDay.json") { request -> HBResponse in
                
                let date = try (Date() - 120.days).moveToDayOfWeek(.sunday, direction: .backward).unwrapped()
                let r = try await OpenSearchMetrics.ordersByDay(
                    startDate: date.rawStartOfDay,
                    endDate: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay )
                
                var labels = r.map(\.dateValue).deduplicatedWithOrder()
                let remove = labels.first!
                print("date to exclude: \(remove)")
                labels = Array(labels.dropFirst())
                
                let stores = Configuration.locations().map { location -> JSON in
                    let data = r.filter({ $0.locationId == location.id && $0.dateValue != remove }).map(\.count)
                    return json {
                        [
                            "name": location.name,
                            "backgroundColor": location.colorString,
                            "borderColor": location.colorString,
                            "data": data.map { "\($0)" }
                        ]
                    }
                }
                let combined = json {
                    ["stores": stores,
                     "labels": labels]
                }
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( combined.toData()))
            }
        
        app.router.group("api")
            .add(middleware: jwtAuthenticator)
            .get("/orders.json") { request -> HBResponse in
                let body = try await OpenSearchMetrics.items(Context(), locationId: "LCHVDQS909GPQ", startDate: Date() - 1.days, endDate: Date() )
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.toData()))
            }
        
        app.router
            .group("api")
            .add(middleware: jwtAuthenticator)
            .get("/ordersByDay.json") { request -> HBResponse in
                let body = try await OpenSearchMetrics.ordersByDay( startDate: Date() - 10.days, endDate: Date() )
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.toData()))
            }
        app.router.group("api")
            .add(middleware: jwtAuthenticator)
            .get("/items.json") { request -> HBResponse in
                let body = try await OpenSearchMetrics.dataPrepForML( startDate: Date() - 20.days, endDate: Date()  - 15.days )
                
                return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.toData()))
            }
        
#if canImport(AppKit)
        app.router.get("/items.csv") { request -> HBResponse in
            let body = try await jsonToCsv(jsonArray:  OpenSearchMetrics.dataPrepForML( startDate: Date() - 120.days, endDate: Date() - 35.days ).array.unwrapped())
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.data(using: .utf8).unwrapped()))
        }
        
        app.router.get("/itemsTest.csv") { request -> HBResponse in
            let body = try await jsonToCsv(jsonArray:  OpenSearchMetrics.dataPrepForML( startDate: Date() - 25.days, endDate: Date()  - 24.days ).array!)
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.data(using: .utf8).unwrapped()))
        }
#endif
    }
}


extension String {
    func trainCaseToTitleCase() -> String {
        let splitWords = self.splitBefore(separator: { $0.isUppercase })
        
        let titleCase = splitWords
            .map { $0.lowercased() }  // Convert to lowercase
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }  // Capitalize first letter
            .joined(separator: " ")
        
        return titleCase
    }
    
    func trainCaseToSentenceCase() -> String {
        let splitWords = self.splitBefore(separator: { $0.isUppercase })
        
        var sentenceCase = splitWords.joined(separator: " ").lowercased()
        
        sentenceCase = sentenceCase.prefix(1).uppercased() + sentenceCase.dropFirst()
        
        return sentenceCase
    }
    
    func splitBefore(separator isSeparator: (Character) throws -> Bool) rethrows -> [SubSequence] {
        var result: [SubSequence] = []
        var start = startIndex
        for index in indices {
            if try isSeparator(self[index]) {
                result.append(self[start..<index])
                start = index
            }
        }
        result.append(self[start..<endIndex])
        return result
    }
}
