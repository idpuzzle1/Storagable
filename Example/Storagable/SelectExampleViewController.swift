//
//  SelectExampleViewController.swift
//  Storagable_Example
//
//  Created by Антон Уханкин on 04/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Storagable

class SelectExampleViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let storagableVC = segue.destination as? StoragableListViewController {
            switch segue.identifier {
            case "ShowAdapters":
                let storages =  [
                            StorageContainer.memory(MemoryAdapter()),
                            StorageContainer.static,
                            StorageContainer.preferences(UserDefaultsAdapter())
                        ]
                let storagableItem = Storagable(key: "Item", type: String.self)
                storagableVC.viewModel = DifferentStoragesViewModel(storages: storages, item: storagableItem)
            case "ShowUserDefaults":
                storagableVC.viewModel = UserDefaultsViewModel()
            default:
                break
            }
        }
        super.prepare(for: segue, sender: sender)
    }
}

