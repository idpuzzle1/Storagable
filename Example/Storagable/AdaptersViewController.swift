//
//  AdaptersViewController.swift
//  Storagable
//
//  Created by idpuzzle1 on 07/29/2019.
//  Copyright (c) 2019 idpuzzle1. All rights reserved.
//

import UIKit
import Storagable

private enum StorageContainer {
    typealias Item = Storagable<String, String>
    
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
    
    func value(for item: Item) -> String? {
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
    
    func set(value: String?, for item: Item) {
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

class AdaptersViewController: UIViewController {
    
    @IBOutlet weak var storageContainersView: UITableView!
    @IBOutlet weak var newValueTextView: UITextField!
    @IBOutlet weak var updateValuesButton: UIButton!
    
    @IBOutlet weak var bottomWithoutKeyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomWithKeyboardConstraint: NSLayoutConstraint!
    
    var storagableItem = Storagable(key: "Item", type: String.self)
    
    private var containers: [StorageContainer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        containers = [
            StorageContainer.memory(MemoryAdapter()),
            StorageContainer.static,
            StorageContainer.preferences(UserDefaultsAdapter())
        ]
        storageContainersView.dataSource = self
        
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
        containers.forEach {
            $0.set(value: self.newValueTextView.text, for: self.storagableItem)
        }
        storageContainersView.reloadData()
    }
}

extension AdaptersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "storage")
        let container = containers[indexPath.item]
        cell.textLabel?.text = container.name
        cell.detailTextLabel?.text = container.value(for: self.storagableItem)
        return cell
    }
}



