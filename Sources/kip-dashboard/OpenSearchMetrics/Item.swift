//
//  Item.swift
//  
//
//  Created by Nicholas Trienens on 1/13/23.
//

import Foundation

import Foundation

// MARK: - Input
/*
struct Item: Codable {
    let associate: ItemAssociateObject
    let catalogId: String
    let claimedToCompletion: Double
    let completedAt: Date
    let cost: Double
    let id: String
    let inProgressAt: Date
    let locationId: String
    let modifierCount: Double
    let modifiers: [ModifiersElement]
    let name: String
    let nameOnKDS: String
    let orderId: String
    let orderSessionStartedAt: String
    let placedAt: Date
    let placedAtPacificDate: String
    let placedAtPacificDayOfWeek: String
    let placedAtPacificHour: Double
    let placedToClaimed: Double
    let placedToCompletion: Double
    let rawLineItem: RawLineItemObject
    let startSessionToCompletion: Double
    let startSessionToPlaced: Double
    let state: String
    let uid: String
}
*/
// MARK: - EndInput

struct Item: Codable, CustomDebugStringConvertible {
    var debugDescription: String {
        "id: \(id), placedAt: \(placedAt)"
    }
    
    var placedToCompleted: DateInterval {
        DateInterval(start: placedAt, end: completedAt)
    }
    var claimedToCompleted: DateInterval {
        DateInterval(start: inProgressAt, end: completedAt)
    }
    let associate: ItemAssociateObject
    let catalogId: String
    let claimedToCompletion: Double
    let completedAt: Date
    let cost: Double
    let id: String
    let inProgressAt: Date
    let locationId: String
    let modifierCount: Double
    let modifiers: [ModifiersElement]
    let name: String
    let nameOnKDS: String
    let orderId: String
    let orderSessionStartedAt: String?
    let placedAt: Date
    let placedAtPacificDate: String
    let placedAtPacificDayOfWeek: String
    let placedAtPacificHour: Double
    let placedToClaimed: Double
    let placedToCompletion: Double
    let rawLineItem: RawLineItemObject
    let startSessionToCompletion: Double?
    let startSessionToPlaced: Double?
    let state: String
    let uid: String

    init(
        associate: ItemAssociateObject,
        catalogId: String,
        claimedToCompletion: Double,
        completedAt: Date,
        cost: Double,
        id: String,
        inProgressAt: Date,
        locationId: String,
        modifierCount: Double,
        modifiers: [ModifiersElement],
        name: String,
        nameOnKDS: String,
        orderId: String,
        orderSessionStartedAt: String?,
        placedAt: Date,
        placedAtPacificDate: String,
        placedAtPacificDayOfWeek: String,
        placedAtPacificHour: Double,
        placedToClaimed: Double,
        placedToCompletion: Double,
        rawLineItem: RawLineItemObject,
        startSessionToCompletion: Double?,
        startSessionToPlaced: Double?,
        state: String,
        uid: String
    ){
        self.associate = associate
        self.catalogId = catalogId
        self.claimedToCompletion = claimedToCompletion
        self.completedAt = completedAt
        self.cost = cost
        self.id = id
        self.inProgressAt = inProgressAt
        self.locationId = locationId
        self.modifierCount = modifierCount
        self.modifiers = modifiers
        self.name = name
        self.nameOnKDS = nameOnKDS
        self.orderId = orderId
        self.orderSessionStartedAt = orderSessionStartedAt
        self.placedAt = placedAt
        self.placedAtPacificDate = placedAtPacificDate
        self.placedAtPacificDayOfWeek = placedAtPacificDayOfWeek
        self.placedAtPacificHour = placedAtPacificHour
        self.placedToClaimed = placedToClaimed
        self.placedToCompletion = placedToCompletion
        self.rawLineItem = rawLineItem
        self.startSessionToCompletion = startSessionToCompletion
        self.startSessionToPlaced = startSessionToPlaced
        self.state = state
        self.uid = uid
    }

