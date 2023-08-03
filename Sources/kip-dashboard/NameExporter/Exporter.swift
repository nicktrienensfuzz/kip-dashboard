//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 8/3/23.
//

import Foundation
import Dependencies
import JSON
import Hummingbird
import AsyncHTTPClient

enum Exporter {
    
    
    static func addRoutes(to app: HBApplication, jwtAuthenticator: JWTAuthenticator) {
        app.router
            .group("exporter")
            .get("products", use: products)
    }
    
    
    static func categories(request: HBRequest) async throws -> HBResponse {
        
        let endpoint = Endpoint(
            method: .GET,
            path: "https://amzgokiosk-dev.s3.us-west-2.amazonaws.com/allAugmentations_v4.json"
        )
        @Dependency(\.httpClient) var client
        let response: HTTPClient.Response = try await client.request(endpoint).get()
        
        print(response.headers)
        //response.body?.
        let data = try Data(buffer: response.body.unwrapped())
        let json: JSON = try data.decode()
        
        let cats: [JSON] = try json.categories.array.unwrapped()
        let csv = try jsonToCsv(jsonArray: cats, headers: "id,title")
        return HBResponse(status: .ok,body: .data(csv))
    }
    
    static func products(request: HBRequest) async throws -> HBResponse {
        
        let endpoint = Endpoint(
            method: .GET,
            path: "https://amzgokiosk-dev.s3.us-west-2.amazonaws.com/allAugmentations_v4.json"
        )
        @Dependency(\.httpClient) var client
        let response: HTTPClient.Response = try await client.request(endpoint).get()
        
        print(response.headers)
        //response.body?.
        let data = try Data(buffer: response.body.unwrapped())
        let json: JSON = try data.decode()
        
        let cats: [JSON] = try json.products.array.unwrapped()
        let csv = try jsonToCsv(jsonArray: cats, headers: "id,title")
        return HBResponse(status: .ok,body: .data(csv))
    }
    
    static func modifiers(request: HBRequest) async throws -> HBResponse {
        
        let endpoint = Endpoint(
            method: .GET,
            path: "https://amzgokiosk-dev.s3.us-west-2.amazonaws.com/allAugmentations_v4.json"
        )
        @Dependency(\.httpClient) var client
        let response: HTTPClient.Response = try await client.request(endpoint).get()
        
        print(response.headers)
        //response.body?.
        let data = try Data(buffer: response.body.unwrapped())
        let json: JSON = try data.decode()
        
        let cats: [JSON] = try json.modifiers.array.unwrapped()
        let csv = try jsonToCsv(jsonArray: cats, headers: "title,squareId,name on kds")
        return HBResponse(status: .ok,body: .data(csv))
    }
        
    static func steps(request: HBRequest) async throws -> HBResponse {
        
        let endpoint = Endpoint(
            method: .GET,
            path: "https://amzgokiosk-dev.s3.us-west-2.amazonaws.com/allSteps.json"
        )
        @Dependency(\.httpClient) var client
        let response: HTTPClient.Response = try await client.request(endpoint).get()
        
        print(response.headers)
        //response.body?.
        let data = try Data(buffer: response.body.unwrapped())
        let json: JSON = try data.decode()
        
        let products: [JSON] = try json.products.array.unwrapped()
        
        var csv = "productTile\tstep\tconfluencePageID\n"
        try csv = csv + products.map { product -> String in
         
            let steps = try product.steps.array.unwrapped()
            return "\(product.title.string ?? "")\t\t\(product.confluenceId.string ?? "")\n" + steps.map({ step -> String in
                return "\(product.title.string ?? "")\t\(step.title.string ?? "")"
            }).joined(separator: "\n")
                
        }
        .joined(separator: "\n")
        
        return HBResponse(status: .ok,body: .data(csv))
    }
}
