//
//  ViewController+Extension.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoViewModel.photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        (cell as! PhotoCell).imageView.contentMode = .scaleAspectFill
        if(self.photoViewModel.photos.count-1 == indexPath.row){
            self.downloadphotoList(page:indexPath.row/18 + 2)
        }
        let photo = self.photoViewModel.photos[indexPath.row]
        (cell as! PhotoCell).imageView.image = UIImage(named: "dummyImage")
        
        ImageDownloadManager.shared.downloadImage(photo, indexPath: indexPath) { (image, imageIndexPath, error) in
            if let indexPathNew = imageIndexPath, indexPathNew == indexPath {
                DispatchQueue.main.async {
                    (cell as! PhotoCell).imageView.image = image
                }
            }
        }
        return cell
    }
    
    
}


extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * (itemsPerRow + 1) + 1
        let availableWidth = view.frame.width - padding
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        ImageDownloadManager.shared.cancelAll()
        self.downloadphotoList(page:1)
    }
    
    func downloadphotoList(page:Int){
        self.collectionView.refreshControl?.beginRefreshing()
        NetworkManager.shared.searchFlickr(searchBar.text ?? "", page: page) { [unowned self](photoSearchResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    let alertView = UIAlertController(title: "Error Occured", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alertView.addAction(UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        self.dismiss(animated: false, completion: nil)
                    }))
                    self.present(alertView, animated: false, completion: nil)
                }
            }
            guard let photoSearchResult = photoSearchResult else{
                return
            }
            if page == 1{
                self.photoViewModel.photos = photoSearchResult.photos.photo
                self.photoViewModel.numberOfPhotos = Int(photoSearchResult.photos.total) ?? 0
            }else {
                self.photoViewModel.photos.append(contentsOf: photoSearchResult.photos.photo)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if(self.photoViewModel.photos.count > indexPath.row){
            ImageDownloadManager.shared.slowDownImageDownloadTaskfor(self.photoViewModel.photos[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlickrDetailViewController") as? FlickrDetailViewController
        let photo = self.photoViewModel.photos[indexPath.row]
        let viewModel = FlickrDetailViewModel(photo: photo)
        vc?.detailViewModel = viewModel
        if let vc = vc{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}


