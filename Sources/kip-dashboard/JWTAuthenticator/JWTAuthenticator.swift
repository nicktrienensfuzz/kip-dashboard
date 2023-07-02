//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 7/2/23.
//

import Foundation
import Hummingbird
import HummingbirdAuth
import JWTKit
import Dependencies

// JWT payload structure.
struct JWTPayloadData: JWTPayload, Equatable, HBAuthenticatable {
    // Maps the longer Swift property names to the
    // shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }
    
    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim
    
    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim
    
    // Custom data.
    // If true, the user is an admin.
    var isAdmin: Bool
    
    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

struct JWTAuthenticator: HBAsyncAuthenticator {
    typealias Value = JWTPayloadData
    
    func authenticate(request: HBRequest) async throws -> JWTPayloadData? {
        guard let jwtToken = request.authBearer?.token ??
                request.headers.first(name: "permissions") else { throw HBHTTPError(.unauthorized) }
        
        @Dependency(\.configuration) var configuration
        let key = configuration.jwtSecret
        
        let signers = JWTSigners()
        do {
            signers.use(.hs256(key: key))
            let payload = try signers.verify(jwtToken, as: JWTPayloadData.self)
            return payload
        } catch {
            request.logger.debug("couldn't verify token")
            throw HBHTTPError(.unauthorized)
        }
    }
    
    let signers = JWTSigners()
    func create(email: String) async throws -> String {
        @Dependency(\.configuration) var configuration
        
        let key = configuration.jwtSecret
        
        signers.use(.hs256(key: key))
        let payload = JWTPayloadData(subject: SubjectClaim(value: "\(email)"),
                                     expiration: .init(value: Date().addingTimeInterval(50000)),
                                     isAdmin: false)
        
        let output = try signers.sign(payload)
        print(output)
        return output
    }
}
