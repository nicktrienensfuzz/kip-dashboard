//
//  Requester.swift
//
//
//  Created by Nicholas Trienens on 11/24/22.
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public protocol Requester {
    func makeRequest(_ endpoint: EndpointRequest) async throws -> Data
    func makeRequestWithResponse(_ endpoint: EndpointRequest) async throws -> (Data, HTTPURLResponse)
}
