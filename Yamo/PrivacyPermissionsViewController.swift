//
//  PrivacyPermissionsViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 27/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class PrivacyPermissionsViewController: PlaceholderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Privacy", comment: "")
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
 
    @IBAction func handleButtonTap(sender: AnyObject) {
        
        self.onboardingDelegate?.viewControllerDidFinish(self)
    }
  
}
