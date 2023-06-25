//
//  AsyncLoops.swift
//
//
//  Created by Nicholas Trienens on 1/6/22.
//

import Foundation
// https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/

public extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }

    func asyncCompactMap<T>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            if let value = try await transform(element) {
                values.append(value)
            }
        }
        return values
    }
}

public extension Sequence {
    func concurrentForEach(
        _ operation: @escaping (Element) async throws -> Void
    ) async rethrows {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try await operation(element)
                }
            }
        }
    }

    func serialForEach(
        _ operation: @escaping (Element) async throws -> Void
    ) async rethrows {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:

        for element in self {
            try await operation(element)
        }
    }
}
