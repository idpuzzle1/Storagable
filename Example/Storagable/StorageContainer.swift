//
//  StorageAdaptersContainer.swift
//  Storagable_Example
//
//  Created by Антон Уханкин on 04/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Storagable

enum StorageContainer: StorageAdapter {
    typealias Key = String
    
    static let staticAdapter = MemoryAdapter()
    
    case memory(_ adapter: MemoryAdapter)
    case `static`
    case preferences(_ adapter: UserDefaultsAdapter)
    
    var name: String {
        switch self {
        case .memory: return "Memory"
        case .static: return "Static"
        case .preferences: return "User Defaults"
        }
    }
    
    func value<Value>(for item: Item<Value>) -> Value? {
        switch self {
        case .memory(let adapter):
            let item = Storagable(key: AnyHashable(item.key), type: item.type)
            return adapter.value(for: item)
        case .static:
            let item = Storagable(key: AnyHashable(item.key), type: item.type)
            return type(of: self).staticAdapter.value(for: item)
        case .preferences(let adapter): return adapter.value(for: item)
        }
    }
    
    func set<Value>(value: Value?, for item: Item<Value>) {
        switch self {
        case .memory(let adapter):
            let item = Storagable(key: AnyHashable(item.key), type: item.type)
            adapter.set(value: value, for: item)
        case .static:
            let item = Storagable(key: AnyHashable(item.key), type: item.type)
            type(of: self).staticAdapter.set(value: value, for: item)
        case .preferences(let adapter):
            adapter.set(value: value, for: item)
        }
    }
}
