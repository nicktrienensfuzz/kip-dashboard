//
//  Date+IntervalFormatting.swift
//
//
//  Created by Nicholas Trienens on 5/31/22.
//

import Foundation

public extension Date {
    static func formatted(duration interval: Float) -> String {
        formatted(duration: Double(interval))
    }
    
    static func formatted(duration interval: TimeInterval) -> String {
        var duration = ""
        var timeInterval = abs(interval)
        var t = 0
        while t < 3 {
            if !duration.isEmpty {
                duration += " "
            }
            if timeInterval > 86400 {
                duration += String(format: "%.0fd", timeInterval / 86400)
                timeInterval = Double(Int(timeInterval) % 86400)
            } else if timeInterval >= 3600 {
//                if t == 1 {
//                    duration += String(format: "%.2fh", timeInterval / 3600)
//                } else {
                    duration += String(format: "%.0fh", timeInterval / 3600)
                //}
                timeInterval = Double(Int(timeInterval) % 3600)
            } else {
                let roundMinutes = Int(floor(timeInterval / 60))
                let seconds = Int(ceil(timeInterval - (Double(roundMinutes) * 60.0)))
                duration += "\(roundMinutes)m \(seconds)s"
                t += 3
            }
            t += 1
        }
        return duration
    }
}
