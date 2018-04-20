//
//  EditProfileTextFieldTableViewCell.swift
//  Yamo
//
//  Created by Mo Moosa on 09/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class EditProfileTextFieldTableViewCell: EditProfileTableViewCell {

    @IBOutlet weak var textField: UITextField!
    override func updateWithModel(model: EditProfileViewModel) {
        super.updateWithModel(model)
        
        if let textFieldItem = model.editProfileItem as? EditProfileTextItem {
            
            self.textField.text = textFieldItem.currentValue
            
            self.textFieldDidChange(self.textField)
        }
    }
    
    @IBAction func textFieldDidChange(sender: UITextField) {
        
        guard let text = sender.text else {
            return
        }
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoDarkGray()]
        let attributedString = NSAttributedString(string: text, attributes: attributes)

        textField.attributedText = attributedString
    }
    
}