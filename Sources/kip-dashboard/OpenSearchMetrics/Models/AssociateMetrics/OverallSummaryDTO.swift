import Foundation

// MARK: - Input
/*
 public struct OverallSummaryDTO: Codable {
     public let averagePlacedToClaimed: Float
     public let averagePlacedToCompletion: Float
     public let averageClaimedToCompletion: Float
     public let count: Int
     public let averageOrdersPerDay: Int
 }
 */
// MARK: - EndInput

public struct OverallSummaryDTO: Codable {
    public let averagePlacedToClaimed: Float
    public let averagePlacedToCompletion: Float
    public let averageClaimedToCompletion: Float
    public let count: Int
    public let averageOrdersPerDay: Int

    public init(
        averagePlacedToClaimed: Float,
        averagePlacedToCompletion: Float,
        averageClaimedToCompletion: Float,
        count: Int,
        averageOrdersPerDay: Int
    ) {
        self.averagePlacedToClaimed = averagePlacedToClaimed
        self.averagePlacedToCompletion = averagePlacedToCompletion
        self.averageClaimedToCompletion = averageClaimedToCompletion
        self.count = count
        self.averageOrdersPerDay = averageOrdersPerDay
    }

    enum CodingKeys: String, CodingKey {
        case averagePlacedToClaimed
        case averagePlacedToCompletion
        case averageClaimedToCompletion
        case count
        case averageOrdersPerDay
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        averagePlacedToClaimed = try values.decode(Float.self, forKey: .averagePlacedToClaimed)
        averagePlacedToCompletion = try values.decode(Float.self, forKey: .averagePlacedToCompletion)
        averageClaimedToCompletion = try values.decode(Float.self, forKey: .averageClaimedToCompletion)
        count = try values.decode(Int.self, forKey: .count)
        averageOrdersPerDay = try values.decode(Int.self, forKey: .averageOrdersPerDay)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(averagePlacedToClaimed, forKey: .averagePlacedToClaimed)
        try container.encode(averagePlacedToCompletion, forKey: .averagePlacedToCompletion)
        try container.encode(averageClaimedToCompletion, forKey: .averageClaimedToCompletion)
        try container.encode(count, forKey: .count)
        try container.encode(averageOrdersPerDay, forKey: .averageOrdersPerDay)
    }

    public func toSwift() -> String {
        """
        OverallSummaryDTO(
            averagePlacedToClaimed: \(averagePlacedToClaimed),
            averagePlacedToCompletion: \(averagePlacedToCompletion),
            averageClaimedToCompletion: \(averageClaimedToCompletion),
            count: \(count),
            averageOrdersPerDay: \(averageOrdersPerDay))
        """
    }
}
