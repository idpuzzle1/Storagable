//
//  PreferenceStorage.swift
//  FBSnapshotTestCase
//
//  Created by Антон Уханкин on 29/07/2019.
//

import Foundation

public struct UserDefaultsAdapter: StorageAdapter {
    public typealias Key = String
    
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    public func set<Value>(value: Value?, for item: Storagable<Key, Value>) {
        defaults.set(value, forKey: item.key)
    }
    
    public func value<Value>(for item: Storagable<Key, Value>) -> Value? {
        return defaults.value(forKey: item.key) as? Value
    }
}
