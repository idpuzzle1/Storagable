//
//  StorageContainer.swift
//  Storagable
//
//  Created by Антон Уханкин on 29/07/2019.
//

import Foundation

public protocol StorageAdapter {
    associatedtype Key
    typealias Item<Value> = Storagable<Key, Value>
    
    mutating func set<Value>(value: Value?, for item: Item<Value>)
    func value<Value>(for item: Item<Value>) -> Value?
}

public extension StorageAdapter {
    subscript<Value>(item: Item<Value>) -> Value? {
        get { return value(for: item) }
        set { set(value: newValue, for: item) }
    }
}
