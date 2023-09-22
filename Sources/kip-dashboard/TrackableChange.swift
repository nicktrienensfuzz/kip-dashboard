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
/**
 Documentation
 `TrackableChange` struct conforms to `Codable` protocol.
 This struct contains parameters that describe changes to objects.
 */
public struct TrackableChange: Codable {
    /// Date of the change
    public var date: Date
    
    /// Name of the thing that was changed
    public var name: String
    
    /// Description of the change
    public var description: String
    
    /// Expectation from the change
    public var expectations: String
    
    /// URL reference for more information on the change.
    public var referenceURL: String?
    
    public var metrics: [String]
    /// Initializes a new `TrackableChange`
    public init(
        date: Date,
        name: String,
        description: String,
        expectations: String,
        referenceURL: String? = nil,
        metrics: [String] = []

    ){
        self.date = date
        self.name = name
        self.description = description
        self.expectations = expectations
        self.referenceURL = referenceURL
        self.metrics = metrics
    }
    // Coding keys for the properties of `TrackableChange`.
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case name = "name"
        case description = "description"
        case expectations = "expectations"
        case referenceURL = "referenceURL"
        case metrics
    }
    /**
     Decodes a `TrackableChange` instance from the provided Decoder.
     
     - Parameter decoder: The decoder to read data from.
     */
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        expectations = try values.decode(String.self, forKey: .expectations)
        referenceURL = try? values.decodeIfPresent(String.self, forKey: .referenceURL)
        metrics = (try? values.decodeIfPresent([String].self, forKey: .metrics)) ?? []
    }
    /**
     Encodes this value into the given encoder.
     - Parameter encoder: The encoder to write data to.
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(expectations, forKey: .expectations)
        if let value = referenceURL {
            try container.encode(value, forKey: .referenceURL)
        }
        try container.encode(metrics, forKey: .metrics)
    }
    
    // Converts the `TrackableChange` instance back into a Swift equivalent.
    public func toSwift() -> String {
            """
            TrackableChange(
                date:  Date(timeIntervalSince1970: \(date.timeIntervalSince1970)),
                name: "\(name)",
                description: "\(description)",
                expectations: "\(expectations)",
                referenceURL: \(referenceURL != nil ? "\"\(referenceURL!)\"" : "nil")
                )
            """
    }
    
#if canImport(OrderedCollections)
    // Returns the list of attributes of a `TrackableChange` instance takes.
    public var attributes: OrderedDictionary<String, WritableKeyPath<TrackableChange, String>> {
        [
            "name":  \TrackableChange.name,
            "description":  \TrackableChange.description,
            "expectations":  \TrackableChange.expectations
        ]
    }
#endif
    /**
     Updates the instance of `TrackableChange` with the provided parameters.
     
     - Parameters:
     - date: An optional date.
     **Default: current instance's date**
     - name: An optional name.
     **Default: current instance's name**
     - description: An optional description.
     **Default: current instance's description**
     - expectations: An optional expectations.
     **Default: current instance's expectations**
     - referenceURL: An optional referenceURL.
     **Default: current instance's referenceURL**
     */
    public func updated(
        date: Date? = nil,
        name: String? = nil,
        description: String? = nil,
        expectations: String? = nil,
        referenceURL: String? = nil
    ) -> TrackableChange {
        return TrackableChange(
            date: date ?? self.date,
            name: name ?? self.name,
            description: description ?? self.description,
            expectations: expectations ?? self.expectations,
            referenceURL: referenceURL ?? self.referenceURL)
    }
}
