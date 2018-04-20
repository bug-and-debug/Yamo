//
//  EditProfileTextItem.swift
//  Yamo
//
//  Created by Mo Moosa on 09/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class EditProfileTextItem: EditProfileItem {
    var currentValue: String?
    init(title: String, currentValue: String?) {
        
        super.init(title: title)
        self.title = title
        self.currentValue = currentValue
    }

}
