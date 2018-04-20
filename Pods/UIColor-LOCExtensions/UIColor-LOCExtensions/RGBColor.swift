//
//  RGBColor.swift
//  UIColor+LOCExtensions
//
//  Created by Jose Fernandez on 15/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

import UIKit

// An extension of UIColor (on iOS) or NSColor (on OSX) providing RGB color handling.
public extension LOCColor {

    public convenience init?(red255Based: Int, green255Based: Int, blue255Based: Int, alpha100Based: Int) {
        self.init(red: CGFloat(red255Based) / 255.0, green: CGFloat(green255Based) / 255.0, blue: CGFloat(blue255Based) / 255.0, alpha: CGFloat(alpha100Based) / 100.0)
    }
    
    public convenience init?(red255Based: Int, green255Based: Int, blue255Based: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red255Based) / 255.0, green: CGFloat(green255Based) / 255.0, blue: CGFloat(blue255Based) / 255.0, alpha: alpha)
    }
    
    public convenience init?(hue255Based: Int, saturation255Based: Int, brightness255Based: Int, alpha100Based: Int) {
        self.init(hue: CGFloat(hue255Based) / 255.0, saturation: CGFloat(saturation255Based) / 255.0, brightness: CGFloat(brightness255Based) / 255.0, alpha: CGFloat(alpha100Based) / 100.0)
    }
}

