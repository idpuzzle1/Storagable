//
//  Preferences.swift
//  Storagable_Example
//
//  Created by Антон Уханкин on 04/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Storagable

struct Preferences: StorageAdapter {
    typealias Key = StoragableItem
    
    let userDefaults: UserDefaults
    
    mutating func set<Value>(value: Value?, for item: Item<Value>) {
        userDefaults.set(value, forKey: item.key.rawValue)
    }
    
    func value<Value>(for item: Item<Value>) -> Value? {
        return userDefaults.value(forKey: item.key.rawValue) as? Value
    }
}

enum StoragableItem: String, CaseIterable {
    case first
    case second
    case third
}
