//
//  UIAlertController-LOCBlocks.swift
//  UIAlertController-LOCExtensions
//
//  Created by Hungju Lu on 21/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

public typealias UIAlertControllerPopoverPresentationControllerBlock = ((UIPopoverPresentationController) -> Void)
public typealias UIAlertControllerCompletionBlock = ((UIAlertController, UIAlertAction, Int) -> Void)

internal let UIAlertControllerBlocksCancelButtonIndex = 0;
internal let UIAlertControllerBlocksDestructiveButtonIndex = 1;
internal let UIAlertControllerBlocksFirstOtherButtonIndex = 2;

public extension UIAlertController {
    
    public var visible: Bool {
        return (self.view.superview != nil)
    }
    
    public var cancelButtonIndex: Int {
        return UIAlertControllerBlocksCancelButtonIndex
    }
    
    public var firstOtherButtonIndex: Int {
        return UIAlertControllerBlocksFirstOtherButtonIndex
    }
    
    public var destructiveButtonIndex: Int {
        return UIAlertControllerBlocksDestructiveButtonIndex
    }
    
    public class func show(
        inViewController viewController: UIViewController,
        withTitle title: String?,
        message: String?,
        preferredStyle: UIAlertControllerStyle,
        cancelButtonTitle: String?,
        destructiveButtonTitle: String?,
        otherButtonTitles: [String]?,
        popoverPresentationControllerBlock: UIAlertControllerPopoverPresentationControllerBlock?,
        tapBlock: UIAlertControllerCompletionBlock?) -> UIAlertController {
            let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            if let cancelButtonTitle = cancelButtonTitle {
                controller.addAction(UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: { (action) -> Void in
                    tapBlock?(controller, action, UIAlertControllerBlocksCancelButtonIndex)
                }))
            }
            
            if let destructiveButtonTitle = destructiveButtonTitle {
                controller.addAction(UIAlertAction(title: destructiveButtonTitle, style: .Destructive, handler: { (action) -> Void in
                    tapBlock?(controller, action, UIAlertControllerBlocksDestructiveButtonIndex)
                }))
            }
            
            if let otherButtonTitles = otherButtonTitles {
                for i in 0..<otherButtonTitles.count {
                    let otherButtonTitle = otherButtonTitles[i]
                    
                    controller.addAction(UIAlertAction(title: otherButtonTitle, style: .Default, handler: { (action) -> Void in
                        tapBlock?(controller, action, UIAlertControllerBlocksFirstOtherButtonIndex + i)
                    }))
                }
            }
            
            if let popoverPresentationController = controller.popoverPresentationController {
                popoverPresentationControllerBlock?(popoverPresentationController)
            }
            
            viewController.presentViewController(controller, animated: true, completion: nil)
            
            return controller
    }
    
    public class func showAlert(
        inViewController viewController: UIViewController,
        withTitle title: String?,
        message: String?,
        cancelButtonTitle: String?,
        destructiveButtonTitle: String?,
        otherButtonTitles: [String]?,
        tapBlock: UIAlertControllerCompletionBlock?) -> UIAlertController {
            return self.show(inViewController: viewController,
                withTitle: title,
                message: message,
                preferredStyle: .Alert,
                cancelButtonTitle: cancelButtonTitle,
                destructiveButtonTitle: destructiveButtonTitle,
                otherButtonTitles: otherButtonTitles,
                popoverPresentationControllerBlock: nil,
                tapBlock: tapBlock);
    }
    
    public class func showActionSheet(
        inViewController viewController: UIViewController,
        withTitle title: String?,
        message: String?,
        cancelButtonTitle: String?,
        destructiveButtonTitle: String?,
        otherButtonTitles: [String]?,
        popoverPresentationControllerBlock: UIAlertControllerPopoverPresentationControllerBlock?,
        tapBlock: UIAlertControllerCompletionBlock?) -> UIAlertController {
            return self.show(inViewController: viewController,
                withTitle: title,
                message: message,
                preferredStyle: .ActionSheet,
                cancelButtonTitle: cancelButtonTitle,
                destructiveButtonTitle: destructiveButtonTitle,
                otherButtonTitles: otherButtonTitles,
                popoverPresentationControllerBlock: popoverPresentationControllerBlock,
                tapBlock: tapBlock);
    }
}

