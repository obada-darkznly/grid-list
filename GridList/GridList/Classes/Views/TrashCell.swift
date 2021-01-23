//
//  TrashCell.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit



class TrashCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: Cell's life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    // MARK: Cell's customization
    func customizeView() {
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 16)
    }
    
    // MARK: Cell's population
    func populate(with galleryItem: GalleryItem) {
        galleryImageView.sd_setImage(with: galleryItem.image)
        descriptionLabel.text = galleryItem.description
    }
}
