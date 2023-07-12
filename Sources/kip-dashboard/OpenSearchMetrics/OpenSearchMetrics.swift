//
//  OpenSearchMetrics.swift
//
//
//  Created by Nicholas Trienens on 3/8/22.
//

import AsyncHTTPClient
import Dependencies
import Foundation
import JSON
import Tagged

struct ServiceOutage {
    let id: String
    let interval: String
    let rawDisableInterval: Int
    let rawTotalInterval: Int
    let service: String
    let level: String
    let start: Date
    let endDate: Date?
    let didDisable: Bool
    let didWarn: Bool
}

enum OpenSearchMetrics {
    //    static func systemOutages(_ context: AnyContext, startDate: Date, endDate: Date) async throws -> [ServiceOutage] {
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //
    //
    //        @Dependency(\.configuration) var config
    //
    //        @Dependency(\.httpClient) var  client
    //
    //        let loginString = try String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
    //
    //        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
    //            throw ServiceError("unable to get username and password")
    //        }
    //
    //        let base64LoginString = loginData.base64EncodedString()
    //
    //        let body = """
    //        {
    //          "size": 2000,
    //          "sort": [
    //            {
    //              "TimeStamp": {
    //                "order": "asc",
    //                "unmapped_type": "boolean"
    //              }
    //            }
    //          ],
    //          "query": {
    //            "bool": {
    //              "filter": [
    //                {
    //                  "range": {
    //                    "TimeStamp": {
    //                      "gte": "\(dateFormatter.string(from: startDate))",
    //                      "lte": "\(dateFormatter.string(from: endDate))",
    //                      "format": "strict_date_optional_time"
    //                    }
    //                  }
    //                }
    //              ],
    //              "must": []
    //            }
    //          }
    //        }
    //        """
    //
    //       // print(body)
    //
    //        let endpoint = Endpoint(
    //            method: .POST,
    //            path: try DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchEndpoint + "/uptime-service-prod*/_search",
    //            headers: [
    //                "Authorization": "Basic \(base64LoginString)",
    //                "Content-Type": "application/json; charset=utf-8"
    //            ],
    //            body: body.asData
    //        )
    //
    //        let outages = try await client.request(endpoint)
    //            .decode(type: JSON.self)
    //            .get()
    //
    //
    //        let compiledOutages =  outages.hits.hits.array?.compactMap { outage -> ServiceOutage? in
    //
    //            guard let date = outage._source.TimeStamp.string?.asDate else {
    //                print( "failed" )
    //                return nil
    //
    //            }
    //            //  guard let disabledAt = outage._source.DisabledAt.string?.asDate else { return nil }
    //            // guard let restoredAt = outage._source.RestoringAt.string?.asDate else { return nil }
    //            print(outage._source)
    //
    //            let interval: String
    //            let rawDisableInterval: Int
    //            let rawTotalInterval: Int
    //            let level: String
    //
    //            do {
    //                try rawTotalInterval = Int(abs((outage._source.RestoredAt.string?.asDate).unwrapped().distance(to: (outage._source.TimeStamp.string?.asDate).unwrapped())))
    //            } catch {
    //                rawTotalInterval = 0
    //            }
    //
    //            if outage._source.DisabledAt.isString {
    //                interval = "\(Date.formatted(duration: outage._source.TimeInDisabled.double ?? Double(outage._source.TimeInDisabled.int ?? 0)))"
    //                rawDisableInterval = Int(outage._source.TimeInDisabled.double ?? Double(outage._source.TimeInDisabled.int ?? 0))
    //                level = "Disabled"
    //            } else if outage._source.WarningAt.isString {
    //                let span: Double
    //                do {
    //                    try span = abs((outage._source.RestoredAt.string?.asDate).unwrapped().distance(to: (outage._source.WarningAt.string?.asDate).unwrapped()))
    //                } catch {
    //                    span = 0.0
    //                }
    //                rawDisableInterval = 0
    //                interval = "\(Date.formatted(duration: span))"
    //                level = "Warn"
    //            } else {
    //                rawDisableInterval = 0
    //                interval = "0"
    //                level = "Monitoring"
    //            }
    //
    //            return ServiceOutage(id: outage.id.string ?? "",
    //                          interval: interval,
    //                          rawDisableInterval: rawDisableInterval,
    //                          rawTotalInterval: rawTotalInterval,
    //                          service: outage._source.Service.string ?? "",
    //                          level: level,
    //                          start: date,
    //                          endDate: outage._source.RestoredAt.string?.asDate,
    //                          didDisable:  outage._source.DisabledAt.isString,
    //                          didWarn: outage._source.WarningAt.isString )
    //        } ?? []
    //        //print( "compiledOutages: \(compiledOutages.count)" )
    //
    //        return compiledOutages
    //    }
    //
    //
    //
    //    private static func menuOutagesRaw(_ context: AnyContext, startDate: Date, endDate: Date) async throws -> [MenuOutage] {
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    //
    //        let client = try DependencyContainer.resolve(key: ContainerKeys.httpClientKey)
    //        let loginString = try String(format: "%@:%@", DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchUsername, DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchPassword)
    //        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
    //            throw ServiceError("unable to get username and password")
    //        }
    //
    //        let base64LoginString = loginData.base64EncodedString()
    //
    //        let body = """
    //        {
    //          "size": 2000,
    //          "sort": [
    //            {
    //              "createdAt": {
    //                "order": "asc",
    //                "unmapped_type": "boolean"
    //              }
    //            }
    //          ],
    //          "query": {
    //            "bool": {
    //              "filter": [
    //                {
    //                  "range": {
    //                    "createdAt": {
    //                      "gte": "\(dateFormatter.string(from: startDate))",
    //                      "lte": "\(dateFormatter.string(from: endDate))",
    //                      "format": "strict_date_optional_time"
    //                    }
    //                  }
    //                }
    //              ],
    //              "must": []
    //            }
    //          }
    //        }
    //        """
    //
    //       // print(body)
    //
    //        let endpoint = Endpoint(
    //            method: .POST,
    //            path: try DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchEndpoint + "/*-outofstockrecords-prod/_search",
    //            headers: [
    //                "Authorization": "Basic \(base64LoginString)",
    //                "Content-Type": "application/json; charset=utf-8"
    //            ],
    //            body: body.asData
    //        )
    //
    //        let outages = try await client.request(endpoint)
    //            .decode(type: JSON.self)
    //            .get()
    //        let decoder = JSONDecoder()
    //                decoder.dateDecodingStrategy = .formatted(dateFormatter)
    //
    //                let compiledOutages = outages.hits.hits.array?.compactMap { outage -> MenuOutage? in
    //                    do{
    //                        let result: MenuOutage = try decoder.decode(MenuOutage.self, from: outage._source.toData())
    //                        return result
    //                    }catch {
    //                        print(error)
    //                    }
    //                    return nil
    //                } ?? []
    //                return compiledOutages
    //    }
    //
    //    private static func menuOutagesRawEnded(_ context: AnyContext, startDate: Date, endDate: Date) async throws -> [MenuOutage] {
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    //
    //        let client = try DependencyContainer.resolve(key: ContainerKeys.httpClientKey)
    //        let loginString = try String(format: "%@:%@", DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchUsername, DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchPassword)
    //        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
    //            throw ServiceError("unable to get username and password")
    //        }
    //
    //        let base64LoginString = loginData.base64EncodedString()
    //
    //        let body = """
    //        {
    //          "size": 2000,
    //          "sort": [
    //            {
    //              "createdAt": {
    //                "order": "asc",
    //                "unmapped_type": "boolean"
    //              }
    //            }
    //          ],
    //          "query": {
    //            "bool": {
    //              "filter": [
    //                {
    //                  "range": {
    //                    "endedAt": {
    //                      "gte": "\(dateFormatter.string(from: startDate))",
    //                      "lte": "\(dateFormatter.string(from: endDate))",
    //                      "format": "strict_date_optional_time"
    //                    }
    //                  }
    //                }
    //              ],
    //              "must": []
    //            }
    //          }
    //        }
    //        """
    //
    //        //print(body)
    //
    //        let endpoint = Endpoint(
    //            method: .POST,
    //            path: try DependencyContainer.resolve(key: ContainerKeys.configKey).opensearchEndpoint + "/*-outofstockrecords-prod/_search",
    //            headers: [
    //                "Authorization": "Basic \(base64LoginString)",
    //                "Content-Type": "application/json; charset=utf-8"
    //            ],
    //            body: body.asData
    //        )
    //
    //        let outages = try await client.request(endpoint)
    //            .decode(type: JSON.self)
    //            .get()
    //        let decoder = JSONDecoder()
    //                decoder.dateDecodingStrategy = .formatted(dateFormatter)
    //
    //                let compiledOutages = outages.hits.hits.array?.compactMap { outage -> MenuOutage? in
    //                    do{
    //                        let result: MenuOutage = try decoder.decode(MenuOutage.self, from: outage._source.toData())
    //                        return result
    //                    }catch {
    //                        print(error)
    //                    }
    //                    return nil
    //                } ?? []
    //                return compiledOutages
    //    }

