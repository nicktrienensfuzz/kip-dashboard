//
//  Optional+unwrapped.swift
//
//
//  Created by Nicholas Trienens on 8/11/21.
//

import Foundation

public extension Optional {
    func unwrapped(_ message: String? = nil, path: String = #file, function: String = #function, line: Int = #line) throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none:
            if let message = message {
                throw ServiceError(
                    "Failed to unwrap value: \(message) `\(type(of: self))`",
                    statusCode: .expectationFailed,
                    path: path,
                    function: function,
                    line: line
                )
            }
            throw ServiceError(
                "Failed to unwrap value: `\(type(of: self))`",
                statusCode: .expectationFailed,
                path: path,
                function: function,
                line: line
            )
        }
    }
}

// MARK: - Substring Extension
public extension Substring {
    var asString: String {
        String(self)
    }
}
