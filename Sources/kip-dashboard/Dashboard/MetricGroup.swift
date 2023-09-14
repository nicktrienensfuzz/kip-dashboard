//
//  MetricGroup.swift
//  
//
//  Created by Nicholas Trienens on 9/13/23.
//

import Foundation
import JSON

class MetricGroup: Codable, CustomDebugStringConvertible {
    init(name: String, displayName: String = "", labels: [JSON] = [], data: [JSON] = []) {
        self.name = name
        self.displayName = displayName
        self.labels = labels
        self.data = data
    }
    
    var name: String
    var displayName: String
    var labels: [JSON]
    var data: [JSON]
    
    var debugDescription: String {
        "MetricGroup: \(name)\nLabels: \(labels)\nData: \(data)"
    }
}


class SingleMetric: Codable, CustomDebugStringConvertible {
    init( displayName: String = "", data: JSON) {
        self.displayName = displayName
        self.data = data
    }
    
    var displayName: String
    var data: JSON
    
    var debugDescription: String {
        "SingleMetric: \(displayName)\nData: \(data)"
    }
}
