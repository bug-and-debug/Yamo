//
//  GTKMPageViewController.swift
//  Yamo
//
//  Created by Vlad Buhaescu on 17/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import AFNetworking

let GetToKnowMeImageRequestCancelledErrorCode = -999

@objc protocol GetToKnowMePageViewControllerDelegate {
    func getToKnowMePageDidFailedLoading(controller: GetToKnowMePageViewController)
}

class GetToKnowMePageViewController: UIViewController {
    
    weak var delegate: GetToKnowMePageViewControllerDelegate?
    
    private let imageViewForArtWork = UIImageView()
    
    private var imageForArtWork: UIImage?
    
    private var currentDownloadReceipt: AFImageDownloadReceipt?
    
    var artWork: ArtWork? {
        didSet {
            self.imageViewForArtWork.image = nil
            self.imageForArtWork = nil
            
            self.reloadImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViewForArtWork.translatesAutoresizingMaskIntoConstraints = false
        self.imageViewForArtWork.contentMode = .ScaleAspectFill
        self.imageViewForArtWork.clipsToBounds = true
        self.view.addSubview(imageViewForArtWork)
        self.view.addConstraints(self.imageViewConstraints())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = self.imageForArtWork {
            self.imageViewForArtWork.image = image
        } else if self.currentDownloadReceipt == nil {
            self.delegate?.getToKnowMePageDidFailedLoading(self)
        }
    }
    
    // MARK: Image loading
    
    func reloadImage() {
        if let receipt = self.currentDownloadReceipt {
            receipt.task.cancel()
            self.imageForArtWork = nil
        }
        
        guard let artWork = self.artWork,
            let url = NSURL(string: artWork.imageUrlArtWork) else {
                return
        }
        
        self.showIndicator(true)
        
        let request = NSURLRequest(URL: url)
        
        self.currentDownloadReceipt = AFImageDownloader.defaultInstance().downloadImageForURLRequest(request, success: { (request, response, image) in
            
            // This is suitable for now as the user can't zoom in on the image.
            let resizedImage = image.resizeproportionallyToWidth(UIScreen.mainScreen().bounds.size.width)
            
            self.imageForArtWork = resizedImage
            self.imageViewForArtWork.image = resizedImage
            self.showIndicator(false)
            
            self.currentDownloadReceipt = nil
            
            }, failure: { (request, response, error) in
                self.showIndicator(false)
                print("Error fetching artwork: \(error)")
                
                self.currentDownloadReceipt = nil
                
                if error.code != GetToKnowMeImageRequestCancelledErrorCode {
                    
                    self.delegate?.getToKnowMePageDidFailedLoading(self)
                }
        })
    }
    
    // MARK: Constraints
    
    func imageViewConstraints() -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint.init(
                item:imageViewForArtWork
                , attribute:.Top
                , relatedBy: .Equal
                , toItem: view
                , attribute: .Top
                , multiplier: 1.0
                , constant: 0
            ),NSLayoutConstraint.init(
                item:imageViewForArtWork
                , attribute:.Bottom
                , relatedBy: .Equal
                , toItem: view
                , attribute: .Bottom
                , multiplier: 1.0
                , constant: 0
            ),
              NSLayoutConstraint.init(
                item:imageViewForArtWork
                , attribute:.Leading
                , relatedBy: .Equal
                , toItem: view
                , attribute: .Leading
                , multiplier: 1.0
                , constant: 0
            ),
              NSLayoutConstraint.init(
                item:imageViewForArtWork
                , attribute:.Trailing
                , relatedBy: .Equal
                , toItem: view
                , attribute: .Trailing
                , multiplier: 1.0
                , constant: 0
            )]
    }
    
}
