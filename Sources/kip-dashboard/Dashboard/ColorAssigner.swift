//
//  File.swift
//
//
//  Created by Nicholas Trienens on 7/3/23.
//

import Foundation

class ColorAssigner {
    var colors: [String]
    init() {
        let colorString = """
        'rgba(255, 205, 86, 0.40)'
        'rgba(255, 205, 86, 0.600)'
        'rgba(255, 205, 86, 0.80)'
        'rgba(255, 205, 86, 1)'
        'rgba(75, 192, 192, 1)'
        'rgba(54, 162, 235)'
        'rgba(153, 102, 255)'
        'rgba(201, 203, 207)'
        """
        colors = colorString.split(separator: "\n").map { String($0) }
    }

    func take() -> String {
        // print(colors)
        let color = colors.removeFirst()
        // print(colors)
        return color
    }
}
