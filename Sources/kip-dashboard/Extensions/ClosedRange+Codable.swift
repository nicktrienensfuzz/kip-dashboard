////
////  ClosedRange+Codable.swift
////  
////
////  Created by Nicholas Trienens on 9/21/23.
////
//
//import Foundation
//
//extension ClosedRange: Codable where Bound: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case lowerBound = "from"
//        case upperBound = "through"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let lowerBound = try container.decode(Bound.self, forKey: .lowerBound)
//        let upperBound = try container.decode(Bound.self, forKey: .upperBound)
//        guard lowerBound <= upperBound else {
//            throw DecodingError.dataCorruptedError(
//                forKey: CodingKeys.upperBound,
//                in: container,
//                debugDescription: "upperBound (through) cannot be less than lowerBound (from)"
//            )
//        }
//        self = lowerBound...upperBound
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.lowerBound, forKey: .lowerBound)
//        try container.encode(self.upperBound, forKey: .upperBound)
//    }
//}
//
//extension Range: Codable where Bound: Codable {
//
//    private enum CodingKeys: String, CodingKey {
//        case lowerBound = "from"
//        case upperBound = "upTo"
//    }
//
//    public init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let lowerBound = try container.decode(Bound.self, forKey: .lowerBound)
//        let upperBound = try container.decode(Bound.self, forKey: .upperBound)
//
//        guard lowerBound <= upperBound else {
//            throw DecodingError.dataCorruptedError(
//                forKey: CodingKeys.upperBound,
//                in: container,
//                debugDescription: "upperBound (upTo) cannot be less than lowerBound (from)"
//            )
//        }
//
//        self = lowerBound..<upperBound
//    }
//
//    public func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(self.lowerBound, forKey: .lowerBound)
//        try container.encode(self.upperBound, forKey: .upperBound)
//    }
//}
//
//extension PartialRangeUpTo: Codable where Bound: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case upperBound = "fromStartUpTo"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self = try (..<container.decode(Bound.self, forKey: .upperBound))
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.upperBound, forKey: .upperBound)
//    }
//}
//
//extension PartialRangeThrough: Codable where Bound: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case upperBound = "fromStartThrough"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self = try (...container.decode(Bound.self, forKey: .upperBound))
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.upperBound, forKey: .upperBound)
//    }
//}
//
//extension PartialRangeFrom: Codable where Bound: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case lowerBound = "toEndFrom"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self = try container.decode(Bound.self, forKey: .lowerBound)...
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.lowerBound, forKey: .lowerBound)
//    }
//}
