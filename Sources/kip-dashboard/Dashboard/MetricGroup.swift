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
    init(displayName: String = "", data: JSON) {
        self.displayName = displayName
        self.data = data
    }
    
    /// A human readable name for the single metric.
    var displayName: String
    
    /// The actual data of single metric as JSON.
    var data: JSON
    
    /// Debug description of the `SingleMetric` for better readability during development and debugging.
    var debugDescription: String {
        return "SingleMetric: \(displayName)\nData: \(data)"
    }
}

