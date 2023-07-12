//
//  RequestMaker.swift
//
//
//  Created by Nicholas Trienens on 3/27/23.
//

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import Foundation

public class RequestMaker: Requester {
    public init() {}

    public func makeRequest(_ endpoint: EndpointRequest) async throws -> Data {
        let urlReq = try await endpoint.request(baseUrl: "")
        // print(endpoint.cURLRepresentation())
        do {
            let longRunning = URLSessionConfiguration.default
            longRunning.timeoutIntervalForRequest = 300
            let (data, _) = try await request(urlRequest: urlReq, session: URLSession.init(configuration: longRunning))
            return data
        } catch {
            print(error)
            print(endpoint.cURLRepresentation())
            throw error
        }
    }

    public func makeRequestWithResponse(_ endpoint: EndpointRequest) async throws -> (Data, HTTPURLResponse) {
        let urlReq = try await endpoint.request(baseUrl: "")
        // print(endpoint.cURLRepresentation())
        do {
            let longRunning = URLSessionConfiguration.default
            longRunning.timeoutIntervalForRequest = 300
            return try await request(urlRequest: urlReq, session: URLSession.init(configuration: longRunning))
        } catch {
            print(error)
            print(endpoint.cURLRepresentation())
            throw error
        }
    }

    public func request(url: String?, session: URLSession = .shared) async throws -> (Data, HTTPURLResponse) {
        let request: URLRequest = try .init(url: URL(string: url.unwrapped()).unwrapped())

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            if #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) {
                let (data, response) = try await session.data(for: request)
                guard let response = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data, response)
            }
        #endif
        var dataTask: URLSessionDataTask?
        let cancel: () -> Void = { dataTask?.cancel() }

        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = session.dataTask(with: request) { data, response, error in
                        guard
                            let data = data,
                            let response = response as? HTTPURLResponse
                        else {
                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            return
                        }
                        continuation.resume(returning: (data, response))
                    }
                    dataTask?.resume()
                }
            },
            onCancel: { cancel() }
        )
    }

    public func request(urlRequest: URLRequest?, session: URLSession = .shared) async throws -> (Data, HTTPURLResponse) {
        let request: URLRequest = try urlRequest.unwrapped()
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            if #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) {
                let (data, response) = try await session.data(for: request)
                guard let response = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data, response)
            }
        #endif
        var dataTask: URLSessionDataTask?
        let cancel: () -> Void = { dataTask?.cancel() }

        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = session.dataTask(with: request) { data, response, error in
                        guard
                            let data = data,
                            let response = response as? HTTPURLResponse
                        else {
                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            return
                        }
                        continuation.resume(returning: (data, response))
                    }
                    dataTask?.resume()
                }

            },
            onCancel: { cancel() }
        )
    }
}

extension EndpointRequest {
    func constructURL(baseUrl: String, path: String) -> URL? {
        if path.hasPrefix("https://") || path.hasPrefix("http://"), let url = URL(string: path) {
            return url
        }
        return URL(string: baseUrl + path)
    }

    /// Build a reasonable URLRequest from a Endpoint
    /// - Parameter baseUrl String for the request
    /// - Parameter encoder to encode Codable pararmeters to json
    /// - Returns: URLRequest with parameter and headers added
    func request(baseUrl: String, encoder: JSONEncoder = JSONEncoder()) async throws -> URLRequest {
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
