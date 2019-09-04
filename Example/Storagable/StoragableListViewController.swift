//
//  StoragableListViewController.swift
//  Storagable_Example
//
//  Created by Антон Уханкин on 04/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class StoragableListViewController: UIViewController {
    
    @IBOutlet weak var storagableTableView: UITableView!
    @IBOutlet weak var newValueTextView: UITextField!
    @IBOutlet weak var updateValuesButton: UIButton!
    
    @IBOutlet weak var bottomWithoutKeyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomWithKeyboardConstraint: NSLayoutConstraint!
    
    var viewModel: StoragableListViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        storagableTableView.dataSource = self
        
        if viewModel.allowSelection {
            storagableTableView.allowsSelection = true
            storagableTableView.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
        }
        
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
        viewModel.inputText(text: self.newValueTextView.text)
    }
}

extension StoragableListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.elementsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorageItemCell", for: indexPath)
        if let itemViewModel = viewModel.itemViewModel(at: indexPath) {
            cell.textLabel?.text = itemViewModel.title
            cell.detailTextLabel?.text = itemViewModel.subtitle
        }
        return cell
    }
}

extension StoragableListViewController: StoragableListViewModelDelegate {
    func viewModelSelectedIndexPaths(_ viewModel: StoragableListViewModel) -> [IndexPath]? {
        if storagableTableView.allowsSelection || storagableTableView.allowsMultipleSelection {
            return storagableTableView.indexPathsForSelectedRows
        }
        return nil
    }
    
    func viewModel(_ viewModel: StoragableListViewModel, didUpdateItemsAt indexPaths: [IndexPath]) {
        let selectedIndexPaths = storagableTableView.indexPathsForSelectedRows
        storagableTableView.reloadRows(at: indexPaths, with: .none)
        selectedIndexPaths?.forEach {
            storagableTableView.selectRow(at: $0, animated: false, scrollPosition: .none)
        }
    }
}