    enum CodingKeys: String, CodingKey {
        case associate = "associate"
        case catalogId = "catalogId"
        case claimedToCompletion = "claimedToCompletion"
        case completedAt = "completedAt"
        case cost = "cost"
        case id = "id"
        case inProgressAt = "inProgressAt"
        case locationId = "locationId"
        case modifierCount = "modifierCount"
        case modifiers = "modifiers"
        case name = "name"
        case nameOnKDS = "nameOnKDS"
        case orderId = "orderId"
        case orderSessionStartedAt = "orderSessionStartedAt"
        case placedAt = "placedAt"
        case placedAtPacificDate = "placedAtPacificDate"
        case placedAtPacificDayOfWeek = "placedAtPacificDayOfWeek"
        case placedAtPacificHour = "placedAtPacificHour"
        case placedToClaimed = "placedToClaimed"
        case placedToCompletion = "placedToCompletion"
        case rawLineItem = "rawLineItem"
        case startSessionToCompletion = "startSessionToCompletion"
        case startSessionToPlaced = "startSessionToPlaced"
        case state = "state"
        case uid = "uid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        associate = try values.decode(ItemAssociateObject.self, forKey: .associate)
        catalogId = try values.decode(String.self, forKey: .catalogId)
        claimedToCompletion = try values.decode(Double.self, forKey: .claimedToCompletion)
        completedAt = try values.decode(Date.self, forKey: .completedAt)
        cost = try values.decode(Double.self, forKey: .cost)
        id = try values.decode(String.self, forKey: .id)
        inProgressAt = try values.decode(Date.self, forKey: .inProgressAt)
        locationId = try values.decode(String.self, forKey: .locationId)
        modifierCount = try values.decode(Double.self, forKey: .modifierCount)
        do {
            modifiers = try values.decode([ModifiersElement].self, forKey: .modifiers)
        } catch {
            modifiers = []
        }
        name = try values.decode(String.self, forKey: .name)
        nameOnKDS = try values.decode(String.self, forKey: .nameOnKDS)
        orderId = try values.decode(String.self, forKey: .orderId)
        orderSessionStartedAt = try? values.decode(String.self, forKey: .orderSessionStartedAt)
        placedAt = try values.decode(Date.self, forKey: .placedAt)
        placedAtPacificDate = try values.decode(String.self, forKey: .placedAtPacificDate)
        placedAtPacificDayOfWeek = try values.decode(String.self, forKey: .placedAtPacificDayOfWeek)
        placedAtPacificHour = try values.decode(Double.self, forKey: .placedAtPacificHour)
        placedToClaimed = try values.decode(Double.self, forKey: .placedToClaimed)
        placedToCompletion = try values.decode(Double.self, forKey: .placedToCompletion)
        rawLineItem = try values.decode(RawLineItemObject.self, forKey: .rawLineItem)
        startSessionToCompletion = try? values.decode(Double.self, forKey: .startSessionToCompletion)
        startSessionToPlaced = try? values.decode(Double.self, forKey: .startSessionToPlaced)
        state = try values.decode(String.self, forKey: .state)
        uid = try values.decode(String.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(associate, forKey: .associate)
        try container.encode(catalogId, forKey: .catalogId)
        try container.encode(claimedToCompletion, forKey: .claimedToCompletion)
        try container.encode(completedAt, forKey: .completedAt)
        try container.encode(cost, forKey: .cost)
        try container.encode(id, forKey: .id)
        try container.encode(inProgressAt, forKey: .inProgressAt)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(modifierCount, forKey: .modifierCount)
        try container.encode(modifiers, forKey: .modifiers)
        try container.encode(name, forKey: .name)
        try container.encode(nameOnKDS, forKey: .nameOnKDS)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(orderSessionStartedAt, forKey: .orderSessionStartedAt)
        try container.encode(placedAt, forKey: .placedAt)
        try container.encode(placedAtPacificDate, forKey: .placedAtPacificDate)
        try container.encode(placedAtPacificDayOfWeek, forKey: .placedAtPacificDayOfWeek)
        try container.encode(placedAtPacificHour, forKey: .placedAtPacificHour)
        try container.encode(placedToClaimed, forKey: .placedToClaimed)
        try container.encode(placedToCompletion, forKey: .placedToCompletion)
        try container.encode(rawLineItem, forKey: .rawLineItem)
        try container.encode(startSessionToCompletion, forKey: .startSessionToCompletion)
        try container.encode(startSessionToPlaced, forKey: .startSessionToPlaced)
        try container.encode(state, forKey: .state)
        try container.encode(uid, forKey: .uid)
    }

