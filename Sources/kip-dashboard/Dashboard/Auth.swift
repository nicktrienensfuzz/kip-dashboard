//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 7/2/23.
//

import Foundation
import Hummingbird
import HummingbirdFoundation
import HummingbirdAuth
import JSON

extension kip_dashboard {
    func configureAuth(_ app: HBApplication, jwtAuthenticator: JWTAuthenticator) {
        app.router.get("auth/:jwt") { request -> HBResponse in
            guard let jwt = request.parameters.get("jwt") else {
                dump(request.parameters)
                throw HBHTTPError(.badRequest)
            }
            let response = json {
                ["success": 1,
                 "jwt": jwt]
            }
            
            return try HBResponse(status: .ok,
                                  headers: .init([("contentType", "application/json"),
                                                  ("set-cookie", "permissions=\(jwt)")]),
                                  body: .data( response.toData()))
        }
            
        app.router.post("createSession") { request -> HBResponse in
            
            guard let requestJson = try? request.decode(as: JSON.self) else {
                throw HBHTTPError(.badRequest)
            }
            
            let host = try requestJson.host.string.unwrapped() // request.headers.first(name: "Host") ?? ""
            print(host)
            try await SendGridClient().sendEmail( email: requestJson.email.string.unwrapped(),
                                            host: host,
                                            jwtAuthenticator: jwtAuthenticator)
            
            
            let response = json {
                ["success": 1]
            }
            return try HBResponse(status: .ok,
                                  headers: .init([("contentType", "application/json")]),
                                  body: .data( response.toData()))
        }
    }
}
