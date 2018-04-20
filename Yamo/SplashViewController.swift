//
//  SplashViewController.swift
//  Yamo
//
//  Created by Jin on 7/10/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController
{
    @IBOutlet weak var launchImageView: UIImageView!
    
    override func viewDidLoad() {
        self.setupLaunchImageView();
    }
    
    func setupLaunchImageView() {
        var imagesArray : Array <UIImage> = Array()
        
        for i in 0...55 {
            
            let image : UIImage? = UIImage(named: "YAMO_MARK_000" + String(format: "%02d", i))
            
            if let unwrappedImage = image {
                imagesArray.append(unwrappedImage)
            }
        }
        
        self.launchImageView.animationImages = imagesArray
        self.launchImageView.animationDuration = 3.0
        self.launchImageView.animationRepeatCount = 1
        self.launchImageView.startAnimating()
        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(RootViewController.finishedLaunchAnimation(_:)), userInfo: nil, repeats: false)
    }
    
    func finishedLaunchAnimation(timer : NSTimer) {
        timer.invalidate()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.launchImageView.alpha = 0.0
        }
        
        //check autologin
        self.navigationController?.pushViewController(IntroViewController(nibName: "IntroViewController", bundle: nil), animated: true)
        
        
    }
}
