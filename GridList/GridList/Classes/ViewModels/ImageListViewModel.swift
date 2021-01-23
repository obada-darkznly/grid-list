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
    private(set) var galleryItems: [GalleryItem] = DataStore.shared.galleryItems ?? []
    
    /// Notifies the view controller that the data has changed, in order to refresh the collection view
    var galleryItemsUpdated = CurrentValueSubject<Bool, Never>(false)
    
    // NIBs ID constants
    let imageCellID = "imageListCell"
    let headerId = "headerID"
    let footerId = "footerId"
    
    private(set) var imagesHeightArray: [Int] = []
    
    // MARK: Methods

    /// Generates a single gallery item
    private func createGalleryItem() -> GalleryItem? {
        // Create a random size for the image
        let randomImageSize = Int.random(in: 200...300)
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
        guard DataStore.shared.galleryItems == nil else {
            galleryItemsUpdated.send(true)
            completion(true)
            return
        }
        imagesHeightArray = []
        var itemsArray: [GalleryItem] = []
        for _ in 0...9 {
            if let item = createGalleryItem() {
                itemsArray.append(item)
            }
        }
        // Update the cached items and notify the view controller to refresh
        DataStore.shared.galleryItems = itemsArray
        galleryItems = itemsArray
        completion(true)
        galleryItemsUpdated.send(true)
    }
    
    /// Deletes the selected galleryItem
    func removeSelectedItem() {
        
    }
    
}
