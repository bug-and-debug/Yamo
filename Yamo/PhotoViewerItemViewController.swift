//
//  PhotoViewerItemViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class PhotoViewerItemViewController: UIViewController, UIScrollViewDelegate {

    var currentItemIndex: Int = 0
    var photoURL: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.clipsToBounds = true
        
        if let urlString = self.photoURL, let url = NSURL(string: urlString) {
            self.imageView.setImageWithURLRequest(NSURLRequest(URL: url), placeholderImage: nil, success: { (_, _, image) in
                self.imageView.image = image
                self.scrollView.setZoomScale(1.0, animated: false)
                }, failure: nil)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
