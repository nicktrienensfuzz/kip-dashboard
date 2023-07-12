//
//  Endpoint.swift
//  FuzzCombine
//
// Created by Nick Trienens on 3/12/20.
// Copyright © 2020 Fuzzproductions. All rights reserved.
//

import Foundation
#if canImport(NIOHTTP1)
    import NIOHTTP1
    public typealias HTTPMethod = NIOHTTP1.HTTPMethod
#else
    public enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case HEAD
        case OPTION
        case DELETE
    }
#endif
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public protocol EndpointRequest {
    var method: HTTPMethod { get }
    var urlPath: String { get }
    var headers: [String: String]? { get }
    var parameters: [Parameters] { get }

    func cURLRepresentation() -> String

    func requestBody() throws -> Data?
    func requestBody(encoder: JSONEncoder) throws -> Data?
    func requestQueryString() -> String
}

// MARK: - Endpoint Helpers
public enum Parameters {
    case parameter([String: String], Encoding)
    case encodable(AnyEncodable, Encoding)
    case encodableWithCoder(AnyEncodable, Encoding, JSONEncoder)
    case rawBody(Data)
}

open class Endpoint: EndpointRequest {
    public let method: HTTPMethod
    public let urlPath: String
    open var headers: [String: String]?
    open var parameters: [Parameters]

    // Build a Endpoint
    public init(
        method: HTTPMethod,
        path: String,
        parameters: [Parameters],
        headers: [String: String]? = nil
    ) {
        self.method = method
        self.parameters = parameters
        self.headers = headers
        urlPath = path
    }

    public init(
        method: HTTPMethod,
        path: String,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        self.method = method
        if let body {
            parameters = [.rawBody(body)]
        } else {
            parameters = []
        }
        self.headers = headers
        urlPath = path
    }

    open func constructURL(baseUrl: String, path: String) -> URL? {
        if path.hasPrefix("https://") || path.hasPrefix("http://"), let url = URL(string: path) {
            return url
        }
        return URL(string: baseUrl + path)
    }

    public func requestQueryString() -> String {
        for parameter in parameters {
            switch parameter {
            case let .parameter(params, encoding):
                switch encoding {
                case .queryString:
                    return params.httpParameters()
                default: break
                }
            default: break
            }
        }
        return ""
    }

    public func requestBody() throws -> Data? {
        try requestBody(encoder: JSONEncoder())
    }

    open func requestBody(encoder: JSONEncoder = JSONEncoder()) throws -> Data? {
        var body: Data?
        do {
            try parameters.forEach { parameter in
                switch parameter {
                case let .parameter(params, encoding):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(params)
                    case .urlEncodedBody:
                        body = params.httpParameters(includeQuestionMark: false).data(using: .utf8)
                    default: break
                    }
                case let .encodable(wrapper, encoding):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(wrapper)
                    case .queryString, .urlEncodedBody:
                        throw NetworkClientError("Couldn't encode anyEncodable to queryString")
                    }
                case let .encodableWithCoder(wrapper, encoding, encoder):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(wrapper)
                    case .queryString, .urlEncodedBody:
                        throw NetworkClientError("Couldn't encode anyEncodable to queryString")
                    }
                case let .rawBody(data):
                    body = data
                }
            }
        } catch {
            throw NetworkClientError(error.localizedDescription)
        }
        return body
    }