    func toSwift() -> String {
            """
            Item(
                associate: \(associate),
                catalogId: "\(catalogId)",
                claimedToCompletion: \(claimedToCompletion),
                completedAt:  Date(timeIntervalSince1970: \(completedAt.timeIntervalSince1970)),
                cost: \(cost),
                id: "\(id)",
                inProgressAt:  Date(timeIntervalSince1970: \(inProgressAt.timeIntervalSince1970)),
                locationId: "\(locationId)",
                modifierCount: \(modifierCount),
                modifiers: \(modifiers),
                name: "\(name)",
                nameOnKDS: "\(nameOnKDS)",
                orderId: "\(orderId)",
                orderSessionStartedAt: "\(orderSessionStartedAt ?? "")",
                placedAt:  Date(timeIntervalSince1970: \(placedAt.timeIntervalSince1970)),
                placedAtPacificDate: "\(placedAtPacificDate)",
                placedAtPacificDayOfWeek: "\(placedAtPacificDayOfWeek)",
                placedAtPacificHour: \(placedAtPacificHour),
                placedToClaimed: \(placedToClaimed),
                placedToCompletion: \(placedToCompletion),
                rawLineItem: \(rawLineItem),
                startSessionToCompletion: \(startSessionToCompletion ?? 0),
                startSessionToPlaced: \(startSessionToPlaced ?? 0),
                state: "\(state)",
                uid: "\(uid)"
                )
            """
    }
 }


// MARK: - Input
/*
struct ItemAssociateObject: Codable {
    let active: Bool
    let id: String
    let locationId: String
    let name: String
    let order: Double
}
*/
// MARK: - EndInput

struct ItemAssociateObject: Codable {
    let active: Bool
    let id: String
    let locationId: String
    let name: String
    let order: Double

    init(
        active: Bool,
        id: String,
        locationId: String,
        name: String,
        order: Double
    ){
        self.active = active
        self.id = id
        self.locationId = locationId
        self.name = name
        self.order = order
    }

    enum CodingKeys: String, CodingKey {
        case active = "active"
        case id = "id"
        case locationId = "locationId"
        case name = "name"
        case order = "order"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decode(Bool.self, forKey: .active)
        id = try values.decode(String.self, forKey: .id)
        locationId = try values.decode(String.self, forKey: .locationId)
        name = try values.decode(String.self, forKey: .name)
        order = try values.decode(Double.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(active, forKey: .active)
        try container.encode(id, forKey: .id)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(name, forKey: .name)
        try container.encode(order, forKey: .order)
    }

    func toSwift() -> String {
            """
            ItemAssociateObject(
                active: \(active),
                id: "\(id)",
                locationId: "\(locationId)",
                name: "\(name)",
                order: \(order))
            """
    }
 }
import Foundation

// MARK: - Input
/*
struct RawLineItemObject: Codable {
    let associate: AssociateObject
    let catalogId: String
    let completedAt: Double
    let cost: Double
    let id: String
    let imageUrl: String
    let inProgressAt: Double
    let locationId: String
    let modifiers: [ModifiersElement]
    let name: String
    let nameOnKDS: String
    let orderId: String
    let orderName: String
    let placedAt: Double
    let plu: String
    let state: String
    let uid: String
    let version: Double
}
*/
// MARK: - EndInput

struct RawLineItemObject: Codable {
    let associate: AssociateObject
    let catalogId: String
    let completedAt: Double
    let cost: Double
    let id: String
    let imageUrl: String
    let inProgressAt: Double
    let locationId: String
    let modifiers: [ModifiersElement]
    let name: String
    let nameOnKDS: String
    let orderId: String
    let orderName: String
    let placedAt: Double
    let plu: String
    let state: String
    let uid: String
    let version: Double

