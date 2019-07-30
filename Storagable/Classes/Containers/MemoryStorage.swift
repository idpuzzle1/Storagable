//
//  MemoryStorage.swift
//  FBSnapshotTestCase
//
//  Created by Антон Уханкин on 29/07/2019.
//

import Foundation

public class MemoryAdapter: StorageAdapter {
    public typealias Key = AnyHashable
    public typealias Memory = [Swift.AnyHashable: Any]
    
    private var memory: Memory
    
    public init(items: Memory = [:]) {
        self.memory = items
    }
        
    public func set<Value>(value: Value?, for item: Storagable<Key, Value>) {
        memory[item.key] = value
    }
    
    public func value<Value>(for item: Storagable<Key, Value>) -> Value? {
        return memory[item.key] as? Value
    }
}