//
//    /// Build a reasonable URLRequest from a Endpoint
//    /// - Parameter baseUrl String for the request
//    /// - Parameter encoder to encode Codable pararmeters to json
//    /// - Returns: URLRequest with parameter and headers added
    open func request(baseUrl: String, encoder: JSONEncoder = JSONEncoder()) async throws -> URLRequest {
        var path = urlPath

        var body: Data?
        do {
            try parameters.forEach { parameter in
                switch parameter {
                case let .parameter(params, encoding):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(params)
                    case .urlEncodedBody:
                        body = params.httpParameters(includeQuestionMark: false).data(using: .utf8)
                    case .queryString:
                        path += params.httpParameters()
                    }
                case let .encodable(wrapper, encoding):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(wrapper)
                    case .queryString, .urlEncodedBody:
                        throw NetworkClientError("Couldn't encode anyEncodable to  queryString")
                    }
                case let .encodableWithCoder(wrapper, encoding, encoder):
                    switch encoding {
                    case .body:
                        body = try encoder.encode(wrapper)
                    case .queryString, .urlEncodedBody:
                        throw NetworkClientError("Couldn't encode anyEncodable to queryString")
                    }
                case let .rawBody(data):
                    body = data
                }
            }
        } catch {
            throw NetworkClientError(error.localizedDescription)
        }

        guard let url = constructURL(baseUrl: baseUrl, path: path) else {
            throw NetworkClientError("request url could not be constructed")
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = body
        }

        let completeRequest = request as URLRequest
        return completeRequest
    }
}

//
//// typeEaraser Wrapper around Encodable
// public struct AnyEncodable: Encodable {
//    public let encodable: Encodable
//
//    public init(_ encodable: Encodable) {
//        self.encodable = encodable
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        try encodable.encode(to: encoder)
//    }
// }

public enum Encoding: String {
    case body
    case queryString
    case urlEncodedBody
}

public extension String {
    /**
       Returns a new string made from the receiver by replacing characters which are
       reserved in a URI query with percent encoded characters.

       The following characters are not considered reserved in a URI query
       by RFC 3986:

       - Alpha "a...z" "A...Z"
       - Numberic "0...9"
       - Unreserved "-._~"

       In addition the reserved characters "/" and "?" have no reserved purpose in the
       query component of a URI so do not need to be percent escaped.

       - Returns: The encoded string, or nil if the transformation is not possible.
     */

    func stringByAddingPercentEncodingForRFC3986() -> String {
        let unreserved = "-._~/?"
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet) ?? self
    }

    /**
     Returns a new string made from the receiver by replacing characters which are
     reserved in HTML forms (media type application/x-www-form-urlencoded) with
     percent encoded characters.

     The W3C HTML5 specification, section 4.10.22.5 URL-encoded form
     data percent encodes all characters except the following:

     - Space (0x20) is replaced by a "+" (0x2B)
     - Bytes in the range 0x2A, 0x2D, 0x2E, 0x30-0x39, 0x41-0x5A, 0x5F, 0x61-0x7A
       (alphanumeric + "*-._")
     - Parameter plusForSpace: Boolean, when true replaces space with a '+'
     otherwise uses percent encoding (%20). Default is false.

     - Returns: The encoded string, or nil if the transformation is not possible.
     */

    func stringByAddingPercentEncodingForFormData(plusForSpace: Bool = false) -> String {
        let unreserved = "*-._"
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: unreserved)

        if plusForSpace {
            allowedCharacterSet.addCharacters(in: " ")
        }

        var encoded = addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded ?? self
    }
}

public extension Dictionary where Key == String, Value == String {
    func httpParameters(includeQuestionMark: Bool = true) -> String {
        var p = ""
        if includeQuestionMark {
            p += "?"
        }

        forEach {
            p = p + "\($0.stringByAddingPercentEncodingForFormData())=\($1.stringByAddingPercentEncodingForFormData())" + "&"
        }
        if p.last == "&" {
            p.removeLast()
        }
        return p
    }
}

public extension EndpointRequest {
    func cURLRepresentation() -> String {
        var components = ["curl"]

        if method != HTTPMethod.GET {
            components.append("-X \(method.rawValue)")
        }

        if let headers = headers {
            let headerStrings: [String] = headers.map { pair -> String in
                let escapedValue = String(describing: pair.value).replacingOccurrences(of: "\"", with: "\\\"")
                return "-H \"\(pair.key): \(escapedValue)\""
            }
            components.append(contentsOf: headerStrings)
        }

        if let httpBodyData = try? requestBody(), let httpBody = String(data: httpBodyData, encoding: .utf8) {
            // let escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            components.append("-d '\(httpBody)'")
        }

        components.append("\"\(urlPath + requestQueryString())\"")
        return components.joined(separator: "\n\t")
    }
}
