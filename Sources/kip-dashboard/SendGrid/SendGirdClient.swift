//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 4/4/23.
//

import Foundation
import AsyncHTTPClient
import Dependencies
import JWTKit

class SendGridClient {
    
    func sendEmail( email: String, host: String?, jwtAuthenticator: JWTAuthenticator) async throws {
        @Dependency(\.configuration) var configuration
        
        let responderHost = host ?? configuration.deployedUrl
        let url = try await "\(responderHost)/index.html?token=\(jwtAuthenticator.create(email: email))"
        print(url.jsonEncodedString())
        let body = """
{
   "from":{
      "email":"info@sphereml.com"
   },
   "personalizations":[
      {
         "to":[
            {
               "email": "\(email)"
            }
         ],
         "dynamic_template_data": {
            "loginLink": \(url.jsonEncodedString() ),
            "receipt": true
          }
      }
   ],
   "template_id":"d-8543afe9a23a46aca3096f5e4f90c247"
}
"""
        
        let target = try Endpoint(
            method: HTTPMethod.POST,
            path: "https://api.sendgrid.com/v3/mail/send",
            parameters: [Parameters.rawBody( body.asData.unwrapped())],
            headers: [
                "Authorization": "Bearer \(configuration.sendGridAPIKey)",
                "Content-Type": "application/json"
            ]
        )

        let (data, response) = try await RequestMaker().makeRequestWithResponse(target)
        if response.statusCode > 300 {
            try? print(response.statusCode, data.toString() )
            throw NetworkClientError("Bad status code given: \(response.statusCode)" )
        }
    }
    

}


extension String {
    func jsonEncodedString() -> String {
        let encoder = JSONEncoder()

        encoder.outputFormatting = .withoutEscapingSlashes

        guard let data = try? encoder.encode(self),
              let jsonString = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return jsonString
    }
}
