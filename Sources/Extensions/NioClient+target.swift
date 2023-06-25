//
//  File.swift
//
//
//  Created by Nicholas Trienens on 8/4/21.
//

import AsyncHTTPClient
import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1

public class Endpoint: EndpointRequest {
    public let method: NIOHTTP1.HTTPMethod
    public let path: String
    public var headers: [String: String]?
    public let body: Data?

    public init(
        method: NIOHTTP1.HTTPMethod,
        path: String,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.body = body
        self.headers = headers
    }
}

public protocol EndpointRequest {
    var method: NIOHTTP1.HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }

    func cURLRepresentation() -> String
}

public extension EndpointRequest {
    func cURLRepresentation() -> String {
        var components = ["curl"]

        if method != NIOHTTP1.HTTPMethod.GET {
            components.append("-X \(method.rawValue)")
        }

        if let headers = headers {
            let headerStrings: [String] = headers.map { pair -> String in
                let escapedValue = String(describing: pair.value).replacingOccurrences(of: "\"", with: "\\\"")
                return "-H \"\(pair.key): \(escapedValue)\""
            }
            components.append(contentsOf: headerStrings)
        }

        if let httpBodyData = body, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            // let escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            components.append("-d '\(httpBody)'")
        }

        components.append("\"\(path)\"")
        return components.joined(separator: " ")
    }
}

public extension HTTPClient {
    func request(_ target: EndpointRequest, baseURLString _: String = "", printCurl: Bool = false) throws -> EventLoopFuture<HTTPClient.Response> {
        if printCurl {
            print(target.cURLRepresentation())
        }
        var request = try HTTPClient.Request(url: target.path, method: target.method)
        if let body = target.body {
            request.body = .data(body)
        }
        target.headers?.forEach { (key: String, value: String) in
            request.headers.add(name: key, value: value)
        }
        return execute(request: request)
    }
}

public extension HTTPClient.Response {
    func decode<T: Decodable>(
        type _: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        let value = try decoder.decode(T.self, from: body.unwrapped())
        return value
    }

    var data: Data? {
        guard var body = body else {
            return nil
        }
        guard let data = body.readData(length: body.readableBytes) else {
            return nil
        }
        return data
    }
}

public extension EventLoopFuture where Value == HTTPClient.Response {
    func decode<T: Decodable>(
        type _: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> EventLoopFuture<T> {
        flatMap { response -> EventLoopFuture<T> in
            do {
                let value = try decoder.decode(T.self, from: response.body.unwrapped())

                return self.eventLoop.makeSucceededFuture(value)
            } catch {
                print(error)
                if let body = response.body, let data = body.getData(at: 0, length: body.readableBytes) {
                    print(String(data: data, encoding: .utf8)?.prefix(3000).asString ?? "no Response")
                }
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }

    func toString() -> EventLoopFuture<String> {
        flatMap { response -> EventLoopFuture<String> in
            if let body = response.body, let data = body.getData(at: 0, length: body.readableBytes) {
                return self.eventLoop.makeSucceededFuture(String(data: data, encoding: .utf8) ?? "no Response")
            }
            return self.eventLoop.makeFailedFuture(NSError(domain: "decoding", code: 0, userInfo: nil))
        }
    }
}
