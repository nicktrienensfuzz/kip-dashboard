//
//  JSONBuilder.swift
//
//
//  Created by Nicholas Trienens on 5/10/23.
//

import Foundation
import JSON

// Public function to create a JSON object.
// Usage: json { ...definition of JSON object... }
public func json(@JSONBuilder conditions makeResult: () -> JSON) -> JSON {
    makeResult()
}

// Extension to JSON struct to initialize it with a JSONBuilder.
extension JSON {
    init(@JSONBuilder statements: () -> JSON) {
        self = statements()
    }

    init(_ array: [JSON]) {
        self = .array(array)
    }

    // Helper method to create a JSON array using a JSONBuilder
    static func array(@JSONBuilder statements: () -> JSON) -> JSON {
        JSON(arrayLiteral: statements())
    }
}

// JSONBuilder is a Swift result builder utilizing the new @resultBuilder directive in Swift.
// It allows the creation of JSON structures using Swift syntax.
// It supports JSON objects, JSON arrays, strings, numbers (Int, Float, Double), booleans and `null` JSON values.
@resultBuilder
enum JSONBuilder {
    static func buildBlock(_ components: JSON...) -> JSON {
        if components.count == 1 {
            return components[0]
        }
        return .array(components)
    }

    static func buildExpression(_ expression: [String: JSON]) -> JSON {
        .object(expression)
    }

    static func buildExpression(_ expression: [String: JSONRepresentable]) -> JSON {
        .object(expression.mapValues { value in
            value.json
        })
    }

    static func buildFinalResult(_ component: JSON) -> JSON {
        component
    }

    static func buildOptional(_ component: JSON?) -> JSON {
        component ?? .null
    }

    static func buildEither(first: JSON) -> JSON {
        first
    }

    static func buildEither(second: JSON) -> JSON {
        second
    }

    static func buildArray(_ components: [JSON]) -> JSON {
        .array(components)
    }

    static func buildExpression(_ expression: String) -> JSON {
        .string(expression)
    }

    static func buildExpression(_ expression: Int) -> JSON {
        .number(.int(expression))
    }

    static func buildExpression(_ expression: Double) -> JSON {
        .number(.double(expression))
    }

    static func buildExpression(_ expression: Float) -> JSON {
        .number(.float(expression))
    }

    static func buildExpression(_ expression: Bool) -> JSON {
        .bool(expression)
    }

    static func buildExpression(_ expression: Decimal) -> JSON {
        .number(.decimal(expression))
    }

    static func buildExpression(_ expression: [String: String]) -> JSON {
        .object(expression.mapValues { value in
            JSON.string(value)
        })
    }

    static func buildExpression(_ expression: [String: Int]) -> JSON {
        .object(expression.mapValues { value in
            JSON.number(.int(value))
        })
    }

    static func buildExpression(_ expression: [String: Double]) -> JSON {
        .object(expression.mapValues { value in
            JSON.number(.double(value))
        })
    }

    static func buildExpression(_ expression: [String: Float]) -> JSON {
        .object(expression.mapValues { value in
            JSON.number(.float(value))
        })
    }

    static func buildExpression(_ expression: [String: Decimal]) -> JSON {
        .object(expression.mapValues { value in
            JSON.number(.decimal(value))
        })
    }

    static func buildExpression(_ expression: [String: Bool]) -> JSON {
        .object(expression.mapValues { value in
            JSON.bool(value)
        })
    }
}
