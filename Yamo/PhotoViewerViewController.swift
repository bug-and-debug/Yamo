//
//  PhotoViewerViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIView_LOCExtensions

class PhotoViewerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var photoURLs: [String]?
    var currentIndex: Int = 0
    
    private var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.navigationController?.navigationBar.setNavigationBarStyleOpaque()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonPressed))
        
        self.view.backgroundColor = UIColor.blackColor()
        self.initializePageViewController()
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Initializer
    
    private func initializePageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        if let firstController = self.getItemController(self.currentIndex) {
            let startingViewControllers = [firstController]
            self.pageViewController.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        }
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.pinView(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    private func getItemController(index: Int) -> UIViewController? {
        guard let photoURLs = self.photoURLs else {
            return nil
        }
        
        let controller = PhotoViewerItemViewController()
        controller.currentItemIndex = index
        controller.photoURL = photoURLs[index]
        
        return controller
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PhotoViewerItemViewController
        
        if itemController.currentItemIndex > 0 {
            return getItemController(itemController.currentItemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PhotoViewerItemViewController
        
        if let photoURLs = self.photoURLs where itemController.currentItemIndex + 1 < photoURLs.count {
            return getItemController(itemController.currentItemIndex + 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let itemController = pendingViewControllers.first as? PhotoViewerItemViewController {
            self.currentIndex = itemController.currentItemIndex
        }
    }
}
