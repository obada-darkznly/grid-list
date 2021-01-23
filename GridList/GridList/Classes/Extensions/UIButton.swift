//
//  UIButton.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit


extension UIButton {
    
    /// Applies app style to the button
    func appStyle(title: String, backgroundColor: UIColor = .black, titleColor: UIColor = .white, cornerRadius: CGFloat = 8 ) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(titleColor, for: .normal)
    }
}
