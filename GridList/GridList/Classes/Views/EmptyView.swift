//
//  EmptyView.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit


class EmptyView: AbstractNibView {
    
    // MARK: Outlets
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: Properties
    var delegate: EmptyViewDelegate?
    
    //MARK: View's life cycle
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: View's customization
    override func customizeView() {
        actionButton.appStyle(title: "Add an image")
    }
    
    // MARK: Actions
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        delegate?.actionButtonPressed()
    }
}
