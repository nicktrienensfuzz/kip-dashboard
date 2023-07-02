//
//  Encodable.swift
//
//
//  Created by Nicholas Trienens on 11/19/21.
//

import Foundation

public extension Encodable {
    func prettyPrint(_ encoder: JSONEncoder? = nil, outputFormatting: JSONEncoder.OutputFormatting = [.sortedKeys, .prettyPrinted]) {
        do {
            print(try toString(encoder, outputFormatting: outputFormatting))
        } catch {}
    }

    func toData(_ encoder: JSONEncoder? = nil, outputFormatting: JSONEncoder.OutputFormatting = [.sortedKeys, .prettyPrinted]) throws -> Data {
        var usableEncoder: JSONEncoder
        if let encoder = encoder {
            usableEncoder = encoder
        } else {
            usableEncoder = JSONEncoder()
            usableEncoder.dateEncodingStrategy = .iso8601
        }
        usableEncoder.outputFormatting = outputFormatting
        return try usableEncoder.encode(self)
    }

    func toString(_ encoder: JSONEncoder? = nil, outputFormatting: JSONEncoder.OutputFormatting = [.sortedKeys]) throws -> String {
        if let string = String(data: try toData(encoder, outputFormatting: outputFormatting), encoding: .utf8) {
            return string
        }
        throw ServiceError("String couldn't be created")
    }
}

public extension String {
    var asData: Data? {
        data(using: .utf8)
    }

    func decode<T: Decodable>(decoder: JSONDecoder? = nil) throws -> T {
        guard let data = asData else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "could not make data"))
        }
        let usedDecoder: JSONDecoder
        if let decoder = decoder {
            usedDecoder = decoder
        } else {
            usedDecoder = JSONDecoder()
            usedDecoder.dateDecodingStrategy = .iso8601
        }
        return try usedDecoder.decode(T.self, from: data)
    }
}

public extension Data {
    func decode<T: Decodable>(decoder: JSONDecoder? = nil) throws -> T {
        let usedDecoder: JSONDecoder
        if let decoder = decoder {
            usedDecoder = decoder
        } else {
            usedDecoder = JSONDecoder()
            usedDecoder.dateDecodingStrategy = .iso8601
        }
        return try usedDecoder.decode(T.self, from: self)
    }
}
