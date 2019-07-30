//
//  Storagable.swift
//  Storagable
//
//  Created by Антон Уханкин on 29/07/2019.
//

public struct Storagable<Key, Value> {
    public let key: Key
    public let type: Value.Type
    
    public init(key: Key, type: Value.Type) {
        self.key = key
        self.type = type
    }
}

public extension Storagable where Key: Equatable, Value: Equatable {
    static func == (lhs: Storagable, rhs: Storagable) -> Bool {
        return lhs.key == rhs.key && lhs.type == rhs.type
    }
}


