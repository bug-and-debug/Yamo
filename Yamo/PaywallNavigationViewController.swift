//
//  PaywallNavigationViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 07/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

@objc protocol PaywallNavigationViewControllerDelegate: class {
    func paywallDidFinishedSubscription(hasSubscription: Bool)
}

class PaywallNavigationController: UINavigationController {

    weak var paywallDelegate: PaywallNavigationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func presentPaywall(inViewController viewController: UIViewController, paywallDelegate: PaywallNavigationViewControllerDelegate?) -> PaywallNavigationController {
        let paywallViewController = PaywallViewController(nibName: "PaywallViewController", bundle: nil)
        let navigationController = PaywallNavigationController(rootViewController: paywallViewController)
        navigationController.paywallDelegate = paywallDelegate
        
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
        return navigationController
    }
}