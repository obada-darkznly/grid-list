//
//  AbstractNibView.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit

// Usage: Subclass UIView from NibLoadView to automatically load a xib with the same name as your class
open class AbstractNibView: UIView {
    // MARK: Properties
    var view: UIView!
    
    // MARK: Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        customizeView()
    }
    
    /// setup views fonts colors and so on
    open func customizeView() {
    }
    
    /// do any geometric process here
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

