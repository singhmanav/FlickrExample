//
//  ImageDownloadManager.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class ImageDownloadManager {
    
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "imageDownloadQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    private init () {}
    
    func downloadImage(_ photo: Photos, indexPath: IndexPath?, handler: @escaping ImageDownloadHandler) {
        guard let url = photo.getImageURL() else {
            return
        }
        if let cachedImage = imageCache.object(forKey: photo.id as NSString) {
            handler(cachedImage, indexPath, nil)
        } else {
                let operation = CustomOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                }
            operation.queuePriority = .high
                operation.downloadHandler = { (image, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: photo.id as NSString)
                    }
                    handler(image, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
        }
    }
    
    func slowDownImageDownloadTaskfor (_ photo: Photos) {
        guard let url = photo.getImageURL() else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [CustomOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
    
    
}
