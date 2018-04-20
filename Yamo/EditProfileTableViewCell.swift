//
//  EditProfileTableViewCell.swift
//  Yamo
//
//  Created by Mo Moosa on 05/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

enum EditProfileTableViewCellExpandedState: Int {
    
    case Collapsed, Expanded
}

@objc protocol EditProfileTableViewCellDelegate {
    
    func cellDidUpdate(cell: EditProfileTableViewCell)
}

let EditProfileTableViewCellShadowOpacity: Float = 0.2

class EditProfileTableViewCell: UITableViewCell {

    weak var delegate: EditProfileTableViewCellDelegate?
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var expandedConstraint: NSLayoutConstraint!
    @IBOutlet var collapsedConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTrailingConstraint: NSLayoutConstraint!
    
    var hidesToggleSwitch = false {
        
        didSet {
            
            let padding: CGFloat = 12.0
            
            if hidesToggleSwitch {
                
                self.toggleSwitch.hidden = true
                self.titleLabelTrailingConstraint.constant = padding
            }
            else {
                
                self.toggleSwitch.hidden = false
                self.titleLabelTrailingConstraint.constant = (padding * 2) + 49.0
            }
            
            self.setNeedsLayout()
        }
    }
    
    var expandedState = EditProfileTableViewCellExpandedState.Collapsed {
        
        didSet {
            
            switch expandedState {
                
            case .Expanded:
                
                self.expandedConstraint.priority = 999
                self.collapsedConstraint.priority = 250
                self.toggleSwitch.setOn(true, animated: false)
                self.bottomView.alpha = 1.0
                
            case .Collapsed:
                
                self.expandedConstraint.priority = 250
                self.collapsedConstraint.priority = 999
                self.toggleSwitch.setOn(false, animated: false)
                self.bottomView.alpha = 0.0
            }
            
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.topView.layer.shadowOffset = CGSizeMake(0.0, 3.0)
        self.topView.layer.shadowColor = UIColor.blackColor().CGColor
        self.topView.layer.shadowRadius = 2.0
        self.topView.layer.shadowOpacity = EditProfileTableViewCellShadowOpacity
        self.contentView.bringSubviewToFront(self.topView)
    }
    
    func updateWithModel(model: EditProfileViewModel) {
    
        if model.expanded && model.canExpand {
            
            self.expandedState = .Expanded
        }
        else {
            
            self.expandedState = .Collapsed
        }
        
        self.topView.layer.shadowOpacity = (model.canExpand && model.expanded) ? EditProfileTableViewCellShadowOpacity : 0.0

        // toggleSwitch.on = model.toggleState

        self.hidesToggleSwitch = !model.editProfileItem.canBeToggled
        if (!self.hidesToggleSwitch) {
            toggleSwitch.setOn(model.toggleState, animated: true)
        }
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoBlack()]
        let attributedString = NSAttributedString(string: model.editProfileItem.title, attributes: attributes)
        
        self.titleLabel.attributedText = attributedString
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
    @IBAction func handleToggleSwitchValueChange(sender: AnyObject) {
        
        self.delegate?.cellDidUpdate(self)
    }
}
