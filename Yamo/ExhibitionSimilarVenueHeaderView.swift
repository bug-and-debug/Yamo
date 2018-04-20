//
//  ExhibitionSimilarVenueHeaderView.swift
//  Yamo
//
//  Created by Peter Su on 02/08/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIColor_LOCExtensions

let ExhibitionSimilarVenueHeaderViewNibName = "ExhibitionSimilarVenueHeaderView"
let ExhibitionSimilarVenueHeaderViewHeight: CGFloat = 80

class ExhibitionSimilarVenueHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoGray(),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0)]
        let attributedString = NSAttributedString(string: NSLocalizedString("Similar exhibitions", comment: ""), attributes: attributes)
        self.titleLabel.attributedText = attributedString
    }

}
