import Foundation  

// MARK: - Input
/*
class LunchPeriodMetrics {
    var location: Location
    var startDate: Date
    var endDate: Date
    var associatesWorking: Int = 0
    var averagePlacedToClaimed: Double = 0
    var averagePlacedToCompletion: Double = 0
    var averageClaimedToCompletion: Double = 0
    var totalItems: Int = 0
    var totalOrders: Int = 0
    var duplicateItems: Int = 0
    var duplicateItemsClaimedTogether: Int = 0
    var itemsCompletedInParallel: Int = 0
    var maxItemsInProgress: Int = 0
    var totalTimeInWaiting: Double = 0
    var totalTimeToMake: Double = 0
    var realTimeToMake: Double = 0
    var linkToGantt: String? = nil
}
*/
// MARK: - EndInput

class LunchPeriodMetrics {
    var location: Location
    var startDate: Date
    var endDate: Date
    var associatesWorking: Int
    var averagePlacedToClaimed: Double
    var averagePlacedToCompletion: Double
    var averageClaimedToCompletion: Double
    var totalItems: Int
    var totalOrders: Int
    var duplicateItems: Int
    var duplicateItemsClaimedTogether: Int
    var itemsCompletedInParallel: Int
    var maxItemsInProgress: Int
    var totalTimeInWaiting: Double
    var totalTimeToMake: Double
    var realTimeToMake: Double
    var linkToGantt: String?

    init(
        location: Location,
        startDate: Date,
        endDate: Date,
        associatesWorking: Int = 0,
        averagePlacedToClaimed: Double = 0,
        averagePlacedToCompletion: Double = 0,
        averageClaimedToCompletion: Double = 0,
        totalItems: Int = 0,
        totalOrders: Int = 0,
        duplicateItems: Int = 0,
        duplicateItemsClaimedTogether: Int = 0,
        itemsCompletedInParallel: Int = 0,
        maxItemsInProgress: Int = 0,
        totalTimeInWaiting: Double = 0,
        totalTimeToMake: Double = 0,
        realTimeToMake: Double = 0,
        linkToGantt: String? = nil
    ){ 
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.associatesWorking = associatesWorking
        self.averagePlacedToClaimed = averagePlacedToClaimed
        self.averagePlacedToCompletion = averagePlacedToCompletion
        self.averageClaimedToCompletion = averageClaimedToCompletion
        self.totalItems = totalItems
        self.totalOrders = totalOrders
        self.duplicateItems = duplicateItems
        self.duplicateItemsClaimedTogether = duplicateItemsClaimedTogether
        self.itemsCompletedInParallel = itemsCompletedInParallel
        self.maxItemsInProgress = maxItemsInProgress
        self.totalTimeInWaiting = totalTimeInWaiting
        self.totalTimeToMake = totalTimeToMake
        self.realTimeToMake = realTimeToMake
        self.linkToGantt = linkToGantt
    }

    func toSwift() -> String {
            """
            LunchPeriodMetrics(
                location: \(location),
                startDate:  Date(timeIntervalSince1970: \(startDate.timeIntervalSince1970)),
                endDate:  Date(timeIntervalSince1970: \(endDate.timeIntervalSince1970)),
                associatesWorking: \(associatesWorking),
                averagePlacedToClaimed: \(averagePlacedToClaimed),
                averagePlacedToCompletion: \(averagePlacedToCompletion),
                averageClaimedToCompletion: \(averageClaimedToCompletion),
                totalItems: \(totalItems),
                totalOrders: \(totalOrders),
                duplicateItems: \(duplicateItems),
                duplicateItemsClaimedTogether: \(duplicateItemsClaimedTogether),
                itemsCompletedInParallel: \(itemsCompletedInParallel),
                maxItemsInProgress: \(maxItemsInProgress),
                totalTimeInWaiting: \(totalTimeInWaiting),
                totalTimeToMake: \(totalTimeToMake),
                realTimeToMake: \(realTimeToMake),
                linkToGantt: \(linkToGantt != nil ? "\"\(linkToGantt!)\"" : "nil")
                )
            """
    }
 }