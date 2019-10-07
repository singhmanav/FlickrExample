//
//  FlickrDetailViewController.swift
//  Assignment
//
//  Created by xeadmin on 06/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import UIKit

class FlickrDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var detailViewModel:FlickrDetailViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() -> Void {
        ImageDownloadManager.shared.downloadImage(detailViewModel.photo, indexPath: nil) { [unowned self](image, _, error) in
            if let image = image{
                self.imageView.image = image
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
