//
//  DataStore.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import Foundation


class DataStore: NSObject{
    
    // MARK: Cache keys
    private let CACHE_KEY_GALLERY_LIST = "CACHE_KEY_GALLERY_LIST"
    private let CACHE_KEY_GALLERY_ITEMS_HEIGHT = "CACHE_KEY_GALLERY_ITEMS_HEIGHT"
    private let CACHE_KEY_DELETED_GALLERY_LIST = "CACHE_KEY_DELETED_GALLERY_LIST"
    
    // MARK: Temp data holders
    private var _galleryItems: [GalleryItem]?
    private var _deletedGalleryList: [GalleryItem]?
    private var _galleryItemsHeight: [Int]?
    
    // MARK: Singelton
    public static var shared: DataStore = DataStore()
    
    // MARK: Encoders and Decoders
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // MARK: Cached data
    var galleryItems: [GalleryItem]? {
        set {
            _galleryItems = newValue
            do {
                let jsonData = try encoder.encode(_galleryItems)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    saveStringWithKey(stringToStore: jsonString, key: CACHE_KEY_GALLERY_LIST)
                }
            } catch {
                print("Error in saving the gallery items")
            }
        }
        get {
            if (_galleryItems == nil) {
                do {
                    // decode the data to object
                    if let jsonData = loadStringForKey(key: CACHE_KEY_GALLERY_LIST).data(using: .utf8) {
                        _galleryItems = try decoder.decode([GalleryItem].self, from: jsonData)
                    }
                } catch {
                    print("Error in decoding data")
                }
            }
            return _galleryItems
        }
    }
    
    var deletedGalleryList: [GalleryItem]? {
        set {
            _deletedGalleryList = newValue
            do {
                let jsonData = try encoder.encode(_deletedGalleryList)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    saveStringWithKey(stringToStore: jsonString, key: CACHE_KEY_DELETED_GALLERY_LIST)
                }
            } catch {
                print("Error in saving the gallery items")
            }
        }
        get {
            if (_deletedGalleryList == nil) {
                do {
                    // decode the data to object
                    if let jsonData = loadStringForKey(key: CACHE_KEY_DELETED_GALLERY_LIST).data(using: .utf8) {
                        _deletedGalleryList = try decoder.decode([GalleryItem].self, from: jsonData)
                    }
                } catch {
                    print("Error in decoding data")
                }
            }
            return _deletedGalleryList
        }
    }
    
    var galleryItemsHeight: [Int]? {
        set {
            _galleryItemsHeight = newValue
            do {
                let jsonData = try encoder.encode(_galleryItemsHeight)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    saveStringWithKey(stringToStore: jsonString, key: CACHE_KEY_GALLERY_ITEMS_HEIGHT)
                }
            } catch {
                print("Error in saving the gallery items height")
            }
        }
        get {
            if (_galleryItemsHeight == nil) {
                do {
                    // decode the data to object
                    if let jsonData = loadStringForKey(key: CACHE_KEY_GALLERY_ITEMS_HEIGHT).data(using: .utf8) {
                        _galleryItemsHeight = try decoder.decode([Int].self, from: jsonData)
                    }
                } catch {
                    print("Error in decoding the heights")
                }
            }
            return _galleryItemsHeight
        }
    }
    
    // MARK: Caching methods
    
    public func loadStringForKey(key:String) -> String {
        let storedString = UserDefaults.standard.object(forKey: key) as? String ?? ""
        return storedString;
    }
    
    public func saveStringWithKey(stringToStore: String, key: String) {
        UserDefaults.standard.set(stringToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func removeStringWithKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key);
        UserDefaults.standard.synchronize();
    }
}


