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
        _layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 64, right: 0)
        return _layout
    }
    // The automatic sizing layout
    private var autoSizedLayout: UICollectionViewFlowLayout {
        let _layout = UICollectionViewFlowLayout()
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .vertical
        _layout.headerReferenceSize = CGSize(width: view.frame.width - 64, height: 80)
        _layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 64, right: 0)
        return _layout
    }
    
    private var isAutomaticLayout: Bool = false
    
    
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
        // add the gesture recognizer to the collection view
        addLongGestureToCollectionView()
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
    
    func addLongGestureToCollectionView() {
        
        // create the getsure
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    // MARK: Actions
    @objc func cameraButtonPressed() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            break
        }
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            collectionView.setCollectionViewLayout(fixedLayout, animated: true)
        } else {
            collectionView.setCollectionViewLayout(autoSizedLayout, animated: false)
        }
        isAutomaticLayout.toggle()
        collectionView.performBatchUpdates({
            collectionView.layoutIfNeeded()
        }, completion: nil)
    }
    
}

// MARK:- Layout delegate
extension ImageListViewController: LayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: viewModel.imagesHeightArray[indexPath.item] + 64)
    }
}

// MARK:- Collection view delegate and data source
extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func headerWidth(indexPath: IndexPath) -> CGFloat {
        return view.frame.width - 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isAutomaticLayout {
            return  CGSize(width: view.frame.width / 2 , height: CGFloat(viewModel.imagesHeightArray[indexPath.item]))
        } else {
            return CGSize(width: view.frame.width / 2 , height: 250)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // remove the
        let galleryItem = viewModel.galleryItems.remove(at: sourceIndexPath.row)
        let galleryItemHeight = viewModel.imagesHeightArray.remove(at: sourceIndexPath.row)
        
        viewModel.galleryItems.insert(galleryItem, at: destinationIndexPath.row)
        viewModel.imagesHeightArray.insert(galleryItemHeight, at: destinationIndexPath.row)
        
        viewModel.saveChanges()
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
