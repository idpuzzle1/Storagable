//
//  StoragableListViewModel.swift
//  Storagable_Example
//
//  Created by Антон Уханкин on 04/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

protocol StoragableListViewModelDelegate: class {
    func viewModelSelectedIndexPaths(_ viewModel: StoragableListViewModel) -> [IndexPath]?
    func viewModel(_ viewModel: StoragableListViewModel, didUpdateItemsAt indexPaths: [IndexPath])
}

protocol StoragableListViewModel {
    var delegate: StoragableListViewModelDelegate? { get set }
    
    var allowSelection: Bool { get }
    
    var elementsCount: Int { get }
    
    func itemViewModel(at indexPath: IndexPath) -> StoragableElementViewModel?
    
    func inputText(text: String?)
}

protocol StoragableElementViewModel {
    var title: String? { get }
    var subtitle: String? { get }
}
