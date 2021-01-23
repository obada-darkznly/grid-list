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
    @IBOutlet weak var emptyView: EmptyView!
    
    // MARK: Properties
    let viewModel = ImageListViewModel()
    // Loading delegate to show the loader in the header
    var loadingDelegate: LoadableDelegate? = nil
    
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
    
    // MARK: Customization
    func customizeViews() {
        
        // empty view
        emptyView.delegate = self
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
    
    // MARK: Actions
    @objc func cameraButtonPressed() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
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
            headerView.cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
            headerView.delegate = loadingDelegate
            return headerView
        case UICollectionView.elementKindSectionFooter:
            break
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
}

// MARK:- UIImagePicker delegate and navigation delegate
extension ImageListViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        // Create a gallery item object and append it to the collection
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let galleryItem = GalleryItem(with: imageUrl,
                                          "Title:",
                                          and: "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document.")
            viewModel.save(galleryItem)
        }
    }
}

// MARK:- empty view delegate
extension ImageListViewController: EmptyViewDelegate {
    func actionButtonPressed() {
        loadingDelegate?.isLoading(loading: true)
    }
}
