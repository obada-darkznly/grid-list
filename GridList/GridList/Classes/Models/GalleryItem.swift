//
//  GalleryItem.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import Foundation



struct GalleryItem: Codable, Hashable {
    
    // Mark: Properties
    var image: URL?
    var title: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case title
        case description
        
    }
    
    init(with url: URL, _ title: String, and description: String) {
        image = url
        self.title = title
        self.description = description
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            image = try container.decode(URL.self, forKey: .image)
            title = try container.decode(String.self, forKey: .title)
            description = try container.decode(String.self, forKey: .description)
        } catch {
            print("Error in decoding gallery items")
        }
    }
}
