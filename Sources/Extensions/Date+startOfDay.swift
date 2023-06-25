//
//  Date+startOfDay.swift
//
//
//  Created by Nicholas Trienens on 1/12/22.
//

import Foundation

public extension Date {
    var startOfDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar.startOfDay(for: advanced(by: -(3600 * 7)))
    }
    
    var rawStartOfDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar.startOfDay(for: self)
    }
    
    
    var endOfDay: Date {
        (rawStartOfDay + 23.hours ) + 59.minutes
    }
    var adjustedStartOfDay: TimeInterval {
        startOfDay.timeIntervalSinceReferenceDate + (3600 * 7)
    }

    var adjustedStartOfDayUTS: TimeInterval {
        startOfDay.timeIntervalSince1970
    }

    func toTimezone(zone: TimeZone? = TimeZone(abbreviation: "UTC")) -> Date {
        guard let zone = zone else { return self }

        let difference = zone.secondsFromGMT() - TimeZone.current.secondsFromGMT()
        return advanced(by: Double(difference))
    }
    
    var secondsFromStartOfDay: Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        let interval = self.timeIntervalSince(startOfDay)
        return Int(interval)
    }
}



public extension String {
    fileprivate static let dateFormatter = DateFormatter()

    var asDate: Date? {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+'0000"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        Self.dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        Self.dateFormatter.dateFormat = "MMM-dd-yyyy"
        if let date = Self.dateFormatter.date(from: self) {
            return date
        }
        print(self, "Failed to parse")
        return nil
    }
}

public extension Date {
    func formatted(_ format: String) -> String {
        String.dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        String.dateFormatter.dateFormat = format
        return String.dateFormatter.string(from: self)
    }
    
    func formattedGMT(_ format: String) -> String {
        String.dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        String.dateFormatter.dateFormat = format
        return String.dateFormatter.string(from: self)
    }
}

enum DayOfWeek: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

extension Date {
    func moveToDayOfWeek(_ dayOfWeek: DayOfWeek, direction: Calendar.SearchDirection = .forward) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = dayOfWeek.rawValue

        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime, direction: direction)
    }
}
