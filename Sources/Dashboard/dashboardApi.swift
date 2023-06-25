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
        
        var colorString = """
'rgb(255, 99, 132)'
'rgb(255, 159, 64)'
'rgb(255, 205, 86)'
'rgb(75, 192, 192)'
'rgb(54, 162, 235)'
'rgb(153, 102, 255)'
'rgb(201, 203, 207)'
"""
        colors = colorString.split(separator: "\n").map{ String($0) }
    }
    func take() -> String {
        print(colors)
        let color = colors.removeFirst()
        print(colors)
        return color
    }
}

extension kip_dashboard {
    
    func configureApi(_ app: HBApplication) {
        
        struct DataRange {
            let start: Date
            let end: Date
            let label: String
        }
        
        app.router.get("/locations2.json") { request -> HBResponse in
            
            let stores = Configuration.locations()
            let ranges = try [DataRange(start: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                                        end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 0.weeks,
                                        label: "Last Week"),
                              DataRange(start:      Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks,
                                        end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 1.weeks,
                                        label: "2 Weeks Ago"),
                              DataRange(start:            Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 3.weeks,
                                        end: Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped() - 2.weeks,
                                        label: "3 Weeks Ago")
            ].reversed()
            let colors = ColorAssigner()

            let dataSets = try await ranges.asyncMap { range -> JSON in
                var data = try await stores.asyncMap { location -> JSON in
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
                var location = loc
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
        
        app.router.get("/items.csv") { request -> HBResponse in
            let body = try await jsonToCsv(jsonArray:  OpenSearchMetrics.dataPrepForML( startDate: Date() - 120.days, endDate: Date() - 35.days ).array.unwrapped())
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.data(using: .utf8).unwrapped()))
        }
        
        app.router.get("/itemsTest.csv") { request -> HBResponse in
            let body = try await jsonToCsv(jsonArray:  OpenSearchMetrics.dataPrepForML( startDate: Date() - 25.days, endDate: Date()  - 24.days ).array!)
            
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/json")]), body: .data( body.data(using: .utf8).unwrapped()))
        }
    }
}
