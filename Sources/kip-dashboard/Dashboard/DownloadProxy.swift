//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 7/20/23.
//

import Foundation
import AsyncHTTPClient
import Hummingbird
import HummingbirdAuth
import HummingbirdFoundation
import JSON
import JWTKit
import Dependencies


extension kip_dashboard {
    func addProxyRoutes(to app: HBApplication, jwtAuthenticator: JWTAuthenticator) {
        app.router
            .group("api")
//            .add(middleware: jwtAuthenticator)
            .get("download", use: download)
    }
    
    func download(request: HBRequest) async throws -> HBResponse {
        let url = try request.uri.queryParameters.require("url")
        print( url)
        
        let endpoint = Endpoint(
            method: .GET,
            path: "http://35.163.203.79:8080/pdf?url=\(url)"
        )
        @Dependency(\.httpClient) var client
        let response: HTTPClient.Response = try await client.request(endpoint).get()
        
        print(response.headers)
        //response.body?.
        let data = try Data(buffer: response.body.unwrapped())

        return HBResponse(
            status: .ok,
            headers: .init([("Content-Type", "application/pdf"),
                            ("Content-Disposition", "attachment; filename=BluejayReport_" + UUID().uuidString + ".pdf"),
                            ("S3-Url", response.headers.first(name: "S3-Url") ?? "")]),
            body: .data(data)
        )
    }
}
