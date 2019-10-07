//
//  ViewController.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var photoViewModel : PhotosViewModel!
    var searchBar :UISearchBar!
    var bottomRefreshController : UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = UISearchBar()
        self.navigationItem.titleView = self.searchBar
        self.photoViewModel = PhotosViewModel(photos: [],numberOfPhotos: 0)
        self.collectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RefreshFooterView")
        self.searchBar.delegate = self
        self.bottomRefreshController = UIRefreshControl()
        self.collectionView.refreshControl = bottomRefreshController
        
    }
    
    @IBAction func showOptionsAction (_ sender: Any) {
        self.searchBar.resignFirstResponder()
        self.showOptions()
    }
    
    func showOptions () {
        let actionSheetController: UIAlertController = UIAlertController(title: "FlickrTest", message: "Images per row", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let option1 = UIAlertAction(title: "2", style: .default)
        { _ in
            print("2")
            self.itemsPerRow = 2
            self.collectionView?.reloadData()
        }
        actionSheetController.addAction(option1)
        
        let option2 = UIAlertAction(title: "3", style: .default)
        { _ in
            print("3")
            self.itemsPerRow = 3
            self.collectionView?.reloadData()
        }
        actionSheetController.addAction(option2)
        let option3 = UIAlertAction(title: "4", style: .default)
        { _ in
            print("4")
            self.itemsPerRow = 4
            self.collectionView?.reloadData()
        }
        actionSheetController.addAction(option3)
        self.present(actionSheetController, animated: true, completion: nil)
    }

}

