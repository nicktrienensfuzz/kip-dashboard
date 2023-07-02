//
// ServiceError.swift
// Common
//
// Created by Nicholas Trienens on 5/19/20.
// Copyright © 2020 Fuzzproductions, LLC. All rights reserved.

import Foundation

open class NetworkClientError: Error, Codable, CustomDebugStringConvertible, CustomStringConvertible {
    public let message: String
    private let filename: String
    private let method: String
    private let line: Int

    private let object: AnyEncodable?
    private let statusCode: Int?

    public init(_ message: String, object: AnyEncodable? = nil, statusCode: Int? = nil, path: String = #file, function: String = #function, line: Int = #line) {
        if let file = path.split(separator: "/").last {
            filename = String(file)
        } else {
            filename = path
        }
        method = function
        self.line = line
        self.message = message
        self.object = object
        self.statusCode = statusCode
    }

    open var debugDescription: String { "\(filename):\(line) - \(method) => \(message)" }
    open var description: String { "\(filename):\(line) - \(method) => \(message)" }

    enum CodingKeys: String, CodingKey {
        case message
        case filename
        case method
        case line
        case object
        case type
        case statusCode
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(String.self, forKey: .message)
        filename = try values.decode(String.self, forKey: .filename)
        method = try values.decode(String.self, forKey: .method)
        line = try values.decode(Int.self, forKey: .line)
        statusCode = try? values.decode(Int.self, forKey: .statusCode)
        object = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode("Error", forKey: .type)

        try container.encode(message, forKey: .message)
        try container.encode(filename, forKey: .filename)
        try container.encode(method, forKey: .method)
        try container.encode(line, forKey: .line)
        try container.encode(statusCode, forKey: .statusCode)

        if let object = object {
            try container.encode(object, forKey: .object)
        }
    }
}
