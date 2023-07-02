import Foundation


extension MenuOutage {
    var colorCode: String {
        if let lastedForSeconds {
            if lastedForSeconds  > 3600 * 12 {
                return "#FFDAD4"
            }
            if lastedForSeconds > 3600 * 3 {
                return "#FFF4D1"
            }
            return "#F8F9FB"
        }
        return "#D5F6FF"
    }
}
// MARK: - Input
/*
public struct MenuOutage:  Equatable, Codable {
    public let active: Bool
    public let createdAt: Date
    public let endedAt: Date? = nil
    public let id: String
    public let lastedForHuman: String? = nil
    public let lastedForSeconds: Int? = nil
    public let locationID: String
    public let modifierIDS: [String]
    public let needsConfirmation: Bool
    public let needsConfirmationAt: Date? = nil
    public let objectID: String
    public let outageBeganInSquare: Bool
    public let outageSetInSquare: Bool
    public let state: String
    public let title: String
    public let type: String
    public let parentOOS: String? = nil
}
*/
// MARK: - EndInput

public struct MenuOutage: Equatable, Hashable, Codable {
    public let active: Bool
    public let createdAt: Date
    public let endedAt: Date?
    public let id: String
    public let lastedForHuman: String?
    public let lastedForSeconds: Int?
    public let locationID: String
    public let modifierIDS: [String]
    public let needsConfirmation: Bool
    public let needsConfirmationAt: Date?
    public let objectID: String
    public let outageBeganInSquare: Bool
    public let outageSetInSquare: Bool
    public let state: String
    public let title: String
    public let type: String
    public let parentOOS: String?

    public init(
        active: Bool,
        createdAt: Date,
        endedAt: Date? = nil,
        id: String,
        lastedForHuman: String? = nil,
        lastedForSeconds: Int? = nil,
        locationID: String,
        modifierIDS: [String],
        needsConfirmation: Bool,
        needsConfirmationAt: Date? = nil,
        objectID: String,
        outageBeganInSquare: Bool,
        outageSetInSquare: Bool,
        state: String,
        title: String,
        type: String,
        parentOOS: String? = nil
    ){
        self.active = active
        self.createdAt = createdAt
        self.endedAt = endedAt
        self.id = id
        self.lastedForHuman = lastedForHuman
        self.lastedForSeconds = lastedForSeconds
        self.locationID = locationID
        self.modifierIDS = modifierIDS
        self.needsConfirmation = needsConfirmation
        self.needsConfirmationAt = needsConfirmationAt
        self.objectID = objectID
        self.outageBeganInSquare = outageBeganInSquare
        self.outageSetInSquare = outageSetInSquare
        self.state = state
        self.title = title
        self.type = type
        self.parentOOS = parentOOS
    }

