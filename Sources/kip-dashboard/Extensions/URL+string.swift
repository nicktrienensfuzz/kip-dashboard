//
//  File.swift
//
//
//  Created by Nicholas Trienens on 7/2/23.
//

import Foundation

public extension String {
    var asUrl: URL? {
        URL(string: self)
    }
}
