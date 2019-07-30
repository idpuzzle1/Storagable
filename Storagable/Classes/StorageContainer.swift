//
//  StorageContainer.swift
//  Storagable
//
//  Created by Антон Уханкин on 29/07/2019.
//

import Foundation

public protocol StorageAdapter {
    associatedtype Key
    
    mutating func set<Value>(value: Value?, for item: Storagable<Key, Value>)
    func value<Value>(for item: Storagable<Key, Value>) -> Value?
}

public extension StorageAdapter {
    subscript<Value>(item: Storagable<Key, Value>) -> Value? {
        get { return value(for: item) }
        set { set(value: newValue, for: item) }
    }
}
