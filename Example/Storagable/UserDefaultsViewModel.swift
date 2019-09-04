//
//  UserDefaultsViewController.swift
//  Storagable
//
//  Created by idpuzzle1 on 07/29/2019.
//  Copyright (c) 2019 idpuzzle1. All rights reserved.
//

import UIKit
import Storagable

class UserDefaultsViewModel {
    typealias Item = Storagable<StoragableItem, String>
    
    private var preferences = Preferences(userDefaults: .standard)
    private var items: [Item] = [
        Storagable(key: StoragableItem.first, type: String.self),
        Storagable(key: StoragableItem.second, type: String.self),
        Storagable(key: StoragableItem.third, type: String.self)
    ]
    
    var delegate: StoragableListViewModelDelegate?
}

extension UserDefaultsViewModel: StoragableListViewModel {
    var allowSelection: Bool {
        return true
    }
    
    var elementsCount: Int {
        return items.count
    }
    
    func itemViewModel(at indexPath: IndexPath) -> StoragableElementViewModel? {
        let item = items[indexPath.item]
        return UserDefaultsElementViewModel(preference: preferences, item: item)
    }
    
    func inputText(text: String?) {
        let selectedIndexes = delegate?.viewModelSelectedIndexPaths(self) ?? []
        
        let foundedIndexes = selectedIndexes.compactMap { $0.item }
        let updatingItems = items.indices.filter{ foundedIndexes.contains($0) }.compactMap { items[$0] }
        updatingItems.forEach {
            preferences.set(value: text, for: $0)
        }
        delegate?.viewModel(self, didUpdateItemsAt: selectedIndexes)
    }
}

struct UserDefaultsElementViewModel<Value>: StoragableElementViewModel {
    let preference: Preferences
    let item: Storagable<StoragableItem, Value>
    
    var title: String? {
        return item.key.rawValue
    }
    
    var subtitle: String? {
        return preference.value(for: item) as? String
    }
    
    
}



