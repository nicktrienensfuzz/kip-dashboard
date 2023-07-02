import Foundation

// MARK: - Input
/*
 public struct CompletionSummaryDTO: Codable {
     public let associateList: [TimeToCompletionSummaryDTO]
     public let itemList: [TimeToCompletionSummaryDTO]
     public let items: OverallSummaryDTO
     public let orders: OverallSummaryDTO
     public let filteredAssociateItemsSummary: OverallSummaryDTO? = nil
     public let filteredItemSummary: OverallSummaryDTO? = nil
     public let locationId: String
     public let startDate: Date
     public let endDate: Date
 }
 */
// MARK: - EndInput

public struct CompletionSummaryDTO: Codable {
    public let associateList: [TimeToCompletionSummaryDTO]
    public let itemList: [TimeToCompletionSummaryDTO]
    public let items: OverallSummaryDTO
    public let orders: OverallSummaryDTO
    public let filteredAssociateItemsSummary: OverallSummaryDTO?
    public let filteredItemSummary: OverallSummaryDTO?
    public let locationId: String
    public let startDate: Date
    public let endDate: Date

    public init(
        associateList: [TimeToCompletionSummaryDTO],
        itemList: [TimeToCompletionSummaryDTO],
        items: OverallSummaryDTO,
        orders: OverallSummaryDTO,
        filteredAssociateItemsSummary: OverallSummaryDTO? = nil,
        filteredItemSummary: OverallSummaryDTO? = nil,
        locationId: String,
        startDate: Date,
        endDate: Date
    ) {
        self.associateList = associateList
        self.itemList = itemList
        self.items = items
        self.orders = orders
        self.filteredAssociateItemsSummary = filteredAssociateItemsSummary
        self.filteredItemSummary = filteredItemSummary
        self.locationId = locationId
        self.startDate = startDate
        self.endDate = endDate
    }

    enum CodingKeys: String, CodingKey {
        case associateList
        case itemList
        case items
        case orders
        case filteredAssociateItemsSummary
        case filteredItemSummary
        case locationId
        case startDate
        case endDate
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            associateList = try values.decode([TimeToCompletionSummaryDTO].self, forKey: .associateList)
        } catch {
            associateList = []
        }
        do {
            itemList = try values.decode([TimeToCompletionSummaryDTO].self, forKey: .itemList)
        } catch {
            itemList = []
        }
        items = try values.decode(OverallSummaryDTO.self, forKey: .items)
        orders = try values.decode(OverallSummaryDTO.self, forKey: .orders)
        filteredAssociateItemsSummary = try? values.decodeIfPresent(OverallSummaryDTO.self, forKey: .filteredAssociateItemsSummary)
        filteredItemSummary = try? values.decodeIfPresent(OverallSummaryDTO.self, forKey: .filteredItemSummary)
        locationId = try values.decode(String.self, forKey: .locationId)
        startDate = try values.decode(Date.self, forKey: .startDate)
        endDate = try values.decode(Date.self, forKey: .endDate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(associateList, forKey: .associateList)
        try container.encode(itemList, forKey: .itemList)
        try container.encode(items, forKey: .items)
        try container.encode(orders, forKey: .orders)
        if let value = filteredAssociateItemsSummary {
            try container.encode(value, forKey: .filteredAssociateItemsSummary)
        }
        if let value = filteredItemSummary {
            try container.encode(value, forKey: .filteredItemSummary)
        }
        try container.encode(locationId, forKey: .locationId)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
    }

    public func toSwift() -> String {
        """
        CompletionSummaryDTO(
            associateList: \(associateList),
            itemList: \(itemList),
            items: \(items),
            orders: \(orders),
            filteredAssociateItemsSummary: \(filteredAssociateItemsSummary != nil ? "\(filteredAssociateItemsSummary!)" : "nil"),
            filteredItemSummary: \(filteredItemSummary != nil ? "\(filteredItemSummary!)" : "nil"),
            locationId: "\(locationId)",
            startDate:  Date(timeIntervalSince1970: \(startDate.timeIntervalSince1970)),
            endDate:  Date(timeIntervalSince1970: \(endDate.timeIntervalSince1970))
            )
        """
    }
}
