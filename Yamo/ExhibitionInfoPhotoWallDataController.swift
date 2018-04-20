//
//  ExhibitionInfoPhotoWallDataController.swift
//  Yamo
//
//  Created by Hungju Lu on 25/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

protocol ExhibitionInfoPhotoWallDataControllerDelegate: class {
    func exhibitionInfoPhotoWallDataController(dataController: ExhibitionInfoPhotoWallDataController,
                                               didRequireShowingPhotoWithIndex: Int,
                                               inAllPhotos: [String])
}

class ExhibitionInfoPhotoWallDataController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate:ExhibitionInfoPhotoWallDataControllerDelegate?
    
    var photoURLs: [String] = [String]()
    
    var cachedCurrentShowingPage: Int = 0
    
    private var collectionView: UICollectionView!
    
    // MARK: - Initialize
    
    func initializeDataController(collectionView collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.scrollEnabled = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        collectionView.registerNib(UINib(nibName: ExhibitionInfoPhotoWallImageCellNibName, bundle: nil),
                                   forCellWithReuseIdentifier: ExhibitionInfoPhotoWallImageCellNibName)
        
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ExhibitionInfoPhotoWallImageCellNibName, forIndexPath: indexPath)
        
        if let cell = cell as? ExhibitionInfoPhotoWallImageCell {
            cell.configureView(photoURL: self.photoURLs[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return ExhibitionInfoPhotoWallImageCell.sizeForCell(self.photoURLs.count)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.exhibitionInfoPhotoWallDataController(self, didRequireShowingPhotoWithIndex: indexPath.row, inAllPhotos: self.photoURLs)
    }
}
