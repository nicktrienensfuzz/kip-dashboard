import Foundation

// MARK: - Input
/*
 public struct TimeToCompletionSummaryDTO: Codable {
     public let averageClaimedToCompletion: Float
     public let count: Int
     public let maxClaimedToCompletion: Float
     public let minClaimedToCompletion: Float
     public let title: String
     public let id: String
 }
 */
// MARK: - EndInput

public struct TimeToCompletionSummaryDTO: Codable {
    public let averageClaimedToCompletion: Float
    public let count: Int
    public let maxClaimedToCompletion: Float
    public let minClaimedToCompletion: Float
    public let title: String
    public let id: String

    public init(
        averageClaimedToCompletion: Float,
        count: Int,
        maxClaimedToCompletion: Float,
        minClaimedToCompletion: Float,
        title: String,
        id: String
    ) {
        self.averageClaimedToCompletion = averageClaimedToCompletion
        self.count = count
        self.maxClaimedToCompletion = maxClaimedToCompletion
        self.minClaimedToCompletion = minClaimedToCompletion
        self.title = title
        self.id = id
    }

    enum CodingKeys: String, CodingKey {
        case averageClaimedToCompletion
        case count
        case maxClaimedToCompletion
        case minClaimedToCompletion
        case title
        case id
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        averageClaimedToCompletion = try values.decode(Float.self, forKey: .averageClaimedToCompletion)
        count = try values.decode(Int.self, forKey: .count)
        maxClaimedToCompletion = try values.decode(Float.self, forKey: .maxClaimedToCompletion)
        minClaimedToCompletion = try values.decode(Float.self, forKey: .minClaimedToCompletion)
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(averageClaimedToCompletion, forKey: .averageClaimedToCompletion)
        try container.encode(count, forKey: .count)
        try container.encode(maxClaimedToCompletion, forKey: .maxClaimedToCompletion)
        try container.encode(minClaimedToCompletion, forKey: .minClaimedToCompletion)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
    }

    public func toSwift() -> String {
        """
        TimeToCompletionSummaryDTO(
            averageClaimedToCompletion: \(averageClaimedToCompletion),
            count: \(count),
            maxClaimedToCompletion: \(maxClaimedToCompletion),
            minClaimedToCompletion: \(minClaimedToCompletion),
            title: "\(title)",
            id: "\(id)"
            )
        """
    }
}
