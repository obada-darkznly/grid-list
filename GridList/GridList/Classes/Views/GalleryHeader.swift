//
//  GalleryHeader.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import UIKit
import Combine



class GalleryHeader: UICollectionReusableView {
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var activityIndicatorSubscriber: AnyCancellable?
    
    
    // MARK: View's life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    // MARK: View's customization
    func customizeView() {
        // container view
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .lightGray
        // activity indicator
        activityIndicator.isHidden = true
        activityIndicator.color = .white
        activityIndicator.style = .medium
        // searchImage
        searchImage.isHidden = false
        // seach text field
        searchTextField.delegate = self
        searchTextField.font = UIFont.systemFont(ofSize: 18)
        searchTextField.textColor = .white
        searchTextField.placeholder = "Search"
        
    }
    
    
}

// MARK:- Textfield delegate
extension GalleryHeader: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func isLoading(loading: Bool) {
        // if loading show indicator
        if loading {
            searchImage.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            // hide the loader after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.searchImage.isHidden = false
            }
        }
    }
}

