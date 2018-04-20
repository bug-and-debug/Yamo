//
//  PaywallViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 04/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCSubscription
import UIAlertController_LOCExtensions

enum SubscriptionDuration {
    case OneMonth
    case ThreeMonths
    case OneYear
}

class PaywallViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let paywallCards: [(imageName: String, description: String)] = [
        ("PaywallMap", "Map with relevancy. The spheres representing exhibition on the map will grow in size or decrease in size to show what is relevant to you."),
        ("PaywallNotifications", "Notifications - find out when exhibitions are close to ending, when new exhibitions at your favourite galleries are opening, and updates about your friends using gowithYamo. "),
        ("PaywallRoutePlanner", "Plan multi-exhibition routes with the route planner and save your most used locations such as work and home to easily plan a journey."),
        ("PaywallGetToKnowMe", "Access to ‘Get To Know Me’ section where you can swipe images to save them to your profile and help promote content relevant to your tastes in gowithYamo.")]
    
    private let durationDictionary = ["com.grandapps.yamo.ios.1MonthTier1": SubscriptionDuration.OneMonth,
                                      "com.grandapps.yamo.ios.3MonthsTier3": SubscriptionDuration.ThreeMonths,
                                      "com.grandapps.yamo.ios.1YearTier9": SubscriptionDuration.OneYear]
    
    var currentPageIndex: Int = 0
    
    @IBOutlet weak var tier1Button: UIButton!
    @IBOutlet weak var tier2Button: UIButton!
    @IBOutlet weak var tier3Button: UIButton!
    
    var responseProducts: [AnyObject]?
    var subscriptionProducts: [SKProduct]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(PaywallViewController.handleProductRequestNotification(_:)),
                                                         name: IAPProductRequestNotification,
                                                         object: StoreKitManager.sharedInstance())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributedTitle(NSLocalizedString("Subscribe", comment: ""))
        
        self.scrollView.delegate = self
        
        self.tier1Button.selected = true
        self.tier1Button.hidden = true
        self.tier2Button.hidden = true
        self.tier3Button.hidden = true
        
        self.nextButton.enabled = false
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedString = NSAttributedString(string: NSLocalizedString("Sign Up", comment: ""), attributes: attributes)
        self.nextButton .setAttributedTitle(attributedString, forState: .Normal)
        
        self.fetchProducts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let pageWidth = CGRectGetWidth(self.scrollView.frame)
        let pageHeight = CGRectGetHeight(self.scrollView.frame)
        
        for (index, subview) in self.scrollView.subviews.enumerate() {
            subview.frame = CGRectMake(CGFloat(index) * pageWidth, 0, pageWidth, pageHeight)
        }
    }
    
    // MARK: - View Configuration
    
    private func configureView() {
        self.navigationController?.navigationBar.setNavigationBarStyleOpaque()
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "IcondarkXdisabled"), style: .Plain, target: self, action: #selector(doneButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        for subView in self.scrollView.subviews {
            subView.removeFromSuperview()
        }
        
        let pageWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let pageHeight = CGRectGetHeight(self.scrollView.frame)
        
        self.pageControl.numberOfPages = self.paywallCards.count
        self.currentPageIndex = 0
        
        for card in self.paywallCards {
            
            let view = PaywallFeatureView.loadFromNib()
            self.scrollView.addSubview(view)
            
            let paragraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText).mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .Center
            view.contentLabel.attributedText = NSAttributedString(string: NSLocalizedString(card.description, comment: ""),
                                                                  attributes: [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                                                                    NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                                                                    NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                                                                    NSParagraphStyleAttributeName: paragraphStyle])
            
            view.imageView.image = UIImage(named: card.imageName)
            view.imageView.contentMode = .ScaleAspectFit
        }
        
        self.scrollView.contentSize = CGSizeMake(pageWidth * CGFloat(self.paywallCards.count), pageHeight - 250)
        self.scrollView.contentOffset = CGPointMake(0, 0)
        
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tierButtonPressed(sender: UIButton) {
        sender.selected = true
        
        switch sender {
        case self.tier1Button:
            self.tier2Button.selected = false
            self.tier3Button.selected = false
        case self.tier2Button:
            self.tier1Button.selected = false
            self.tier3Button.selected = false
        case self.tier3Button:
            self.tier1Button.selected = false
            self.tier2Button.selected = false
        default:
            break
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        var selectedProduct: SKProduct?
        if let subscriptionProducts = self.subscriptionProducts {
            if self.tier1Button.selected {
                selectedProduct = subscriptionProducts[0]
            }
            else if self.tier2Button.selected {
                selectedProduct = subscriptionProducts[1]
            }
            else if self.tier3Button.selected {
                selectedProduct = subscriptionProducts[2]
            }
        }
        
        if let selectedSubscription = selectedProduct {
            let authentificationVC = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
            authentificationVC.selectedSubscription = selectedSubscription
            authentificationVC.isPayWallSubscription = true
            self.navigationController?.pushViewController(authentificationVC, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let pageX = CGFloat(self.currentPageIndex) * pageWidth - scrollView.contentInset.left
        
        if targetContentOffset.memory.x < pageX {
            if self.currentPageIndex > 0 {
                self.currentPageIndex -= 1
            }
        } else if targetContentOffset.memory.x > pageX {
            if self.currentPageIndex < self.paywallCards.count - 1 {
                self.currentPageIndex += 1
            }
        }
        
        targetContentOffset.memory.x = CGFloat(self.currentPageIndex) * pageWidth - scrollView.contentInset.left
        
        self.pageControl.currentPage = self.currentPageIndex
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y)
    }
    
    // MARK: Alert helper
    
    func showAlertForTitle(title: String, message: String) {
        
        UIAlertController.showAlert(inViewController: self,
                                    withTitle: title,
                                    message: message,
                                    cancelButtonTitle: NSLocalizedString("OK", comment: "OK button"),
                                    destructiveButtonTitle: nil,
                                    otherButtonTitles: nil,
                                    tapBlock: nil)
    }
    
    // MARK: IAP Helper
    
    func fetchProducts() {
        
        if (SKPaymentQueue.canMakePayments()) {
            
            let productIdsURL = NSBundle.mainBundle().URLForResource("ProductIds", withExtension: "plist")
            if let pListURL = productIdsURL {
                let productIds = NSArray.init(contentsOfURL: pListURL) as! [String]
                
                self.activityIndicatorView.startAnimating()
                StoreKitManager.sharedInstance().fetchProductInformationForIds(productIds)
            }
        }
        else {
            self.showAlertForTitle(NSLocalizedString("Failed to request for products", comment: ""),
                                   message: NSLocalizedString("Purchases are disabled on this device", comment: ""))
        }
    }
    
    func displayLabelForSubscriptionDuration(duration: SubscriptionDuration) -> String {
        
        switch duration {
        case .OneMonth:
            return NSLocalizedString("1 month", comment: "")
        case .ThreeMonths:
            return NSLocalizedString("3 months", comment: "")
        case .OneYear:
            return NSLocalizedString("1 year", comment: "")
        }
    }
    
    func reloadUIForProducts() {
        guard let products = self.responseProducts else {
            
            self.tier1Button.hidden = true
            self.tier2Button.hidden = true
            self.tier3Button.hidden = true
            print("Products not loaded yet or no products")
            self.showAlertForTitle(NSLocalizedString("Error", comment: ""),
                                   message: NSLocalizedString("No products were found", comment: ""))
            return
        }
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        
        let premiumModel: PremiumModel = products.first as! PremiumModel
        let tierButtons: [UIButton] = [self.tier1Button, self.tier2Button, self.tier3Button]
        
        self.subscriptionProducts = (premiumModel.elements as! [SKProduct]).sort({ sortByPrice($0, that: $1) })
        var displayPricesArray: [String] = []
        
        if self.subscriptionProducts!.count >= 3 {
            
            // We assume theres 3 types of subscription product
            for (index, product) in self.subscriptionProducts!.enumerate() {
                
                currencyFormatter.locale = product.priceLocale
                
                let displayPrice = currencyFormatter.stringFromNumber(product.price)
                displayPricesArray.append(displayPrice!)
                
                let subscriptionDuration = self.durationDictionary[product.productIdentifier]
                if let duration = subscriptionDuration {
                    
                    let paragraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText).mutableCopy() as! NSMutableParagraphStyle
                    paragraphStyle.alignment = .Center
                    
                    let attributedPrice = NSAttributedString(string: displayPricesArray[index],
                                                             attributes: [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikMedium, size: 14.0),
                                                                NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                                                                NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                                NSParagraphStyleAttributeName: paragraphStyle])
                    let attributedDuration = NSAttributedString(string: self.displayLabelForSubscriptionDuration(duration),
                                                                attributes: [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                                                                    NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                                                                    NSForegroundColorAttributeName:UIColor.whiteColor(),
                                                                    NSParagraphStyleAttributeName: paragraphStyle])
                    
                    let attributedTitle = NSMutableAttributedString(attributedString: attributedPrice)
                    attributedTitle.appendAttributedString(NSAttributedString(string: "\n"))
                    attributedTitle.appendAttributedString(attributedDuration)
                    
                    tierButtons[index].titleLabel?.lineBreakMode = .ByWordWrapping
                    tierButtons[index].titleLabel?.textAlignment = .Center
                    tierButtons[index].setAttributedTitle(attributedTitle, forState: .Normal)
                }
            }
            
            self.tier1Button.hidden = false
            self.tier2Button.hidden = false
            self.tier3Button.hidden = false
        }
    }
    
    func sortByPrice(this:SKProduct, that:SKProduct) -> Bool {
        return this.price.compare(that.price) == .OrderedAscending
    }
    
    // MARK: Notification
    
    func handleProductRequestNotification(notification: NSNotification) {
        
        self.activityIndicatorView.stopAnimating()
        self.nextButton.enabled = true
        
        let storeKitManager: StoreKitManager = notification.object as! StoreKitManager
        let requestState = storeKitManager.status
        
        switch requestState {
        case .ProductRequestResponse:
            self.responseProducts = storeKitManager.productRequestResponse as [AnyObject]
            self.reloadUIForProducts()
        default:
            let errorMessage = storeKitManager.errorMessage
            let title = NSLocalizedString("Product Request Failed", comment: "IAP error title")
            let message = String(format: NSLocalizedString("There's a problem requesting your product. Please try again. %@", comment: "IAP error message"), errorMessage)
            self.showAlertForTitle(title, message: message)
            break
        }
    }
}
