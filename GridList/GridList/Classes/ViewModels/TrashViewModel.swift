//
//  TrashViewModel.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import Foundation
import Combine



class TrashViewModel {
    
    // MARK: Data
    var deletedGalleryList: [GalleryItem] = DataStore.shared.deletedGalleryList ?? [] {
        didSet {
            deletedGalleryListUpdated.send(true)
        }
    }
    
    var selectedItemIndex: Int? = nil
    
    var deletedGalleryListUpdated = CurrentValueSubject<Bool, Never>(false)
    
    let trashCellId = "trashCell"
    
    // MARK: Methods
    func deleteSelectedItem() {
        guard selectedItemIndex != nil  else { return }
        DataStore.shared.deletedGalleryList?.remove(at: selectedItemIndex!)
        selectedItemIndex = nil
        refreshDeletedList()
    }
    
    func refreshDeletedList() {
        deletedGalleryList = DataStore.shared.deletedGalleryList ?? []
    }
}
