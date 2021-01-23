//
//  ImageListViewController.swift
//  GridList
//
//  Created by Obada on 1/22/21.
//

import UIKit
import Combine


class ImageListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    let viewModel = ImageListViewModel()
    
    /// Listens to any changes to the data array to refresh the table view
    var shouldRefreshCollectionView: AnyCancellable?
    
    /// The fixed size for items layout
    private var fixedLayout: UICollectionViewFlowLayout {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize(width: view.frame.width / 2 , height: 250)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .vertical
        _layout.headerReferenceSize = CGSize(width: view.frame.width - 64, height: 80)
        _layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return _layout
    }
    
    /// The automatically resized layout
    private var autoResizedLayout: BaseLayout = AutoResizedLayout()
    
    // MARK: Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the data array
        
            viewModel.createGalleryItemsArray { (_) in
                self.customizeViews()
            }
        // Listen to changes to the data
        shouldRefreshCollectionView = viewModel.galleryItemsUpdated.sink(receiveValue: { (refresh) in
            if refresh {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    // MARK: Customization
    func customizeViews() {
        
        // Auto resize layout delegate
        autoResizedLayout.delegate = self
        autoResizedLayout.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)
        
        
        // Collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        // Cell's nib registration
        let cellNib = UINib(nibName:"ImageListCell", bundle: nil)
        let headerNib = UINib(nibName: "GalleryHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: viewModel.headerId)
        collectionView.register(cellNib, forCellWithReuseIdentifier: viewModel.imageCellID)
        // Initial collectionViewLayout
        collectionView.collectionViewLayout = fixedLayout
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.reloadData()
    }
    
    
    
}

// MARK:- Layout delegate
extension ImageListViewController: LayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: viewModel.imagesHeightArray[indexPath.item])
    }
}

// MARK:- Collection view delegate and data source
extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.galleryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.imageCellID,
                                                            for: indexPath) as? ImageListCell else { return UICollectionViewCell() }
        cell.populateWith(viewModel.galleryItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: viewModel.headerId,
                                                                                   for: indexPath) as? GalleryHeader else { return UICollectionReusableView() }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            break
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func headerWidth(indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