    init(
        associate: AssociateObject,
        catalogId: String,
        completedAt: Double,
        cost: Double,
        id: String,
        imageUrl: String,
        inProgressAt: Double,
        locationId: String,
        modifiers: [ModifiersElement],
        name: String,
        nameOnKDS: String,
        orderId: String,
        orderName: String,
        placedAt: Double,
        plu: String,
        state: String,
        uid: String,
        version: Double
    ){
        self.associate = associate
        self.catalogId = catalogId
        self.completedAt = completedAt
        self.cost = cost
        self.id = id
        self.imageUrl = imageUrl
        self.inProgressAt = inProgressAt
        self.locationId = locationId
        self.modifiers = modifiers
        self.name = name
        self.nameOnKDS = nameOnKDS
        self.orderId = orderId
        self.orderName = orderName
        self.placedAt = placedAt
        self.plu = plu
        self.state = state
        self.uid = uid
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case associate = "associate"
        case catalogId = "catalogId"
        case completedAt = "completedAt"
        case cost = "cost"
        case id = "id"
        case imageUrl = "imageUrl"
        case inProgressAt = "inProgressAt"
        case locationId = "locationId"
        case modifiers = "modifiers"
        case name = "name"
        case nameOnKDS = "nameOnKDS"
        case orderId = "orderId"
        case orderName = "orderName"
        case placedAt = "placedAt"
        case plu = "plu"
        case state = "state"
        case uid = "uid"
        case version = "version"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        associate = try values.decode(AssociateObject.self, forKey: .associate)
        catalogId = try values.decode(String.self, forKey: .catalogId)
        completedAt = try values.decode(Double.self, forKey: .completedAt)
        cost = try values.decode(Double.self, forKey: .cost)
        id = try values.decode(String.self, forKey: .id)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        inProgressAt = try values.decode(Double.self, forKey: .inProgressAt)
        locationId = try values.decode(String.self, forKey: .locationId)
        do {
            modifiers = try values.decode([ModifiersElement].self, forKey: .modifiers)
        } catch {
            modifiers = []
        }
        name = try values.decode(String.self, forKey: .name)
        nameOnKDS = try values.decode(String.self, forKey: .nameOnKDS)
        orderId = try values.decode(String.self, forKey: .orderId)
        orderName = try values.decode(String.self, forKey: .orderName)
        placedAt = try values.decode(Double.self, forKey: .placedAt)
        plu = try values.decode(String.self, forKey: .plu)
        state = try values.decode(String.self, forKey: .state)
        uid = try values.decode(String.self, forKey: .uid)
        version = try values.decode(Double.self, forKey: .version)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(associate, forKey: .associate)
        try container.encode(catalogId, forKey: .catalogId)
        try container.encode(completedAt, forKey: .completedAt)
        try container.encode(cost, forKey: .cost)
        try container.encode(id, forKey: .id)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(inProgressAt, forKey: .inProgressAt)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(modifiers, forKey: .modifiers)
        try container.encode(name, forKey: .name)
        try container.encode(nameOnKDS, forKey: .nameOnKDS)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(orderName, forKey: .orderName)
        try container.encode(placedAt, forKey: .placedAt)
        try container.encode(plu, forKey: .plu)
        try container.encode(state, forKey: .state)
        try container.encode(uid, forKey: .uid)
        try container.encode(version, forKey: .version)
    }

