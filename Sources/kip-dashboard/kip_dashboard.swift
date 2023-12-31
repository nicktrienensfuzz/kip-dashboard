// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import AsyncHTTPClient
import Dependencies
import Foundation
import Hummingbird
import HummingbirdFoundation
import HummingbirdTLS
import JSON
import Logging
import PathKit
import NIOCore
import NIO
import NIOHTTP1

import AWSLambdaEvents
import AWSLambdaRuntimeCore
import HummingbirdAuth
import HummingbirdLambda
import QRCodeGenerator



#if !canImport(AppKit)
@main
struct kip_dashboard: HBLambda {
    // define input and output
    typealias Event = APIGatewayV2Request
    typealias Output = APIGatewayResponse
    
    init(_ app: HBApplication) {
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.middleware.add(HBCORSMiddleware(allowOrigin: .all))
        app.configureS3()
        app.addPersist(using: .memory)
        @Dependency(\.configuration) var configuration
        
        app.decoder = JSONDecoder()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        app.encoder = encoder
        
        let jwtAuthenticator = JWTAuthenticator()
        
        configureApi(app, jwtAuthenticator: jwtAuthenticator)
        configureAuth(app, jwtAuthenticator: jwtAuthenticator)
        addRoutes(to: app, jwtAuthenticator: jwtAuthenticator)
        addProxyRoutes(to: app, jwtAuthenticator: jwtAuthenticator)
    }
    
    //        /// Handle invoke
    //        /// Specialization of HBLambda.request where `In` is `APIGateway.Request`
    //        public func request(context: LambdaContext, application: HBApplication, from: Event) throws -> HBRequest {
    //            var request = try HBRequest(context: context, application: application, from: from)
    //            // store api gateway v2 request so it is available in routes
    //            request.extensions.set(\.apiGatewayV2Request, value: from)
    //            return request
    //        }
    
}

#else

@main
struct kip_dashboard: AsyncParsableCommand {
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"
    
    @Option(name: .shortAndLong)
    var port: Int = 8082
    
    @Option(name: .shortAndLong)
    var generate: Bool = false
    
    mutating func run() async throws {
        if generate {
            try await generate()
        }
        
        let app = HBApplication(configuration: .init(address: .hostname(hostname, port: port)))
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.middleware.add(HBCORSMiddleware(allowOrigin: .all))
        app.addPersist(using: .memory)
        app.configureS3()
        
        
        @Dependency(\.configuration) var configuration
        
        app.decoder = JSONDecoder()
        app.encoder = JSONEncoder()
        let jwtAuthenticator = JWTAuthenticator()
        
        configureApi(app, jwtAuthenticator: jwtAuthenticator)
        configureAuth(app, jwtAuthenticator: jwtAuthenticator)
        addRoutes(to: app, jwtAuthenticator: jwtAuthenticator)
        addProxyRoutes(to: app, jwtAuthenticator: jwtAuthenticator)
        
        try app.start()
        
        try print(Configuration.trackableChanges())
        
//        app.router.get("svg") { _ in
//            let qr = try! QRCode.encode(text: "https://github.com/EFPrefix/swift_qrcodejs/blob/main/Package.swift", ecl: .high)
//            let svg = qr.toSVGString(border: 4)
//
//            var headers = HTTPHeaders()
//            if let contentType = HBMediaType.getMediaType(forExtension: ".svg") {
//                headers.add(name: "content-type", value: contentType.description)
//            }
//            return HBResponse(status: .ok, headers: headers, body: .data(svg))
//        }
        
        //            let data = try await Abandonment.abandonment()
        //            try Path("abandonment.json").write(data.toString(outputFormatting: .prettyPrinted))
        //            let csv = try jsonToCsv(jsonArray: data.array.unwrapped(), headers: "date,location,outcome,count,avgSessionLength")
        //            try Path("abandonment.csv").write(csv)
        //            print(data)
        //
        
        
        let r = HBRequest(path: "api/locationsList.json", application: app)
        let res = try await itemModificationForChange(request: r)
        try Path("modifiersOverChange.json").write(res.body.asString.unwrapped())
        
        let res2 = try await orderSalesTrendForChange(request: r)
        try Path("orderSalesTrendForChange.json").write(res2.body.asString.unwrapped())
        
        //            let res = try await Exporter.products(request: r)
        //            try Path("products.csv").write(res.body.asString.unwrapped())
        //
        //            let res2 = try await Exporter.categories(request: r)
        //            try Path("categories.csv").write(res2.body.asString.unwrapped())
        //
        //            let res3 = try await Exporter.modifiers(request: r)
        //            try Path("modifiers.csv").write(res3.body.asString.unwrapped())
        //
        //            let res4 = try await Exporter.steps(request: r)
        //            try Path("makeSteps.tsv").write(res4.body.asString.unwrapped())
        //
        
        app.wait()
    }
    
    func generate() async throws {
        if var date = "2022-04-20".asDate?.rawStartOfDay {
            let outputFile = Path("itemMakes_simple_noOutliers.csv")
            var data = ""
            var isFirst = true
            while date < (Date() - 10.days) {
                print("query \(date)")
                data += try await jsonToCsv(
                    jsonArray:
                        OpenSearchMetrics.dataPrepForML(
                            startDate: date - 7.days,
                            endDate: date,
                            removeOutliers: true
                        )
                        .array.unwrapped(),
                    includeHeader: isFirst
                )
                isFirst = false
                try outputFile.write(data)
                date = try date.moveToDayOfWeek(.monday, direction: .forward).unwrapped()
            }
            print("data lines:", data.split(separator: "\n").count)
        }
        
        let outputFile = Path("itemMakes_simple_noOutliers_test.csv")
        var data = ""
        let date = Date() - 2.days
        print("query \(date)")
        data += try await jsonToCsv(jsonArray:
                                        OpenSearchMetrics.dataPrepForML(
                                            startDate: date - 7.days,
                                            endDate: date,
                                            removeOutliers: true
                                        )
                                            .array.unwrapped())
        try outputFile.write(data)
    }
    
}
#endif

extension HBResponseBody {
    var asString: String? {
        switch self {
        case let .byteBuffer(buffer):
            return buffer.getString(at: 0, length: buffer.readableBytes)
        case  .stream:
            return ""
        default:
            return nil
        }
    }
    var asData: Data? {
        switch self {
        case let .byteBuffer(buffer):
            return buffer.getData(at: 0, length: buffer.readableBytes)
        case  .stream:
            return nil
        default:
            return nil
        }
    }
}
