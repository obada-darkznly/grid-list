//
//  ImageListViewController.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import UIKit


class ImageListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    let viewModel = ImageListViewModel()
    
    private var collectionViewLayout: UICollectionViewFlowLayout? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    private var resizingLayout: UICollectionViewFlowLayout {
        let _layout = UICollectionViewFlowLayout()
        _layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        _layout.minimumInteritemSpacing = 8
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .vertical
        return _layout
    }
    
    private var fixedLayout: UICollectionViewFlowLayout {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize(width: (view.frame.width - 16) / 2 , height: 250)
        _layout.minimumInteritemSpacing = 8
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .vertical
        return _layout
    }
    
    // MARK: Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Customization
    func customizeViews() {
        
    }
    
    
    
}

// MARK:- Collection view delegate and data source
extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.galleryItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