    enum CodingKeys: String, CodingKey {
        case active = "active"
        case createdAt = "createdAt"
        case endedAt = "endedAt"
        case id = "id"
        case lastedForHuman = "lastedForHuman"
        case lastedForSeconds = "lastedForSeconds"
        case locationID = "locationId"
        case modifierIDS = "modifierIds"
        case needsConfirmation = "needsConfirmation"
        case needsConfirmationAt = "needsConfirmationAt"
        case objectID = "objectId"
        case outageBeganInSquare = "outageBeganInSquare"
        case outageSetInSquare = "outageSetInSquare"
        case state = "state"
        case title = "title"
        case type = "type"
        case parentOOS = "parentOOS"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decode(Bool.self, forKey: .active)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        endedAt = try? values.decodeIfPresent(Date.self, forKey: .endedAt)
        id = try values.decode(String.self, forKey: .id)
        lastedForHuman = try? values.decodeIfPresent(String.self, forKey: .lastedForHuman)
        lastedForSeconds = try? values.decodeIfPresent(Int.self, forKey: .lastedForSeconds)
        locationID = try values.decode(String.self, forKey: .locationID)
        do {
            modifierIDS = try values.decode([String].self, forKey: .modifierIDS)
        } catch {
            modifierIDS = []
        }
        needsConfirmation = try values.decode(Bool.self, forKey: .needsConfirmation)
        needsConfirmationAt = try? values.decodeIfPresent(Date.self, forKey: .needsConfirmationAt)
        objectID = try values.decode(String.self, forKey: .objectID)
        outageBeganInSquare = try values.decode(Bool.self, forKey: .outageBeganInSquare)
        outageSetInSquare = try values.decode(Bool.self, forKey: .outageSetInSquare)
        state = try values.decode(String.self, forKey: .state)
        title = try values.decode(String.self, forKey: .title)
        type = try values.decode(String.self, forKey: .type)
        parentOOS = try? values.decodeIfPresent(String.self, forKey: .parentOOS)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(active, forKey: .active)
        try container.encode(createdAt, forKey: .createdAt)
        if let value = endedAt {
            try container.encode(value, forKey: .endedAt)
        }
        try container.encode(id, forKey: .id)
        if let value = lastedForHuman {
            try container.encode(value, forKey: .lastedForHuman)
        }
        if let value = lastedForSeconds {
            try container.encode(value, forKey: .lastedForSeconds)
        }
        try container.encode(locationID, forKey: .locationID)
        try container.encode(modifierIDS, forKey: .modifierIDS)
        try container.encode(needsConfirmation, forKey: .needsConfirmation)
        if let value = needsConfirmationAt {
            try container.encode(value, forKey: .needsConfirmationAt)
        }
        try container.encode(objectID, forKey: .objectID)
        try container.encode(outageBeganInSquare, forKey: .outageBeganInSquare)
        try container.encode(outageSetInSquare, forKey: .outageSetInSquare)
        try container.encode(state, forKey: .state)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        if let value = parentOOS {
            try container.encode(value, forKey: .parentOOS)
        }
    }

    public func toSwift() -> String {
            """
            MenuOutage(
                active: \(active),
                createdAt:  Date(timeIntervalSince1970: \(createdAt.timeIntervalSince1970)),
                endedAt:  \(endedAt != nil ? "Date(timeIntervalSince1970: \(endedAt!.timeIntervalSince1970))" : "nil"),
                id: "\(id)",
                lastedForHuman: \(lastedForHuman != nil ? "\"\(lastedForHuman!)\"" : "nil"),
                lastedForSeconds: \(lastedForSeconds != nil ? "\(lastedForSeconds!)" : "nil"),
                locationID: "\(locationID)",
                modifierIDS: \(modifierIDS),
                needsConfirmation: \(needsConfirmation),
                needsConfirmationAt:  \(needsConfirmationAt != nil ? "Date(timeIntervalSince1970: \(needsConfirmationAt!.timeIntervalSince1970))" : "nil"),
                objectID: "\(objectID)",
                outageBeganInSquare: \(outageBeganInSquare),
                outageSetInSquare: \(outageSetInSquare),
                state: "\(state)",
                title: "\(title)",
                type: "\(type)",
                parentOOS: \(parentOOS != nil ? "\"\(parentOOS!)\"" : "nil")
                )
            """
    }
    public static func == (lhs: MenuOutage, rhs: MenuOutage) -> Bool {
        lhs.active == rhs.active &&
        lhs.createdAt == rhs.createdAt &&
        lhs.endedAt == rhs.endedAt &&
        lhs.id == rhs.id &&
        lhs.lastedForHuman == rhs.lastedForHuman &&
        lhs.lastedForSeconds == rhs.lastedForSeconds &&
        lhs.locationID == rhs.locationID &&
        lhs.modifierIDS == rhs.modifierIDS &&
        lhs.needsConfirmation == rhs.needsConfirmation &&
        lhs.needsConfirmationAt == rhs.needsConfirmationAt &&
        lhs.objectID == rhs.objectID &&
        lhs.outageBeganInSquare == rhs.outageBeganInSquare &&
        lhs.outageSetInSquare == rhs.outageSetInSquare &&
        lhs.state == rhs.state &&
        lhs.title == rhs.title &&
        lhs.type == rhs.type &&
        lhs.parentOOS == rhs.parentOOS
    }
 }