    private static func menuOutagesRawActive(_ context: AnyContext, startDate: Date, endDate: Date) async throws -> [MenuOutage] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)

        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let body = """
        {
          "size": 2000,
          "sort": [
            {
              "createdAt": {
                "order": "asc",
                "unmapped_type": "boolean"
              }
            }
          ],
          "query": {
            "bool": {
              "filter": [
                 {
                                     "match_phrase": {
                                       "active": "true"
                                     }
                                   }
              ],
              "must": []
            }
          }
        }
        """

        // print(body)

        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/*-outofstockrecords-prod/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: body.asData
        )

        let outages = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let compiledOutages = outages.hits.hits.array?.compactMap { outage -> MenuOutage? in
            do {
                let result: MenuOutage = try decoder.decode(MenuOutage.self, from: outage._source.toData())
                return result
            } catch {
                print(error)
            }
            return nil
        } ?? []
        return compiledOutages
    }

    struct MenuSummary {
        let existedWhenWeekStarted: [MenuOutage]
        let stillActive: [MenuOutage]
        let all: [MenuOutage]
    }

    //    static func menuOutages(_ context: AnyContext, startDate: Date, endDate: Date) async throws -> MenuSummary {
    //
    //        let outagesStarted = try await menuOutagesRaw(context, startDate: startDate, endDate: endDate)
    //        let outagesEnded = try await menuOutagesRawEnded(context, startDate: startDate, endDate: endDate)
    //        let outagesActive = try await menuOutagesRawActive(context, startDate: startDate, endDate: endDate)
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //
    //        var existedWhenWeekStarted = outagesActive + outagesEnded
    //        existedWhenWeekStarted = existedWhenWeekStarted
    //                .filter {
    //            if $0.createdAt > startDate {
    //                return false
    //            }
    //            return true
    //        }
    //        //print( "existedWhenWeekStarted: \(existedWhenWeekStarted.count)" )
    //
    //        return MenuSummary(existedWhenWeekStarted: existedWhenWeekStarted,
    //                           stillActive: outagesActive,
    //                           all: (outagesStarted + outagesEnded + outagesActive).deduplicated() )
    //    }
    //
    //    static func menuOutagesAtLocation(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date) async throws -> MenuSummary {
    //
    //        let outagesStarted = try await menuOutagesRaw(context, startDate: startDate, endDate: endDate)
    //        let outagesEnded = try await menuOutagesRawEnded(context, startDate: startDate, endDate: endDate)
    //        let outagesActive = try await menuOutagesRawActive(context, startDate: startDate, endDate: endDate)
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //
    //        var existedWhenWeekStarted = outagesActive + outagesEnded
    //        existedWhenWeekStarted = existedWhenWeekStarted
    //                .filter {
    //            if $0.createdAt > startDate {
    //                return false
    //            }
    //            return true
    //        }
    //        //print( "existedWhenWeekStarted: \(existedWhenWeekStarted.count)" )
    //
    //        return MenuSummary(existedWhenWeekStarted: existedWhenWeekStarted.filter({ $0.locationID == locationId }),
    //                           stillActive: outagesActive.filter({ $0.locationID == locationId }),
    //                           all: (outagesStarted + outagesEnded + outagesActive).deduplicated().filter({ $0.locationID == locationId }) )
    //    }

    static func cancelledOrders(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date) async throws -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let body = """
        {
          "size": 0,
          "query": {
            "bool": {
              "filter": [
                    {
                      "match_phrase": {
                        "locationId": "\(locationId)"
                      }
                    },
                    {
                      "match_phrase": {
                        "state": "CANCELED"
                      }
                    },
                {
                  "range": {
                    "placedAt": {
                      "gte": "\(dateFormatter.string(from: startDate))",
                      "lte": "\(dateFormatter.string(from: endDate))",
                      "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "must": []
            }
          }
        }
        """
        // print(body)
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/*orders-prod/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: body.asData
        )

        let outages = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()
        // print(outages)
        return outages.hits.total.value.int ?? 0
    }

    //    static func locationMetrics(_ context: AnyContext, locationId: String) async throws -> CompletionSummaryDTO {
    ////        guard let locationId: String = event.queryStringParameters?["locationId"] else {
    ////            throw ServiceError("No `locationId` found in query Parameters")
    ////        }
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //
    //        guard let startTime: String = event.queryStringParameters?["startDate"], let startDate = dateFormatter.date(from: startTime) else {
    //            throw ServiceError("No `startDate` found in query Parameters: \(event.queryStringParameters?["startDate"] ?? "nil")")
    //        }
    //        guard let endTime: String = event.queryStringParameters?["endDate"], let endDate = dateFormatter.date(from: endTime) else {
    //            throw ServiceError("No `endDate` found in query Parameters: \(event.queryStringParameters?["endDate"] ?? "nil")")
    //        }
    //
    //        return try await locationMetrics(context, locationId: locationId ,startDate: startDate, endDate: endDate)
    //    }

    static func systemOrders(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date, extraPrinting: Bool = false) async throws -> (OverallSummaryDTO, OverallSummaryDTO) {
        let orders = try await fetchValues(locationId: locationId, type: .orders, startDate: startDate, endDate: endDate, extraPrinting: extraPrinting)
        let itemSummaryResponse = try await fetchValues(locationId: locationId, type: .items, startDate: startDate, endDate: endDate)

        let daysInPeriod = floor(abs(endDate.timeIntervalSince(startDate)) / (3600.0 * 24.0))

        let orderSummary = OverallSummaryDTO(
            averagePlacedToClaimed: orders.aggregations.averagePlacedToClaimed.value.float ?? 0,
            averagePlacedToCompletion: orders.aggregations.averagePlacedToCompletion.value.float ?? 0,
            averageClaimedToCompletion: orders.aggregations.averageClaimedToCompletion.value.float ?? 0,
            count: orders.hits.total.value.int ?? 0,
            averageOrdersPerDay: Int(floor(Double(orders.hits.total.value.int ?? 0) / max(1, daysInPeriod)))
        )

        let itemSummary = OverallSummaryDTO(
            averagePlacedToClaimed: itemSummaryResponse.aggregations.averagePlacedToClaimed.value.float ?? 0,
            averagePlacedToCompletion: itemSummaryResponse.aggregations.averagePlacedToCompletion.value.float ?? 0,
            averageClaimedToCompletion: itemSummaryResponse.aggregations.averageClaimedToCompletion.value.float ?? 0,
            count: itemSummaryResponse.hits.total.value.int ?? 0,
            averageOrdersPerDay: Int(floor(Double(itemSummaryResponse.hits.total.value.int ?? 0) / max(1, daysInPeriod)))
        )
        return (orderSummary, itemSummary)
    }

    static func locationMetrics(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date) async throws -> CompletionSummaryDTO {
        async let associatesPromise = try fetchValues(locationId: locationId, type: .associateList, startDate: startDate, endDate: endDate)
            .aggregations.items.buckets.array?.compactMap { object -> TimeToCompletionSummaryDTO? in
                do {
                    return try TimeToCompletionSummaryDTO(
                        averageClaimedToCompletion: object.averageClaimedToCompletion.value.float.unwrapped("averageClaimedToCompletion"),
                        count: object.doc_count.int.unwrapped("count"),
                        maxClaimedToCompletion: object.maxClaimedToCompletion.value.float.unwrapped(),
                        minClaimedToCompletion: object.minClaimedToCompletion.value.float.unwrapped(),
                        title: object.key.string.unwrapped(),
                        id: object.key.string.unwrapped()
                    )
                } catch {
                    print(error)
                    // context.logger.customCritical(message: error.localizedDescription)
                    // try? context.logger.customCritical(message: object.toString())
                    return nil
                }
            }
        let associates = try await associatesPromise

        async let itemsPromise = try fetchValues(locationId: locationId, type: .itemList, startDate: startDate, endDate: endDate)
            .aggregations.items.buckets.array?.compactMap { object -> TimeToCompletionSummaryDTO? in
                do {
                    return try TimeToCompletionSummaryDTO(
                        averageClaimedToCompletion: object.averageClaimedToCompletion.value.float.unwrapped("averageClaimedToCompletion"),
                        count: object.doc_count.int.unwrapped("count"),
                        maxClaimedToCompletion: object.maxClaimedToCompletion.value.float.unwrapped(),
                        minClaimedToCompletion: object.minClaimedToCompletion.value.float.unwrapped(),
                        title: object.key.string.unwrapped(),
                        id: object.key.string.unwrapped()
                    )
                } catch {
                    // context.logger.customCritical(message: error.localizedDescription)
                    // try? context.logger.customCritical(message: object.toString())
                    try? print(object.toString())
                    return nil
                }
            }
        let items = try await itemsPromise

        async let ordersPromise = try fetchValues(locationId: locationId, type: .orders, startDate: startDate, endDate: endDate)
        async let itemSummaryResponsePromise = try fetchValues(locationId: locationId, type: .items, startDate: startDate, endDate: endDate)

        let orders = try await ordersPromise
        let itemSummaryResponse = try await itemSummaryResponsePromise

        let daysInPeriod = floor(abs(endDate.timeIntervalSince(startDate)) / (3600.0 * 24.0))

        let orderSummary = OverallSummaryDTO(
            averagePlacedToClaimed: orders.aggregations.averagePlacedToClaimed.value.float ?? 0,
            averagePlacedToCompletion: orders.aggregations.averagePlacedToCompletion.value.float ?? 0,
            averageClaimedToCompletion: orders.aggregations.averageClaimedToCompletion.value.float ?? 0,
            count: orders.hits.total.value.int ?? 0,
            averageOrdersPerDay: Int(floor(Double(orders.hits.total.value.int ?? 0) / daysInPeriod))
        )

        let itemSummary = OverallSummaryDTO(
            averagePlacedToClaimed: itemSummaryResponse.aggregations.averagePlacedToClaimed.value.float ?? 0,
            averagePlacedToCompletion: itemSummaryResponse.aggregations.averagePlacedToCompletion.value.float ?? 0,
            averageClaimedToCompletion: itemSummaryResponse.aggregations.averageClaimedToCompletion.value.float ?? 0,
            count: itemSummaryResponse.hits.total.value.int ?? 0,
            averageOrdersPerDay: Int(floor(Double(itemSummaryResponse.hits.total.value.int ?? 0) / daysInPeriod))
        )

        let result = CompletionSummaryDTO(
            associateList: associates ?? [],
            itemList: items ?? [],
            items: itemSummary,
            orders: orderSummary,
            locationId: locationId,
            startDate: startDate,
            endDate: endDate
        )

        return result
    }

    private static func fetchValues(locationId: String, type: ObjectType, startDate: Date, endDate: Date, extraPrinting: Bool = false) async throws -> JSON {
        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: requestBody(locationId: locationId, type: type, startDate: startDate, endDate: endDate).asData
        )
        if extraPrinting {
            print(endpoint.cURLRepresentation())
        }
        return try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()
    }

    enum ObjectType {
        case itemList
        case associateList
        case orders
        case items

        var index: String {
            let config = "prod"
            switch self {
            case .orders:
                if config == "prod" {
                    return "*orders-prod"
                } else {
                    return "*-orders-dev"
                }
            case .associateList, .itemList, .items:
                if config == "prod" {
                    return "*-lineitems-prod"
                } else {
                    return "*-lineitems-dev"
                }
            }
        }
    }

    static func requestBody(locationId: String, type: ObjectType, startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let groupByTerm: String
        switch type {
        case .itemList: groupByTerm = "name.keyword"
        case .associateList: groupByTerm = "associate.name.keyword"
        case .items:
            return orderRequestBody(locationId: locationId, type: type, startDate: startDate, endDate: endDate)
        case .orders:
            return orderRequestBody(locationId: locationId, type: type, startDate: startDate, endDate: endDate)
        }

        let locationFilter: String
        if !locationId.isEmpty {
            locationFilter = """
                    {
                      "match_phrase": {
                        "locationId": "\(locationId)"
                      }
                    },
            """
        } else {
            locationFilter = ""
        }

        let body = """
        {
          "aggs": {
            "items": {
              "aggs": {
                "averageClaimedToCompletion": {
                  "avg": {
                    "field": "claimedToCompletion"
                  }
                },
                "minClaimedToCompletion": {
                  "min": {
                    "field": "claimedToCompletion"
                  }
                },
                "maxClaimedToCompletion": {
                  "max": {
                    "field": "claimedToCompletion"
                  }
                }
              },
              "significant_terms": {
                "field": "\(groupByTerm)",
                "size": 100
              }
            }
          },
          "size": 0,
          "query": {
            "bool": {
              "filter": [
                \(locationFilter)
                {
                  "range": {
                    "placedAt": {
                      "gte": "\(dateFormatter.string(from: startDate))",
                      "lte": "\(dateFormatter.string(from: endDate))",
                      "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "must": []
            }
          },
        }
        """

        return body
    }

    static func orderRequestBody(locationId: String, type: ObjectType, startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let locationFilter: String
        if !locationId.isEmpty {
            locationFilter = """
                    {
                      "match_phrase": {
                        "locationId": "\(locationId)"
                      }
                    },
            """
        } else {
            locationFilter = ""
        }

        let body = """
        {
          "aggs": {
                "averageClaimedToCompletion": {
                  "avg": {
                    "field": "claimedToCompletion"
                  }
                },
                "averagePlacedToCompletion": {
                      "avg": {
                        "field": "placedToCompletion"
                      }
                    },
                    "averagePlacedToClaimed": {
                          "avg": {
                            "field": "placedToClaimed"
                          }
                        }
          },
          "size": 0,
          "query": {
            "bool": {
              "filter": [
            {
                  "match_all": {}
                },
                \(locationFilter)
                {
                  "range": {
                    "placedAt": {
                      "gte": "\(dateFormatter.string(from: startDate))",
                      "lte": "\(dateFormatter.string(from: endDate))",
                      "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "must": []
            }
          }
        }
        """

        return body
    }

    static func items(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date) async throws -> [Item] {
        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let type: ObjectType = .items
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: itemSearchQueryBody(locationId: locationId, startDate: startDate, endDate: endDate).asData
        )

        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()

        let jsonDecoder: JSONDecoder = {
            let encoder = JSONDecoder()

            encoder.dateDecodingStrategy = .iso8601
            return encoder
        }()

        let items = source.hits.hits.array?.map(\._source)
        let data = try items.unwrapped().toData()
        let objects = try jsonDecoder.decode([Item].self, from: data)
        return objects
    }

    private static func itemSearchQueryBody(locationId: String, startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return """
            {
              "size": 10000,
              "query": {
                "bool": {
                  "filter": [
                    {
                      "match_phrase": {
                        "locationId": "\(locationId)"
                      }
                    },
                                    {
                                      "match_phrase": {
                                        "state": "COMPLETED"
                                      }
                                    },

                    {
                      "range": {
                        "placedAt": {
                          "gte": "\(dateFormatter.string(from: startDate))",
                          "lte": "\(dateFormatter.string(from: endDate))",
                          "format": "strict_date_optional_time"
                        }
                      }
                    }
                  ]
                }
              }
            }
        """
    }

    static func itemMakeTimes(_ context: AnyContext, locationId: String, startDate: Date, endDate: Date) async throws -> [ItemSummaryDTO] {
        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let type: ObjectType = .items
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: itemMakeTimeQueryBody(locationId: locationId, startDate: startDate, endDate: endDate).asData
        )

        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()

        // print(source.aggregations.itemName.buckets)

        let output: [ItemSummaryDTO] = source.aggregations.itemName.buckets.array?.map { json -> ItemSummaryDTO in
            ItemSummaryDTO(
                averagePlacedToClaimed: json.placedToClaimed.value.float ?? 0,
                averagePlacedToCompletion: json.placedToCompletion.value.float ?? 0,
                averageClaimedToCompletion: json.claimedToCompletion.value.float ?? 0,
                count: json.doc_count.int ?? 0,
                itemName: json.key.string ?? "OOPS"
            )
        } ?? [ItemSummaryDTO]()
        return output
    }

    private static func itemMakeTimeQueryBody(locationId: String, startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return """
            {
            "aggs": {
                "itemName": {
                  "terms": {
                    "field": "name.keyword",
                    "order": {
                      "placedToCompletion": "desc"
                    },
                    "size": 100000
                  },
                  "aggs": {
                    "placedToCompletion": {
                      "avg": {
                        "field": "placedToCompletion"
                      }
                    },
                    "claimedToCompletion": {
                      "avg": {
                        "field": "claimedToCompletion"
                      }
                    },
                    "placedToClaimed": {
                      "avg": {
                        "field": "placedToClaimed"
                      }
                    }
                  }
                }
              },
              "size": 0,
              "query": {
                "bool": {
                  "filter": [
                    {
                      "match_phrase": {
                        "locationId": "\(locationId)"
                      }
                    },
                    {
                      "match_phrase": {
                        "state": "COMPLETED"
                      }
                    },
                    {
                      "range": {
                        "placedAt": {
                          "gte": "\(dateFormatter.string(from: startDate))",
                          "lte": "\(dateFormatter.string(from: endDate))",
                          "format": "strict_date_optional_time"
                        }
                      }
                    }
                  ]
                }
              }
            }
        """
    }

    static func ordersByDay(startDate: Date, endDate: Date) async throws -> [OrdersByDayObj] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let query = """
        {
          "aggs": {
            "locations": {
              "terms": {
                "field": "locationId.keyword",
                "order": {
                  "_count": "desc"
                },
                "size": 50
              },
              "aggs": {
                "dates": {
                  "date_histogram": {
                    "field": "createdAt",
                    "calendar_interval": "1w",
                    "time_zone": "America/Los_Angeles",
                    "min_doc_count": 1
                  }
                }
              }
            }
          },
          "size": 0,
          "stored_fields": [
            "*"
          ],
          "_source": {
            "excludes": []
          },
          "query": {
            "bool": {
              "must": [],
              "filter": [
                {
                  "match_all": {}
                },
                {
                  "range": {
                    "createdAt": {
                        "gte": "\(dateFormatter.string(from: startDate))",
                        "lte": "\(dateFormatter.string(from: endDate))",
                        "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "should": [],
              "must_not": [
                {
                  "match_phrase": {
                    "locationId.keyword": "LKA2D3148RFDC"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LGFRKXEFPBDVA"
                  }
                }
              ]
            }
          }
        }
        """

        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let type: ObjectType = .orders
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: query.asData
        )

        let source = try await OrdersByDayJson(rawValue: client.request(endpoint)
            .decode(type: JSON.self)
            .get().aggregations.locations.buckets)

        return source.makeDays()
    }

    static func ordersCount(startDate: Date, endDate: Date, locationId: String) async throws -> JSON {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let locationQuery: String
        if locationId.count > 5 {
            locationQuery = """
                        {
                          "match_phrase": {
                            "locationId": "\(locationId)"
                          }
                        },
            """
        } else {
            locationQuery = ""
        }

        let query = """
        {
          "aggs": {},
          "size": 0,
          "stored_fields": [
            "*"
          ],
          "_source": {
            "excludes": []
          },
          "query": {
            "bool": {
              "must": [],
              "filter": [
                {
                  "match_all": {}
                },
                \(locationQuery)
                {
                  "range": {
                    "createdAt": {
                        "gte": "\(dateFormatter.string(from: startDate))",
                        "lte": "\(dateFormatter.string(from: endDate))",
                        "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "should": []
            }
          }
        }
        """

        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let type: ObjectType = .orders
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: query.asData
        )

        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get().hits.total.value

        return source
    }

    static func dataPrepForML(startDate: Date, endDate: Date, removeOutliers: Bool = false) async throws -> JSON {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let query = """
        {
          "size": 10000,
          "stored_fields": [
            "*"
          ],
          "_source": {
            "excludes": []
          },
          "query": {
            "bool": {
              "must": [],
              "filter": [
                {
                  "match_all": {}
                },
                {
                  "range": {
                    "placedAt": {
                        "gte": "\(dateFormatter.string(from: startDate))",
                        "lte": "\(dateFormatter.string(from: endDate))",
                        "format": "strict_date_optional_time"
                    }
                  }
                }
              ],
              "should": [],
              "must_not": [
                {
                  "match_phrase": {
                    "locationId.keyword": "LKA2D3148RFDC"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LGFRKXEFPBDVA"
                  }
                }
              ]
            }
          }
        }
        """

        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }

        let base64LoginString = loginData.base64EncodedString()

        let type: ObjectType = .items
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(type.index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: query.asData
        )
        // print(endpoint.cURLRepresentation())

        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()

        if let items = source.hits.hits.array {
            return JSON(items.compactMap { rawOrderedItem -> JSON? in
                do {
                    let orderedItem = rawOrderedItem._source
                    var j = JSON()
                    // print(orderedItem)
                    j["locationId"] = JSON(try orderedItem.locationId.string.unwrapped())
                    j["name"] = JSON(try orderedItem.name.string.unwrapped())
                    j["catalogId"] = JSON(try orderedItem.catalogId.string.unwrapped())
                    j["placedAt"] = JSON(try orderedItem.placedAt.string.unwrapped())

                    if let date = orderedItem.placedAt.string?.asDate {
                        j["timeOfDay"] = JSON(date.secondsFromStartOfDay)
                    } else {
                        j["timeOfDay"] = JSON(0)
                    }

                    if removeOutliers {
                        do {
                            let placedToCompletion = try orderedItem.placedToCompletion.float.unwrapped()
                            let claimedToCompletion = try orderedItem.claimedToCompletion.float.unwrapped()
                            if placedToCompletion < 50 || claimedToCompletion < 50 {
                                return nil
                            }
                            if placedToCompletion > 750 || claimedToCompletion > 620 {
                                return nil
                            }
                        } catch {
                            // print(orderedItem.placedToCompletion)
                            throw error
                        }
                    }
                    j["placedToCompletion"] = JSON(orderedItem.placedToCompletion.float ?? 0)
                    j["claimedToCompletion"] = JSON(orderedItem.claimedToCompletion.float ?? 0)

                    j["placedAtPacificDayOfWeek"] = JSON(orderedItem.placedAtPacificDayOfWeek.string ?? "")

                    j["hot"] = try JSON(isHotItem(orderedItem))

                    let m = (orderedItem.modifiers.array ?? []).compactMap { modifier -> (String, String)? in
                        try? (modifier.catalogObjectId.string.unwrapped(), modifier.name.string.unwrapped())
                    }
                    .sorted(by: { a, b in
                        a.0 < b.1
                    })
                    var i = 1
                    m.forEach { id, name in
                        j["modifier\(i)Id"] = JSON(id)
                        j["modifier\(i)Name"] = JSON(name)
                        i += 1
                    }

                    j["modifiers"] = JSON(m.count)
                    return j
                } catch {
                    // print(error)
                    return nil
                }
            })
        }
        return source
    }

    static func isHotItem(_ json: JSON) throws -> Int {
        let catalogId = try json.catalogId.string.unwrapped()
        let hotIds = "SZPCPFGB4OJ5GVEAN76XVQGB,CDVKVBMD3G5CWP7RA6GC3W4U,ZA4CT6IXS25OSQPEE3JUB7WY,ZT3ZZ3AEEKSTKOAQWXC2UZXW,P76U3XMUSCJSZMXHS2ZQT2OG,L4O76WHRB4GBPWYBBNYU3AIL,EXMGG4Q74CAXU22SS2WHAJCV,MLC24LODHZIUGKGYZDJEV5XL,MLC24LODHZIUGKGYZDJEV5XL,G5RUPFQRVM3CDKAJPOWRX6PL,D4ZXKSU5PSROG66Q2NIBHADO,O6F3INM44U6JC3K4T7TCSYTP,2E62C46HBFV5ZLYFSQMQLMPK,3AAYVAPNEPEX76OLHSMSAPNW,3ZZRCASQQQRIXF3VDMWMJ4O2,7MFCMJFA3FOZMDWFXB2YESVP,J6P767CVER7OSR6AAP6WA6OZ,VN5PRTVDSTZD5GS4NLKW5C7R,LUBWDBH2KOFKIAZVUO64HO2K"
        return hotIds.split(separator: ",").map(String.init).contains(catalogId) ? 1 : 0
    }
}

public enum OrdersByDay {}
public typealias OrdersByDayJson = Tagged<OrdersByDay, JSON>

public extension Array where Element: Hashable {
    /// Create a new `Array` without duplicate elements.
    /// - Note: The initial order of the elements is not maintained in the returned value.
    ///
    /// - Returns: A new `Array` without duplicate elements.
    ///
    func deduplicated() -> Array {
        Array(Set<Element>(self))
    }

    /// Strip duplicate elements from the array.
    /// - Note:  The initial order of the elements is not maintained after the strip.
    mutating func deduplicate() {
        self = deduplicated()
    }
}

extension OrdersByDayJson {
    func makeDays() -> [OrdersByDayObj] {
        (array ?? []).flatMap { bucket -> [OrdersByDayObj] in
            let locationId = bucket.key.string ?? ""
            return (bucket.dates.buckets.array ?? []).map { date -> OrdersByDayObj in
                let count: Int = date.doc_count.int ?? 0
                let timestamp = Date(timeIntervalSince1970: Double(date.key.int ?? 0) / 1000.0)
                return OrdersByDayObj(count: count, timestamp: timestamp, locationId: locationId)
            }
        }
    }
}

struct OrdersByDayObj: Codable {
    init(count: Int, timestamp: Date, locationId: String) {
        self.count = count
        self.timestamp = timestamp
        self.locationId = locationId
        dateValue = timestamp.formatted("dd MMM")
    }

    let count: Int
    let timestamp: Date
    let locationId: String
    let dateValue: String
}

struct LocationByInterval: Codable {
    init(count: Int, timestamp: Date, locationId: String) {
        self.count = count
        self.timestamp = timestamp
        self.locationId = locationId
        dateValue = timestamp.formatted("dd MMM")
    }

    let count: Int
    let timestamp: Date
    let locationId: String
    let dateValue: String
}
