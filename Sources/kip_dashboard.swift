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

// https://search-kitchen-analytics-q75y3tp53rwklzyvk3ijhutx2i.us-west-2.es.amazonaws.com/_dashboards/app/dashboards#/view/4e98fef0-0afc-11ee-8c31-2f09b331f0c3?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:'2022-08-03T08:40:34.427Z',to:'2023-06-12T07:00:00.000Z'))&_a=(description:'',filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'831fda50-b51b-11ec-a0c3-1396670d8f01',key:locationId.keyword,negate:!t,params:(query:LKA2D3148RFDC),type:phrase),query:(match_phrase:(locationId.keyword:LKA2D3148RFDC))),('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'831fda50-b51b-11ec-a0c3-1396670d8f01',key:locationId.keyword,negate:!t,params:(query:LGFRKXEFPBDVA),type:phrase),query:(match_phrase:(locationId.keyword:LGFRKXEFPBDVA)))),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!t,title:'Orders%20by%20day',viewMode:view)

@main
struct kip_dashboard: AsyncParsableCommand {
    
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"
    
    @Option(name: .shortAndLong)
    var port: Int = 8080
    
    @Option(name: .shortAndLong)
    var generate: Bool = false

    func generate() async throws {
        
        
#if canImport(AppKit)

        if var date = "2022-04-20".asDate?.rawStartOfDay {
            let outputFile = Path("itemMakes_noOutliers.csv")
            var data = ""
            var isFirst = true
            while date < (Date() - 10.days) {
                print("query \(date)")
                data += try await jsonToCsv(jsonArray:
                                                OpenSearchMetrics.dataPrepForML(
                                                    startDate: date - 7.days,
                                                    endDate: date,
                                                    removeOutliers: true)
                                                .array.unwrapped(), includeHeader: isFirst)
                isFirst = false
                try outputFile.write(data)
                date = try date.moveToDayOfWeek(.monday, direction: .forward).unwrapped()
            }
            print("data lines:", data.split(separator: "\n").count)
        }
        
        
        let outputFile = Path("itemMakes_noOutliers_test.csv")
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
#endif
    }
    
    
    mutating func run() async throws {
       
        if generate {
            try await generate()
        }
        
        let app = HBApplication(configuration: .init(address: .hostname(hostname, port: port)))
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.middleware.add(HBFileMiddleware((Path.current + Path("public/")).string, searchForIndexHtml: true, application: app))
        app.middleware.add(HBCORSMiddleware(allowOrigin: .all))
        app.addPersist(using: .memory)

        configure(app)
        configureApi(app)

        app.router.get("/scripts/line-chart.js") { request -> HBResponse in
            
            let date = try (Date() - 120.days).moveToDayOfWeek(.monday, direction: .backward).unwrapped()
            let r = try await OpenSearchMetrics.ordersByDay(
                                startDate: date.rawStartOfDay,
                                endDate: Date().moveToDayOfWeek(.monday, direction: .backward).unwrapped().rawStartOfDay )
            
            
            var labels = r.map(\.dateValue).deduplicatedWithOrder()
            let remove = labels.first!
            print("date to exclude: \(remove)")
            labels = Array(labels.dropFirst())
            
            let combined = Configuration.locations().map { location -> String in
                let data = r.filter({ $0.locationId == location.id && $0.dateValue != remove }).map(\.count)
                return """
                    {
                    label: '\(location.name)',
                    backgroundColor: \(location.colorString),
                    borderColor: \(location.colorString),
                    data: [\(data.map { "\($0)" }.joined(separator: ","))],
                  }
                """
            }
            
            let body = """
        const lineElement = document.getElementById('line-chart').getContext('2d');

        const lineLabels = [\(labels.map{ "'\($0)'"}.joined(separator: ",") )
        ];

        const lineData = {
          labels: lineLabels,
          datasets: [
            \(combined.joined(separator: ","))
        ]
        };

        const lineConfig = {
          type: 'line',
          data: lineData,
        };

        const lineChart = new Chart(
          lineElement,
          lineConfig
        );
"""
            return try HBResponse(status: .ok, headers: .init([("contentType", "application/javascript; charset=utf-8")]), body: .data( body.data(using: .utf8).unwrapped() ))
        }
        
        
        try app.start()
        app.wait()
        
        
    }
}


private enum HTTPClientKey: DependencyKey {
    static let liveValue: HTTPClient = {
        let timeout = HTTPClient.Configuration.Timeout(
            connect: .seconds(20),
            read: .seconds(20)
        )
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .createNew,
            configuration: HTTPClient.Configuration(timeout: timeout)
        )
        return httpClient
        
        //        do {
        //            let oldClient = try DependencyContainer.resolve(key: ContainerKeys.httpClientKey)
        //            try oldClient.syncShutdown()
        //        } catch {
        //            // print(error)
        //        }
        //        DependencyContainer.register(httpClient, key: ContainerKeys.httpClientKey)
    }()
}


extension DependencyValues {
    var httpClient: HTTPClient {
        get { self[HTTPClientKey.self] }
        set { self[HTTPClientKey.self] = newValue }
    }
}

extension HBResponseBody {
    static func data(_ data: Data) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes(data)
        return HBResponseBody.byteBuffer(byteBuffer)
        
    }
    static func data(_ string: String) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes( string.data(using: .utf8)!)
        return  HBResponseBody.byteBuffer(byteBuffer)
    }
}
