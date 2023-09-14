//
//  TrackableChange.swift
//  
//
//  Created by Nicholas Trienens on 9/13/23.
//

import Foundation

#if canImport(OrderedCollections)
import OrderedCollections
#endif
// MARK: - Input
/*
public struct TrackableChange: Codable {
    public var date: Date
    public var name: String
    public var description: String
    public var expectations: String
}
*/
// MARK: - EndInput

public struct TrackableChange: Codable {
    public var date: Date
    public var name: String
    public var description: String
    public var expectations: String

    public init(
        date: Date,
        name: String,
        description: String,
        expectations: String
    ){
        self.date = date
        self.name = name
        self.description = description
        self.expectations = expectations
    }

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case name = "name"
        case description = "description"
        case expectations = "expectations"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        expectations = try values.decode(String.self, forKey: .expectations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(expectations, forKey: .expectations)
    }

    public func toSwift() -> String {
            """
            TrackableChange(
                date:  Date(timeIntervalSince1970: \(date.timeIntervalSince1970)),
                name: "\(name)",
                description: "\(description)",
                expectations: "\(expectations)"
                )
            """
    }
    #if canImport(OrderedCollections)
        public var attributes: OrderedDictionary<String, WritableKeyPath<TrackableChange, String>> {
                [
                                                        "name":  \TrackableChange.name,                    "description":  \TrackableChange.description,                    "expectations":  \TrackableChange.expectations
               ]
        }
    #endif

        public func updated(
            date: Date? = nil,
            name: String? = nil,
            description: String? = nil,
            expectations: String? = nil
        ) -> TrackableChange {
            return TrackableChange(
                date: date ?? self.date,
                name: name ?? self.name,
                description: description ?? self.description,
                expectations: expectations ?? self.expectations)
        }
 }
