//
//  TrashViewController.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit
import Combine


class TrashViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let viewModel = TrashViewModel()
    var refreshTableViewSubscriber: AnyCancellable?
    
    // MARK: Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        
        refreshTableViewSubscriber = viewModel.deletedGalleryListUpdated.sink(receiveValue: { (_) in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refreshDeletedList()
    }
    
    // MARK: Controller's customization
    func customizeView() {
        
        // register cell nib
        let cellNib = UINib(nibName: "TrashCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: viewModel.trashCellId)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK:- UITableViewDelegate and DataSource
extension TrashViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.deletedGalleryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: viewModel.trashCellId) as? TrashCell else { return UITableViewCell() }
        cell.populate(with: viewModel.deletedGalleryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.selectedItemIndex = indexPath.row
            viewModel.deleteSelectedItem()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
}
