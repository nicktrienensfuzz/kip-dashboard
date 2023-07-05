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
            let emailList: [EmailAccessControl] = [.domain("@monstar-lab"), .domain("@genieology.com")]
            
            guard let email = requestJson.email.string else {
                throw HBHTTPError(.badRequest)
            }
            
            if !emailList.emailAllowed(email) {
                return try HBResponse(status: .badRequest,
                                      headers: .init([("contentType", "application/json")]),
                                      body: .data(
                                        json{["success":0,
                                              "reason": "email not allowed"]}.toData()))
                
            }
            
            let host = try requestJson.host.string.unwrapped()
            
            try await SendGridClient().sendEmail( email: email,
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
