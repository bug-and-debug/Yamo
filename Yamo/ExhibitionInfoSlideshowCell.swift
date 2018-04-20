//
//  ExhibitionInfoSlideshowCell.swift
//  Yamo
//
//  Created by Hungju Lu on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import AFNetworking
import UIColor_LOCExtensions

let ExhibitionInfoSlideshowCellNibName = "ExhibitionInfoSlideshowCell"
let ExhibitionInfoSlideshowCellDefaultHeight: CGFloat = 190.0

class ExhibitionInfoSlideshowCell: ExhibitionInfoCell, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentPageIndex: Int = 0
    
    private var photoURLs: [String] = [String]()
    private var photoLoaded: [Int: Bool] = [Int: Bool]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View Configuration
    
    func configureView(photoURLs photoURLs: [String], currentPageIndex: Int) {
        self.photoURLs = photoURLs
        self.pageControl.numberOfPages = photoURLs.count
        
        for subView in self.scrollView.subviews {
            subView.removeFromSuperview()
        }
        
        let pageWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        for i in 0..<photoURLs.count {
            let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * pageWidth, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)))
            imageView.contentMode = .ScaleAspectFill
            
            if let url = NSURL(string: photoURLs[i]),
                let placeholder = UIImage.init(named: "Placeholder") {
                
                imageView.setImageWithURLRequest(NSURLRequest(URL: url), placeholderImage: placeholder, success: { (_, _, image) in
                    
                    imageView.image = image
                    self.photoLoaded[i] = true
                    
                    }, failure: { (_, _, _) in
                        self.photoLoaded[i] = false
                })
            }
            
            self.scrollView.addSubview(imageView)
        }
        
        self.currentPageIndex = currentPageIndex
        let offsetX: CGFloat = pageWidth * CGFloat(currentPageIndex)
        
        self.pageControl.currentPage = currentPageIndex
        
        self.scrollView.contentSize = CGSizeMake(pageWidth * CGFloat(photoURLs.count), CGRectGetHeight(self.scrollView.frame))
        self.scrollView.contentOffset = CGPointMake(offsetX, 0)
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let pageX = CGFloat(self.currentPageIndex) * pageWidth - scrollView.contentInset.left
        
        if targetContentOffset.memory.x < pageX {
            if self.currentPageIndex > 0 {
                self.currentPageIndex -= 1
            }
        } else if targetContentOffset.memory.x > pageX {
            if self.currentPageIndex < self.photoURLs.count {
                self.currentPageIndex += 1
            }
        }
        
        targetContentOffset.memory.x = CGFloat(self.currentPageIndex) * pageWidth - scrollView.contentInset.left
        
        if let photoLoaded: Bool = self.photoLoaded[self.currentPageIndex] where photoLoaded == false {
            if let subview = self.scrollView.subviews[self.currentPageIndex] as? UIImageView,
                let url = NSURL(string: self.photoURLs[self.currentPageIndex]) {
                subview.setImageWithURL(url)
            }
        }
        
        self.pageControl.currentPage = self.currentPageIndex
        self.delegate?.exhibitionInfoCellDidRequireCacheState?(self)
    }
}
