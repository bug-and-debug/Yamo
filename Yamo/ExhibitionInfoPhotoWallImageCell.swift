//
//  ExhibitionInfoPhotoWallImageCell.swift
//  Yamo
//
//  Created by Hungju Lu on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import AFNetworking

let ExhibitionInfoPhotoWallImageCellNibName = "ExhibitionInfoPhotoWallImageCell"

class ExhibitionInfoPhotoWallImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View Configuration
    
    func configureView(photoURL urlString: String) {
        if let url = NSURL(string: urlString) {
            self.imageView.setImageWithURL(url)
        }
    }
    
    class func countForColumns(overallCellsCount: Int) -> Int {
        switch overallCellsCount {
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 3
        }
    }
    
    class func sizeForCell(overallCellsCount: Int) -> CGSize {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let overallCellsCount = CGFloat(self.countForColumns(overallCellsCount))
        let width = (screenWidth - 15 * 2 - 10 * (overallCellsCount - 1)) / overallCellsCount
        return CGSizeMake(width, width)
    }
}
