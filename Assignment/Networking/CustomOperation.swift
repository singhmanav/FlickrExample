//
//  CustomOperation.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import UIKit

class CustomOperation :Operation{
    
    var downloadHandler: ImageDownloadHandler?
    var imageUrl: URL!
    private var indexPath: IndexPath?
    
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            return
        }
        self.downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let downloadTask = URLSession.shared.downloadTask(with: self.imageUrl) { (url, response, error) in
            if let url = url, let data = try? Data(contentsOf: url){
                let image = UIImage(data: data)
                self.downloadHandler?(image, self.indexPath,error)
            }
        }
        downloadTask.resume()
    }
}
