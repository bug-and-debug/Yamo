//
//  ExhibitionSimilarVenueTableViewCell.swift
//  Yamo
//
//  Created by Peter Su on 02/08/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

let ExhibitionSimilarVenueTableViewCellNibName = "ExhibitionSimilarVenueTableViewCell"
let ExhibitionSimilarVenueTableViewCellEstimatedHeight: CGFloat = 284

class ExhibitionSimilarVenueTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholderContentView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var exhibitionNameLabel: UILabel!
    @IBOutlet weak var exhibitionLocationNameLabel: UILabel!
    @IBOutlet weak var locationIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.exhibitionNameLabel.font = UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 17.5)
        self.exhibitionNameLabel.textColor = UIColor.yamoBlack()
        
        self.exhibitionLocationNameLabel.font = UIFont.preferredFontForStyle(.GraphikRegular, size: 12)
        self.exhibitionLocationNameLabel.textColor = UIColor.yamoDarkGray()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
