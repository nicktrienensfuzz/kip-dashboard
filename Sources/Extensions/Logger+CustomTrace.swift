import Foundation
import Logging

public extension Logger {
    func customTrace(_ message: Encodable, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let string = try? message.toString() else {
            customTrace(message: "Failed to convert object to JSON", file: file, function: function, line: line)
            return
        }
        customTrace(message: string, file: file, function: function, line: line)
    }

    func customTrace(_ message: Any?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let message else {
            customTrace(message: "nil", file: file, function: function, line: line)
            return
        }
        if let convertible = message as? CustomStringConvertible {
            customTrace(message: convertible.description, file: file, function: function, line: line)
        } else {
            customTrace(message: "\(message)", file: file, function: function, line: line)
        }
    }

    func customTrace(message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        let filename: String
        if let file = file.split(separator: "/").last {
            filename = String(file)
        } else {
            filename = file
        }
        log(level: .notice, .init(stringLiteral: "\(filename):\(line) \(message)"), file: file, function: function, line: line)
    }

    func customCritical(message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        let filename: String
        if let file = file.split(separator: "/").last {
            filename = String(file)
        } else {
            filename = file
        }
        log(level: .critical, .init(stringLiteral: "\(filename):\(line) \(message)"), file: file, function: function, line: line)
    }
}
