//
//  UserDefaultsViewController.swift
//  Storagable
//
//  Created by idpuzzle1 on 07/29/2019.
//  Copyright (c) 2019 idpuzzle1. All rights reserved.
//

import UIKit
import Storagable

private struct Preferences: StorageAdapter {
    typealias Key = StoragableItem
    
    let userDefaults: UserDefaults
    
    mutating func set<Value>(value: Value?, for item: Storagable<StoragableItem, Value>) {
        userDefaults.set(value, forKey: item.key.rawValue)
    }
    
    func value<Value>(for item: Storagable<StoragableItem, Value>) -> Value? {
        userDefaults.value(forKey: item.key.rawValue) as? Value
    }
}

private enum StoragableItem: String, CaseIterable {
    case first
    case second
    case third
}

class UserDefaultsViewController: UIViewController {
    
    @IBOutlet weak var storageContainersView: UITableView!
    @IBOutlet weak var newValueTextView: UITextField!
    @IBOutlet weak var updateValuesButton: UIButton!
    
    @IBOutlet weak var bottomWithoutKeyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomWithKeyboardConstraint: NSLayoutConstraint!
    
    private var preferences = Preferences(userDefaults: .standard)
    private var items: [Storagable<StoragableItem, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        items = [
            Storagable(key: StoragableItem.first, type: Any.self),
            Storagable(key: StoragableItem.second, type: Any.self),
            Storagable(key: StoragableItem.third, type: Any.self)
        ]
        storageContainersView.dataSource = self
        storageContainersView.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main) { [weak self] notification in
            guard let self = self else { return }
            guard let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            self.bottomWithKeyboardConstraint.constant = endFrame.height
            guard
                let animationDurationValue = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else { return }
            
            UIView.animate(withDuration: animationDurationValue.doubleValue) {
                self.view.layoutIfNeeded()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateStorage(_ sender: Any) {
        guard let selectedIndex = storageContainersView.indexPathForSelectedRow?.item else { return }
        let storagable = items[selectedIndex]
        let newValue = self.newValueTextView.text
        preferences.set(value: newValue, for: storagable)
        storageContainersView.reloadData()
    }
}

extension UserDefaultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "storage")
        let storagable = items[indexPath.item]
        let value = preferences.value(for: storagable)
        cell.textLabel?.text = storagable.key.rawValue
        cell.detailTextLabel?.text = value as? String
        return cell
    }
}



