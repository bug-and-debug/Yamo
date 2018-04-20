//
//  EditProfileViewModel.swift
//  Yamo
//
//  Created by Mo Moosa on 09/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

enum ProfileItemContext : String {
    case None = "None", Nickname = "Nickname", FirstName = "First Name", LastName = "Last Name" , City = "City"
}

class EditProfileViewModel: NSObject {
    var editProfileItem: EditProfileItem
    var expanded = true
    var canExpand = true
    var toggleState = true
    
    var profileContext = ProfileItemContext.None
    
    init(editProfileItem: EditProfileItem, profileContext : ProfileItemContext) {
        
        self.profileContext = profileContext
        self.editProfileItem = editProfileItem
        
        super.init()
    }
}
