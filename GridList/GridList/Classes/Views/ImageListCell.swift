//
//  ImageListCell.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import UIKit


class ImageListCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Cell's life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeCell()
    }
    
    // MARK: Cell's customization
    func customizeCell() {
        
        // container view
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .gray
        containerView.clipsToBounds = true
        // titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        // description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    func populateWith() {
        
    }
}