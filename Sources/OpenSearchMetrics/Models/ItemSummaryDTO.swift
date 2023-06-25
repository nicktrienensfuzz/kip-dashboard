//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 1/17/23.
//

import Foundation

// MARK: - Input
/*
public struct ItemSummaryDTO: Codable {
    public let averagePlacedToClaimed: Float
    public let averagePlacedToCompletion: Float
    public let averageClaimedToCompletion: Float
    public let count: Int
    public let itemName: String
}
*/
// MARK: - EndInput

public struct ItemSummaryDTO: Codable {
    public let averagePlacedToClaimed: Float
    public let averagePlacedToCompletion: Float
    public let averageClaimedToCompletion: Float
    public let count: Int
    public let itemName: String

    public init(
        averagePlacedToClaimed: Float,
        averagePlacedToCompletion: Float,
        averageClaimedToCompletion: Float,
        count: Int,
        itemName: String
    ){
        self.averagePlacedToClaimed = averagePlacedToClaimed
        self.averagePlacedToCompletion = averagePlacedToCompletion
        self.averageClaimedToCompletion = averageClaimedToCompletion
        self.count = count
        self.itemName = itemName
    }

    enum CodingKeys: String, CodingKey {
        case averagePlacedToClaimed = "averagePlacedToClaimed"
        case averagePlacedToCompletion = "averagePlacedToCompletion"
        case averageClaimedToCompletion = "averageClaimedToCompletion"
        case count = "count"
        case itemName = "itemName"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        averagePlacedToClaimed = try values.decode(Float.self, forKey: .averagePlacedToClaimed)
        averagePlacedToCompletion = try values.decode(Float.self, forKey: .averagePlacedToCompletion)
        averageClaimedToCompletion = try values.decode(Float.self, forKey: .averageClaimedToCompletion)
        count = try values.decode(Int.self, forKey: .count)
        itemName = try values.decode(String.self, forKey: .itemName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(averagePlacedToClaimed, forKey: .averagePlacedToClaimed)
        try container.encode(averagePlacedToCompletion, forKey: .averagePlacedToCompletion)
        try container.encode(averageClaimedToCompletion, forKey: .averageClaimedToCompletion)
        try container.encode(count, forKey: .count)
        try container.encode(itemName, forKey: .itemName)
    }

    public func toSwift() -> String {
            """
            ItemSummaryDTO(
                averagePlacedToClaimed: \(averagePlacedToClaimed),
                averagePlacedToCompletion: \(averagePlacedToCompletion),
                averageClaimedToCompletion: \(averageClaimedToCompletion),
                count: \(count),
                itemName: "\(itemName)"
                )
            """
    }
 }
