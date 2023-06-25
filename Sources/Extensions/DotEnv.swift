//
//  DotEnv.swift
//
//
//  Created by Nicholas Trienens on 11/21/22.
//

import Foundation

enum DotEnv {
    static func parseEnvironment(contents: String) throws -> [String: String] {
        let lines = contents.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        var variables = [String: String]()
        for line in lines {
            if line.isEmpty {
                continue
            }

            if line.starts(with: "#") {
                continue
            }

            let parts = line.split(separator: "=", maxSplits: 1)
            if parts.count != 2 {
                throw DotenvError.invalidValue
            }

            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1].trimmingCharacters(in: .whitespaces)

            if key.rangeOfCharacter(from: .whitespaces) != nil {
                throw DotenvError.invalidValue
            }
            variables[key] = value
        }
        return variables
    }

    public enum DotenvError: Error {
        /// Thrown if the specified file could not be found.
        case notFound
        /// Thrown if the one of the values in the file is not valid.
        case invalidValue
    }
}
