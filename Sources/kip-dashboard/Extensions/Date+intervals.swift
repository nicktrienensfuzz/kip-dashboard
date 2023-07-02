//
//  Date+Intervals.swift
//
//
//  Created by Nicholas Trienens on 10/30/22.
//

import Foundation

public enum DateUnit {
    case year
    case month
    case week
    case day
    case hour
    case minute
    case second

    var seconds: Double {
        switch self {
        case .second: return 1.0
        case .minute: return 60.0
        case .hour: return 3600.0
        case .day: return 3600.0 * 24.0
        case .week: return 3600.0 * 24.0 * 7
        case .month: return 3600.0 * 24.0 * 7 * 30
        case .year: return 3600.0 * 24.0 * 365
        }
    }
}

/// `Interval` represents an interval between components of time, such as` Day`, `Month`, and` Year`.
public struct Interval: Hashable {
    public var unit: DateUnit
    public var rawValue: Double

    public init(_ value: Double, unit: DateUnit) {
        rawValue = value
        self.unit = unit
    }

    public var seconds: Double {
        unit.seconds * rawValue
    }
}

public extension Int {
    /// The interval for `Day`
    var seconds: Interval {
        Interval(Double(self), unit: .second)
    }

    /// The interval for `Day`
    var minutes: Interval {
        Interval(Double(self), unit: .minute)
    }

    /// The interval for `Day`
    var hours: Interval {
        Interval(Double(self), unit: .hour)
    }

    /// The interval for `Day`
    var days: Interval {
        Interval(Double(self), unit: .day)
    }

    /// The interval for `Month`
    var weeks: Interval {
        Interval(Double(self), unit: .week)
    }

    /// The interval for `Month`
    var months: Interval {
        Interval(Double(self), unit: .month)
    }

    /// The interval for `Year`
    var years: Interval {
        Interval(Double(self), unit: .year)
    }
}

public func + (_ lhs: Interval, _ rhs: Interval) -> Interval {
    Interval(lhs.seconds + rhs.seconds, unit: .second)
}

public func * (_ lhs: Interval, _ rhs: Interval) -> Interval {
    Interval(lhs.seconds * rhs.seconds, unit: .second)
}

public func + (_ date: Date, _ interval: Interval) -> Date {
    date.advanced(by: interval.seconds)
}

// public func += (_ date: Date, _ interval: Interval) -> Date {
//    date.advanced(by: interval.seconds)
// }

public func - (_ date: Date, _ interval: Interval) -> Date {
    date.advanced(by: -interval.seconds)
}

//
// public func -= (_ date: Date, _ interval: Interval) -> Date  {
//    date.advanced(by: -interval.seconds)
// }

public extension String {
    func toDate() -> Date? {
        let oldFormatter = DateFormatter()
        oldFormatter.calendar = Calendar(identifier: .iso8601)
        oldFormatter.locale = Locale(identifier: "en_US_POSIX")
        oldFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        oldFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = oldFormatter.date(from: self) {
            return date
        }

        oldFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
        if let date = oldFormatter.date(from: self) {
            return date
        }
        oldFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = oldFormatter.date(from: self) {
            return date
        }

        oldFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if let date = oldFormatter.date(from: self) {
            return date
        }
        return nil
    }
}
