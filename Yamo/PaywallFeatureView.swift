//
//  PaywallFeatureView.swift
//  Yamo
//
//  Created by Hungju Lu on 04/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class PaywallFeatureView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    class func loadFromNib() -> PaywallFeatureView {
        let nib = UINib(nibName: "PaywallFeatureView", bundle: nil)
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        if let view = views.first as? PaywallFeatureView {
            return view
        } else {
            return PaywallFeatureView()
        }
    }
}
