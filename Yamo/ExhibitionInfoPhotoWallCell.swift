//
//  ExhibitionInfoPhotoWallCell.swift
//  Yamo
//
//  Created by Hungju Lu on 24/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

let ExhibitionInfoPhotoWallCellNibName = "ExhibitionInfoPhotoWallCell"
let ExhibitionInfoPhotoWallCellDefaultHeight: CGFloat = 522.0

private let BottomViewDefaultHeight: CGFloat = 68.0
private let DefaultNumberOfItemsPerPage = 6
private let ShowMoreButtonHeight: CGFloat = 63.0

class ExhibitionInfoPhotoWallCell: ExhibitionInfoCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    private var viewConfigured: Bool = false
    
    private weak var dataController: ExhibitionInfoPhotoWallDataController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoDimGray()]
        let titleText = NSAttributedString(string: NSLocalizedString("Images", comment: ""), attributes: attributes)

        self.titleLabel.attributedText = titleText
    }
    
    // MARK: - Class methods
    
    class func initialSize(countOfPhotos totalItemsCount: Int) -> CGSize {
        let cellWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        guard totalItemsCount > 0 else {
            return CGSizeMake(cellWidth, 0.0)
        }
        
        var totalHeight: CGFloat = 70.0
        
        // calculate collection view height
        let pageItemsCount = (totalItemsCount < DefaultNumberOfItemsPerPage) ? totalItemsCount : DefaultNumberOfItemsPerPage;
        let showingItemsCount = 1 * pageItemsCount
        let totalColumnsCount = ExhibitionInfoPhotoWallImageCell.countForColumns(totalItemsCount)
        let rowCount = CGFloat((showingItemsCount / totalColumnsCount) + (showingItemsCount % totalColumnsCount))
        let rowHeight = ExhibitionInfoPhotoWallImageCell.sizeForCell(totalItemsCount).height
        let collectionViewHeight = (rowCount * rowHeight) + (rowCount * 10.0)
        totalHeight += collectionViewHeight
        
        // add bottom view height
        if showingItemsCount < totalItemsCount {
            totalHeight += ShowMoreButtonHeight + 10.0
        } else {
            totalHeight += 10.0
        }
        
        return CGSizeMake(cellWidth, totalHeight)
    }
    
    // MARK: - View Configuration
    
    func configureView(dataUpdated dataUpdated: Bool, dataController: ExhibitionInfoPhotoWallDataController) -> CGSize {
        if !self.viewConfigured || dataUpdated {
            self.dataController = dataController
            dataController.initializeDataController(collectionView: self.collectionView)
            
            self.updateShowMoreButtonAppearance()
            
            self.viewConfigured = true
        }
        
        if !self.hasMoreItems() {
            self.bottomView.hidden = true
            self.bottomViewHeightConstraint.constant = 0.0
        }
        
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), self.totalHeight())
    }
    
    private func updateShowMoreButtonAppearance() {
        if !self.hasMoreItems() {
            self.bottomView.hidden = true
            self.bottomViewHeightConstraint.constant = 0.0
        }
        
        self.updateHeight()
    }
    
    private func updateHeight() {
        let size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), self.totalHeight())
        self.delegate?.exhibitionInfoCell?(self, didChangedContentSize: size)
        self.layoutIfNeeded()
    }
    
    private func hasMoreItems() -> Bool {
        guard let dataController = self.dataController else {
            return false
        }
        
        let totalItemsCount = dataController.photoURLs.count
        let pageItemsCount = (totalItemsCount < DefaultNumberOfItemsPerPage) ? totalItemsCount : DefaultNumberOfItemsPerPage;
        let showingItemsCount = (dataController.cachedCurrentShowingPage + 1) * pageItemsCount
        
        return (showingItemsCount < totalItemsCount)
    }
    
    private func totalHeight() -> CGFloat {
        guard let dataController = self.dataController else {
            return 0.0
        }
        
        var totalHeight = self.topViewHeightConstraint.constant
        
        // calculate collection view height
        let pageItemsCount = (dataController.photoURLs.count < DefaultNumberOfItemsPerPage) ? dataController.photoURLs.count : DefaultNumberOfItemsPerPage;
        let showingItemsCount = (dataController.cachedCurrentShowingPage + 1) * pageItemsCount
        let totalColumnsCount = ExhibitionInfoPhotoWallImageCell.countForColumns(dataController.photoURLs.count)
        let rowCount = CGFloat((showingItemsCount / totalColumnsCount) + (showingItemsCount % totalColumnsCount))
        let rowHeight = ExhibitionInfoPhotoWallImageCell.sizeForCell(dataController.photoURLs.count).height
        let collectionViewHeight = (rowCount * rowHeight) + (rowCount * 10.0)
        totalHeight += collectionViewHeight
        
        // add bottom view height
        if self.hasMoreItems() {
            totalHeight += self.bottomViewHeightConstraint.constant
        } else {
            totalHeight += 10.0
        }
        
        return totalHeight
    }
    
    // MARK: - Actions
    
    @IBAction func showMoreButtonPressed(sender: AnyObject) {
        guard let dataController = self.dataController else {
            return
        }
        
        dataController.cachedCurrentShowingPage += 1
        self.updateShowMoreButtonAppearance()
    }
}
