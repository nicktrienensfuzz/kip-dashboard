//
//  MetricGroup.swift
//  
//
//  Created by Nicholas Trienens on 9/13/23.
//

import Foundation
import JSON

/// `MetricGroup` class encapsulates a group of metrics.
/// It conforms to both `Codable` and `CustomDebugStringConvertible` protocols.
class MetricGroup: Codable, CustomDebugStringConvertible {
    
    /// Initialize `MetricGroup` with necessary parameters.
    /// - Parameters:
    ///   - name: The name of the metric group.
    ///   - displayName: A human readable name for the metric group.
    ///   - labels: An array of labels relevant to the metric group.
    ///   - data: The actual data of metrics group as JSON.
    init(name: String, displayName: String = "", labels: [JSON] = [], data: [JSON] = []) {
        self.name = name
        self.displayName = displayName
        self.labels = labels
        self.data = data
    }
    
    /// The name of the metric group.
    var name: String
    
    /// A human readable name for the metric group.
    var displayName: String
    
    /// An array of labels relevant to the metric group.
    var labels: [JSON]
    
    /// The actual data of metrics group as JSON.
    var data: [JSON]
    
    /// Debug description of the `MetricGroup` for better readability during development and debugging.
    var debugDescription: String {
        return "MetricGroup: \(name)\nLabels: \(labels)\nData: \(data)"
    }
}

/// `SingleMetric` class encapsulates a single metric.
/// It conforms to both `Codable` and `CustomDebugStringConvertible` protocols.
class SingleMetric: Codable, CustomDebugStringConvertible {
    
    /// Initialize `SingleMetric` with necessary parameters.
    /// - Parameters:
    ///   - displayName: A human readable name for the single metric.
    ///   - data: The actual data of single metric as JSON.
    init(displayName: String = "", data: JSON, unit: String? = nil) {
        self.displayName = displayName
        self.data = data
        self.unit = unit
    }
    
    /// A human readable name for the single metric.
    var displayName: String
    
    /// A human readable unit.
    var unit: String?
    
    /// The actual data of single metric as JSON.
    var data: JSON
    
    /// Debug description of the `SingleMetric` for better readability during development and debugging.
    var debugDescription: String {
        return "SingleMetric: \(displayName)\nData: \(data)\(unit ?? "")"
    }
}



/// `SingleMetric` class encapsulates a single metric.
/// It conforms to both `Codable` and `CustomDebugStringConvertible` protocols.
class TrackedChangeMetric: Codable, CustomDebugStringConvertible {
    
    /// Initialize `SingleMetric` with necessary parameters.
    /// - Parameters:
    ///   - displayName: A human readable name for the single metric.
    ///   - data: The actual data of single metric as JSON.
    init(displayName: String,
         dataBefore: JSON,
         dataAfter: JSON,
         unit: String? = nil,
         dateRangeBefore: ClosedRange<Date>,
        dateRangeAfter: ClosedRange<Date>) {
        
        self.displayName = displayName
        if unit == "Dollars" {
            self.dataBefore = dataBefore.asDollars
            self.dataAfter = dataAfter.asDollars
        } else {
            self.dataBefore = dataBefore
            self.dataAfter = dataAfter
        }
        self.unit = unit
        self.dateRangeBefore = dateRangeBefore
        daysIntervalBefore = dateRangeBefore.numberOfDaysInRange()
        self.dateRangeAfter = dateRangeAfter
        daysIntervalAfter = dateRangeAfter.numberOfDaysInRange()
        
        do {
            percentChange = "\(try (100 * (dataAfter.numberAsFloat.unwrapped() - dataBefore.numberAsFloat.unwrapped()) / dataBefore.numberAsFloat.unwrapped()).rounded(places: 2))%"
        } catch {
            percentChange = nil
        }
    }
    
    /// A human readable name for the single metric.
    var displayName: String
    
    /// A human readable unit.
    var unit: String?
    
    /// The actual data of single metric as JSON.
    var dataBefore: JSON
    
    /// The actual data of single metric as JSON.
    var dataAfter: JSON
    
    var percentChange: String?
    
    let dateRangeBefore: ClosedRange<Date>
    let daysIntervalBefore: Double
    var dateRangeAfter: ClosedRange<Date>
    let daysIntervalAfter: Double
    /// Debug description of the `SingleMetric` for better readability during development and debugging.
    var debugDescription: String {
        return "SingleMetric: \(displayName)\nData: [\(dataBefore), \(dataAfter)] \(unit ?? "")"
    }
}




extension Double {
    func rounded(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    func rounded(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
