// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation


import ArgumentParser
import PathKit
import Foundation
import Logging
import Dependencies
import Hummingbird
import HummingbirdFoundation
import AsyncHTTPClient
import HummingbirdTLS
import PathKit
import JSON

import HummingbirdLambda
import AWSLambdaEvents
import AWSLambdaRuntimeCore
import HummingbirdAuth

@main
struct kip_dashboard: HBLambda {
    // define input and output
    typealias Event = APIGatewayV2Request
    typealias Output = APIGatewayResponse
    
    init(_ app: HBApplication) {
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        
        //        app.middleware.add(HBFileMiddleware((Path.current + Path("public")).string, searchForIndexHtml: true, application: app))
        //        app.middleware.add(HBCORSMiddleware(allowOrigin: .all))
        
        app.addPersist(using: .memory)
        @Dependency(\.configuration) var configuration
        
        app.decoder = JSONDecoder()
        app.encoder = JSONEncoder()
        let jwtAuthenticator = JWTAuthenticator()
        
        configure(app, jwtAuthenticator: jwtAuthenticator)
        configureApi(app, jwtAuthenticator: jwtAuthenticator)
        configureAuth(app, jwtAuthenticator: jwtAuthenticator)
        
        
    }
}


//
//
//@main
//struct kip_dashboard: AsyncParsableCommand {
//
//    @Option(name: .shortAndLong)
//    var hostname: String = "127.0.0.1"
//
//    @Option(name: .shortAndLong)
//    var port: Int = 8080
//
//    @Option(name: .shortAndLong)
//    var generate: Bool = false
//
//    func generate() async throws {
//
//
//#if canImport(AppKit)
//
//        if var date = "2022-04-20".asDate?.rawStartOfDay {
//            let outputFile = Path("itemMakes_noOutliers.csv")
//            var data = ""
//            var isFirst = true
//            while date < (Date() - 10.days) {
//                print("query \(date)")
//                data += try await jsonToCsv(jsonArray:
//                                                OpenSearchMetrics.dataPrepForML(
//                                                    startDate: date - 7.days,
//                                                    endDate: date,
//                                                    removeOutliers: true)
//                                                    .array.unwrapped(), includeHeader: isFirst)
//                isFirst = false
//                try outputFile.write(data)
//                date = try date.moveToDayOfWeek(.monday, direction: .forward).unwrapped()
//            }
//            print("data lines:", data.split(separator: "\n").count)
//        }
//
//
//        let outputFile = Path("itemMakes_noOutliers_test.csv")
//        var data = ""
//        let date = Date() - 2.days
//        print("query \(date)")
//        data += try await jsonToCsv(jsonArray:
//                                        OpenSearchMetrics.dataPrepForML(
//                                            startDate: date - 7.days,
//                                            endDate: date,
//                                            removeOutliers: true
//                                        )
//                                            .array.unwrapped())
//        try outputFile.write(data)
//#endif
//    }
//
//
//    mutating func run() async throws {
//
//        if generate {
//            try await generate()
//        }
//
//        let app = HBApplication(configuration: .init(address: .hostname(hostname, port: port)))
//        app.middleware.add(HBLogRequestsMiddleware(.debug))
//        app.middleware.add(HBFileMiddleware((Path.current + Path("public/")).string, searchForIndexHtml: true, application: app))
//        app.middleware.add(HBCORSMiddleware(allowOrigin: .all))
//        app.addPersist(using: .memory)
//
//        @Dependency(\.configuration) var configuration
//
//        app.decoder = JSONDecoder()
//        app.encoder = JSONEncoder()
//        let jwtAuthenticator = JWTAuthenticator()
//
//        configure(app, jwtAuthenticator: jwtAuthenticator)
//        configureApi(app, jwtAuthenticator: jwtAuthenticator)
//        configureAuth(app, jwtAuthenticator: jwtAuthenticator)
//
//        try app.start()
//        app.wait()
//    }
//}
