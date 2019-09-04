//
//  AdaptersViewController.swift
//  Storagable
//
//  Created by idpuzzle1 on 07/29/2019.
//  Copyright (c) 2019 idpuzzle1. All rights reserved.
//

import UIKit
import Storagable

class DifferentStoragesViewModel {
    init(storages: [StorageContainer], item: Storagable<String, String>) {
        self.storages = storages
        self.item = item
    }
    
    private let storages: [StorageContainer]
    private let item: StorageContainer.Item<String>
    
    weak var delegate: StoragableListViewModelDelegate?
}

extension DifferentStoragesViewModel: StoragableListViewModel {
    
    var allowSelection: Bool {
        return false
    }
    
    var elementsCount: Int {
        return storages.count
    }
    
    func itemViewModel(at indexPath: IndexPath) -> StoragableElementViewModel? {
        let container = storages[indexPath.item]
        return StorageContainerElementViewModel(container: container, item: self.item)
    }
    
    func inputText(text: String?) {
        storages.forEach {
            $0.set(value: text, for: self.item)
        }
        let updatingIndexPaths = storages.indices.compactMap { IndexPath(item: $0, section: 0) }
        delegate?.viewModel(self, didUpdateItemsAt: updatingIndexPaths)
    }
}

private struct StorageContainerElementViewModel<Value>: StoragableElementViewModel {
    let container: StorageContainer
    let item: StorageContainer.Item<Value>
    
    var title: String? {
        return container.name
    }
    
    var subtitle: String? {
        return container.value(for: item) as? String
    }
}
