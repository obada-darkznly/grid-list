//
//  ImageListViewModel.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import Foundation
import Combine


class ImageListViewModel {
    
    // MARK: Properties
    
    /// The array that contains gallery items
    var galleryItems: [GalleryItem] = DataStore.shared.galleryItems ?? [] {
        didSet {
            galleryItemsUpdated.send(true)
        }
    }
    
    /// Notifies the view controller that the data has changed, in order to refresh the collection view
    var galleryItemsUpdated = CurrentValueSubject<Bool, Never>(false)
    
    // NIBs ID constants
    let imageCellID = "imageListCell"
    let headerId = "headerID"
    let footerId = "footerId"
    
    var imagesHeightArray: [Int] = DataStore.shared.galleryItemsHeight ?? []
    
    var selectedItemIndex: Int? = nil
    
    private var tempDeletedArray: [GalleryItem] = []
    
    // MARK: Methods

    /// Generates a single gallery item
    private func createGalleryItem() -> GalleryItem? {
        // Create a random size for the image
        let randomImageSize = Int.random(in: 150...350)
        imagesHeightArray.append(randomImageSize)
        let imageUrlString = "https://picsum.photos/200/\(randomImageSize)"
        if let url = URL(string: imageUrlString) {
            let title = "Title:"
            let description = "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document."
            return GalleryItem(with: url, title, and: description)
        }
        return nil
    }
    
    /// Creates an array of gallery items and stores them  in cache
    func createGalleryItemsArray(completion: @escaping(_ finished: Bool) -> Void) {
        guard DataStore.shared.galleryItems?.isEmpty ?? true  else {
            galleryItemsUpdated.send(true)
            completion(true)
            return
        }
        imagesHeightArray = []
        var itemsArray: [GalleryItem] = []
        for _ in 0...14 {
            if let item = createGalleryItem() {
                itemsArray.append(item)
            }
        }
        // Update the cached items and notify the view controller to refresh
        galleryItems = itemsArray
        saveChanges()
        completion(true)
    }
    
    /// Deletes the selected galleryItem
    func removeSelectedItem() {
        guard selectedItemIndex != nil else { return }
        // add the deleted item to trash list
        tempDeletedArray.append(galleryItems[selectedItemIndex!])
        // remove the deleted items from gallery list
        galleryItems.remove(at: selectedItemIndex!)
        imagesHeightArray.remove(at: selectedItemIndex!)
        saveChanges()
        // reset the selected item index
        selectedItemIndex = nil
    }
    
    /// Saves new item to the collection
    func save(_ galleryItem: GalleryItem) {
        DataStore.shared.galleryItems?.append(galleryItem)
        DataStore.shared.galleryItemsHeight?.append(200)
        imagesHeightArray.append(200)
        galleryItems.append(galleryItem)
    }
    
    func saveChanges() {
        DataStore.shared.galleryItems = galleryItems
        DataStore.shared.galleryItemsHeight = imagesHeightArray
        DataStore.shared.deletedGalleryList = tempDeletedArray
    }
    
    /// Checks if 10 minutes have passed to delete the extra images
    func checkForExcessItems() {
        // If the timer is not initialized give it a value of now
        guard let passedTime = DataStore.shared.lastDeletionTimer else {
            DataStore.shared.lastDeletionTimer = Date()
            return
        }
        let exessDate = passedTime.addingTimeInterval(60000)
        if Date() >= exessDate {
            for (index, element) in galleryItems.enumerated() {
                if index >= 10 {
                    galleryItems.removeLast()
                    imagesHeightArray.removeLast()
                    tempDeletedArray.append(element)
                }
            }
            // The new timer is set from now and the changes have been saved
            DataStore.shared.lastDeletionTimer = Date()
            saveChanges()
        }
    }
}
