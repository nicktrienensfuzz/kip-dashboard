//
//  ObjectCompostion.swift
//  BlueJayKDS
//
//  Created by Nicholas Trienens on 3/21/21.
//  Copyright © 2021 Fuzzproductions. All rights reserved.
//

import Foundation

@dynamicMemberLookup
class CombinedReference<Value, Value2> {
    var value: Value
    var value2: Value2

    init(value: Value, value2: Value2) {
        self.value = value
        self.value2 = value2
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Value2, T>) -> T {
        value2[keyPath: keyPath]
    }
}
