//
//  File.swift
//
//
//  Created by Nicholas Trienens on 1/16/23.
//

import Foundation
import JSON

struct Location: Codable {
    static func color(_ index: Int) -> String {
        let colors = """
        'rgb(255, 99, 132)'
        'rgb(255, 159, 64)'
        'rgb(255, 205, 86)'
        'rgb(75, 192, 192)'
        'rgb(54, 162, 235)'
        'rgb(153, 102, 255)'
        'rgb(201, 203, 207)'
        """

        let lines = colors.split(separator: "\n")
        return lines[index].asString
    }

    internal init(id: String, name: String, openedAt: Date? = nil, region: String, index: Int = 0) {
        self.id = id
        self.name = name
        self.openedAt = openedAt
        self.region = region
        colorString = Self.color(index)
    }

    let id: String
    let name: String
    let region: String
    let openedAt: Date?
    let colorString: String
    var data: JSON?
}
