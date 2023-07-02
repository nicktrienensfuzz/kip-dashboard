//
//  File.swift
//
//
//  Created by Nicholas Trienens on 8/30/21.
//

import Foundation

public extension ArraySlice {
    /// Create an array from an array slice.
    var asArray: [Element] { Array(self) }
}

public extension Array where Element: Equatable {
    func countContains(_ searchArray: [Element]) -> Int {
        reduce(into: 0) { current, ownElement in
            current += (searchArray.contains(ownElement) ? 1 : 0)
        }
    }
}

public extension Array {
    /// Create a new array replacing any items in the array Equatable to the passed in item.
    /// - Parameter item: Equatable item
    /// - Returns: New array
    func replacing(item: Iterator.Element, comparer: (Iterator.Element, Iterator.Element) -> Bool) -> [Iterator.Element] {
        let newArr: [Iterator.Element] = map { oldItem in
            if comparer(oldItem, item) {
                return item
            }
            return oldItem
        }
        return newArr
    }

    /// Mutating replace any items in the array with item when the comparer returns true.
    /// - Parameter item: Array Element
    /// - Parameter comparer: Block to decide weather to replace an item
    /// - Returns: Void
    mutating func replace(item: Iterator.Element, comparer: (Iterator.Element, Iterator.Element) -> Bool) {
        let newArr: [Iterator.Element] = map { oldItem in
            if comparer(oldItem, item) {
                return item
            }
            return oldItem
        }
        self = newArr
    }
}

public extension Array where Iterator.Element: Equatable {
    /// Subtract one array's elements from another array's
    /// - Parameters:
    ///   - lhs: array of Equatable items
    ///   - rhs: array of Equatable items
    static func - (lhs: Array, rhs: Array) -> Array {
        lhs.filter { !rhs.contains($0) }
    }

    /// Create an array from existing array plus new item if it is unique.
    /// - Parameter item: Equatable item to be added if it is unique.
    /// - Returns: An array with new item if it is unique.
    func elements(equaling item: Iterator.Element) -> [Iterator.Element] {
        var newArray = self
        for obj in self where obj == item {
            newArray.append(obj)
        }
        return newArray
    }

    /// Return an element, if one passed in exists in the array.
    /// - Parameter item: Equatable item
    /// - Returns: An element if one existed
    func element(equaling item: Iterator.Element) -> Iterator.Element? {
        for obj in self where obj == item {
            return obj
        }
        return nil
    }

    /// Create new array wtih a specified item in array to be removed.
    /// - Parameter item: Equatable item
    /// - Returns: New array without specified item if it existed in original array.
    func removing(item: Iterator.Element) -> [Iterator.Element] {
        var newArray = self
        if let ind = newArray.firstIndex(of: item) {
            newArray.remove(at: ind)
        }
        return newArray
    }

    /// Remove existing item from array.
    /// - Parameter item: Item to be removed from array.
    mutating func remove(item: Iterator.Element) {
        if let ind = firstIndex(of: item) {
            remove(at: ind)
        }
    }

    /// Create a new array replacing any items in the array Equatable to the passed in item.
    /// - Parameter item: Equatable item
    /// - Returns: New array
    func replacing(item: Iterator.Element) -> [Iterator.Element] {
        let newArr: [Iterator.Element] = map { oldItem in
            if oldItem == item {
                return item
            }
            return oldItem
        }
        return newArr
    }
}

public extension Array where Element: Hashable {
//    /// Create a new `Array` without duplicate elements.
//    /// - Note: The initial order of the elements is not maintained in the returned value.
//    ///
//    /// - Returns: A new `Array` without duplicate elements.
//    ///
//    func deduplicated() -> Array {
//        Array(Set<Element>(self))
//    }
//
//    /// Strip duplicate elements from the array.
//    /// - Note:  The initial order of the elements is not maintained after the strip.
//    mutating func deduplicate() {
//        self = deduplicated()
//    }
//
    /// Create a new `Array` without duplicate elements.
    /// - Note: The initial order of the elements is not maintained in the returned value.
    ///
    /// - Returns: A new `Array` without duplicate elements.
    ///
    func deduplicatedWithOrder() -> Array {
        var items = Array<Element>()
        self.forEach { item in
            if !items.contains(item) {
                items.append(item)
            }
        }
        return items
    }

}