    func toSwift() -> String {
            """
            RawLineItemObject(
                associate: \(associate),
                catalogId: "\(catalogId)",
                completedAt: \(completedAt),
                cost: \(cost),
                id: "\(id)",
                imageUrl: "\(imageUrl)",
                inProgressAt: \(inProgressAt),
                locationId: "\(locationId)",
                modifiers: \(modifiers),
                name: "\(name)",
                nameOnKDS: "\(nameOnKDS)",
                orderId: "\(orderId)",
                orderName: "\(orderName)",
                placedAt: \(placedAt),
                plu: "\(plu)",
                state: "\(state)",
                uid: "\(uid)",
                version: \(version))
            """
    }
 }
import Foundation

// MARK: - Input
/*
struct ModifiersElement: Codable {
    let catalogObjectId: String
    let cost: Double
    let grouping: String
    let name: String
    let nameOnKDS: String
    let stationInKitchen: String
    let uid: String
}
*/
// MARK: - EndInput

struct ModifiersElement: Codable {
    let catalogObjectId: String
    let cost: Double
    let grouping: String
    let name: String
    let nameOnKDS: String
    let stationInKitchen: String
    let uid: String

    init(
        catalogObjectId: String,
        cost: Double,
        grouping: String,
        name: String,
        nameOnKDS: String,
        stationInKitchen: String,
        uid: String
    ){
        self.catalogObjectId = catalogObjectId
        self.cost = cost
        self.grouping = grouping
        self.name = name
        self.nameOnKDS = nameOnKDS
        self.stationInKitchen = stationInKitchen
        self.uid = uid
    }

    enum CodingKeys: String, CodingKey {
        case catalogObjectId = "catalogObjectId"
        case cost = "cost"
        case grouping = "grouping"
        case name = "name"
        case nameOnKDS = "nameOnKDS"
        case stationInKitchen = "stationInKitchen"
        case uid = "uid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        catalogObjectId = try values.decode(String.self, forKey: .catalogObjectId)
        cost = try values.decode(Double.self, forKey: .cost)
        grouping = try values.decode(String.self, forKey: .grouping)
        name = try values.decode(String.self, forKey: .name)
        nameOnKDS = try values.decode(String.self, forKey: .nameOnKDS)
        stationInKitchen = try values.decode(String.self, forKey: .stationInKitchen)
        uid = try values.decode(String.self, forKey: .uid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(catalogObjectId, forKey: .catalogObjectId)
        try container.encode(cost, forKey: .cost)
        try container.encode(grouping, forKey: .grouping)
        try container.encode(name, forKey: .name)
        try container.encode(nameOnKDS, forKey: .nameOnKDS)
        try container.encode(stationInKitchen, forKey: .stationInKitchen)
        try container.encode(uid, forKey: .uid)
    }

    func toSwift() -> String {
            """
            ModifiersElement(
                catalogObjectId: "\(catalogObjectId)",
                cost: \(cost),
                grouping: "\(grouping)",
                name: "\(name)",
                nameOnKDS: "\(nameOnKDS)",
                stationInKitchen: "\(stationInKitchen)",
                uid: "\(uid)"
                )
            """
    }
 }
import Foundation

// MARK: - Input
/*
struct AssociateObject: Codable {
    let active: Bool
    let id: String
    let locationId: String
    let name: String
    let order: Double
}
*/
// MARK: - EndInput

struct AssociateObject: Codable {
    let active: Bool
    let id: String
    let locationId: String
    let name: String
    let order: Double

    init(
        active: Bool,
        id: String,
        locationId: String,
        name: String,
        order: Double
    ){
        self.active = active
        self.id = id
        self.locationId = locationId
        self.name = name
        self.order = order
    }

    enum CodingKeys: String, CodingKey {
        case active = "active"
        case id = "id"
        case locationId = "locationId"
        case name = "name"
        case order = "order"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decode(Bool.self, forKey: .active)
        id = try values.decode(String.self, forKey: .id)
        locationId = try values.decode(String.self, forKey: .locationId)
        name = try values.decode(String.self, forKey: .name)
        order = try values.decode(Double.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(active, forKey: .active)
        try container.encode(id, forKey: .id)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(name, forKey: .name)
        try container.encode(order, forKey: .order)
    }

    func toSwift() -> String {
            """
            AssociateObject(
                active: \(active),
                id: "\(id)",
                locationId: "\(locationId)",
                name: "\(name)",
                order: \(order))
            """
    }
 }
