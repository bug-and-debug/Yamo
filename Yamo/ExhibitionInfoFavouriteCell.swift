//
//  ExhibitionInfoFavouriteCell.swift
//  Yamo
//
//  Created by Hungju Lu on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

let ExhibitionInfoFavouriteCellNibName = "ExhibitionInfoFavouriteCell"
let ExhibitionInfoFavouriteCellDefaultHeight: CGFloat = 45.0

class ExhibitionInfoFavouriteCell: ExhibitionInfoCell {

    @IBOutlet weak var favouriteButton: UIButton!
    
    private var favorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View Configuration
    
    func configureView(favorited favorited: Bool) {
        self.favorited = favorited
        
        favouriteButton.setTitle((favorited ? NSLocalizedString("Favourited", comment: "") : NSLocalizedString("Favourite", comment: "")), forState: .Normal)
        favouriteButton.setImage((favorited ? UIImage(named: "Iconlightfavouriteactive") : UIImage(named: "Iconlightfavouritedisabled")), forState: .Normal)
    }
    
    // MARK: - Actions
    
    @IBAction func favouriteButtonPressed(sender: UIButton) {
        self.delegate?.exhibitionInfoCell?(self, didChangedFavorited: self.favorited)
    }
}
