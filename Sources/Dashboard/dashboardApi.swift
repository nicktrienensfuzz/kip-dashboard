//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/23/23.
//

import Foundation
import Hummingbird
import JSON


class ColorAssigner {
    var colors: [String]
    init() {
        
        let colorString = """
'rgba(255, 205, 86, 0.40)'
'rgba(255, 205, 86, 0.600)'
'rgba(255, 205, 86, 0.80)'
'rgba(255, 205, 86, 1)'
'rgba(75, 192, 192, 1)'
'rgba(54, 162, 235)'
'rgba(153, 102, 255)'
'rgba(201, 203, 207)'
"""
        colors = colorString.split(separator: "\n").map{ String($0) }
    }
    func take() -> String {
        //print(colors)
        let color = colors.removeFirst()
        //print(colors)
        return color
    }
}

extension kip_dashboard {
    struct DataRange {
        let start: Date
        let end: Date
        let label: String
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
    func configureApi(_ app: HBApplication) {
        app.router.get("/itemMetrics.json") { request -> HBResponse in
            
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
        
        app.router.get("/orderSalesTrend.json") { request -> HBResponse in
            let d = try await ProductMetrics.orderData()
//            print(d.aggregations.orders.buckets)
            print(d.Dates)

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencyCode = "USD"
            
            print((d.aggregations.orders.buckets.array ?? []).count)
            var array: [JSON] = (d.aggregations.orders.buckets.array ?? [])
            array.removeLast()
            array.removeFirst()
            print(array.count)
            let convertedBody = array.map{ product -> JSON in
                var productJ = JSON()
                productJ["id"] = JSON(UUID().uuidString)
                productJ["name"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd"))
                productJ["date"] = JSON(Date(timeIntervalSince1970: Double((product.key.int ?? 0 )/1000)).formatted("M/dd/yyyy"))
                productJ["itemCount"] = product.itemCount.value
                productJ["orderCount"] = product.doc_count
//                if let formattedNumber = numberFormatter.string(from: NSNumber(value: (product.totalCost.value.float ?? Float(product.totalCost.value.int ?? 0) )/100)) {
//                    productJ["sales"] = JSON( formattedNumber )
//                } else {
                    productJ["sales"] = JSON( "\((product.totalCost.value.float ?? Float(product.totalCost.value.int ?? 0) )/100)" )
//                }
                
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
                let keys = ["itemCount", "orderCount", "sales"]
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
        
        app.router.get("/locations2.json") { request -> HBResponse in
            
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
        
        app.router.get("/locations.json") { request -> HBResponse in
            
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
        
        app.router.get("allLocationsOrdersByDay.json") { request -> HBResponse in
            
            let date = try (Date() - 120.days).moveToDayOfWeek(.monday, direction: .backward).unwrapped()
            let r = try await OpenSearchMetrics.ordersByDay(
                startDate: date.rawStartOfDay,
                endDate: Date().moveToDayOfWeek(.monday, direction: .backward).unwrapped().rawStartOfDay )
            
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
        
        app.router.get("/orders.json") { request -> HBResponse in
            let body = try await OpenSearchMetrics.items(Context(), locationId: "LCHVDQS909GPQ", startDate: Date() - 1.days, endDate: Date() )
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.toData()))
        }
        
        app.router.get("/ordersByDay.json") { request -> HBResponse in
            let body = try await OpenSearchMetrics.ordersByDay( startDate: Date() - 10.days, endDate: Date() )
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.toData()))
        }
        app.router.get("/items.json") { request -> HBResponse in
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
