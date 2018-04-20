//
//  EditProfileViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 04/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import AFNetworking
import Mantle

let EditProfileCellIdentifier = "EditProfileCellIdentifier"
let EditProfileTextFieldCellIdentifier = "EditProfileTextFieldCellIdentifier"

@objc public class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
EditProfileTableViewCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var editProfileTableViewBottomConstraint: NSLayoutConstraint!
    
    var selectedIndexPath: NSIndexPath?
    var editProfileItems = [EditProfileViewModel]()
    let dismissTapGestureRecognizer = UITapGestureRecognizer()
    var headerTapGestureRecognizer = UITapGestureRecognizer()
    var userObjectToEdit : EditProfileDTO = EditProfileDTO()
    var includeNewProfileImage : Bool = false
    var firstLoaded : Bool = true
    private var charLimit = 20
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showIndicator(false)
        
        self.headerTapGestureRecognizer.addTarget(self, action: #selector(handleHeaderTapGesture))
        self.dismissTapGestureRecognizer.addTarget(self, action: #selector(handleDismissTapGesture))
        
        self.editProfileTableView.addGestureRecognizer(self.dismissTapGestureRecognizer)
        
        self.dismissTapGestureRecognizer.enabled = false
        self.dismissTapGestureRecognizer.cancelsTouchesInView = false
        
        let header = EditProfileHeaderView(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, 100.0))
        header.addGestureRecognizer(self.headerTapGestureRecognizer)
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoBlack()]
        let attributedString = NSAttributedString(string: NSLocalizedString("Edit profile image", comment: ""), attributes: attributes)
        header.profilePromptLabel.attributedText = attributedString
        
        
        let profileImageURL = (userObjectToEdit.profileImageContent != nil) ? userObjectToEdit.profileImageContent : ""
        
        header.profileImageView.contentMode = .ScaleAspectFill
        header.profileImageView.setImageWithURL(NSURL.init(string: profileImageURL)!, placeholderImage: UIImage.init(named: "profile image 1"))
        self.editProfileTableView.tableHeaderView = header
        self.editProfileTableView.tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, 0.0, 40.0))
        
        self.editProfileTableView.tableFooterView?.backgroundColor = UIColor.whiteColor()
        
        self.editProfileTableView.registerNib(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: EditProfileCellIdentifier)
        self.editProfileTableView.registerNib(UINib(nibName: "EditProfileTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: EditProfileTextFieldCellIdentifier)
        
        self.editProfileTableView.rowHeight = UITableViewAutomaticDimension
        self.editProfileTableView.separatorInset = UIEdgeInsetsZero
        self.editProfileTableView.layoutMargins = UIEdgeInsetsZero
        
        self.setAttributedTitle(NSLocalizedString("Edit Profile", comment: ""))
        self.edgesForExtendedLayout = .None
        
        let nickName = EditProfileTextItem(title: NSLocalizedString("Nickname", comment: ""), currentValue: self.userObjectToEdit.nickname)
        
        nickName.canBeToggled = true
        
        let nickNameViewModel = EditProfileViewModel(editProfileItem: nickName, profileContext: .Nickname)
        nickNameViewModel.expanded = self.userObjectToEdit.nickNameEnabled
        nickNameViewModel.toggleState = self.userObjectToEdit.nickNameEnabled
        
        let firstName = EditProfileTextItem(title: NSLocalizedString("First name", comment: ""), currentValue: self.userObjectToEdit.firstName)
        
        let firstNameViewModel = EditProfileViewModel(editProfileItem: firstName,profileContext: .FirstName)
        
        let lastName = EditProfileTextItem(title: NSLocalizedString("Last name", comment: ""), currentValue: self.userObjectToEdit.lastName)
        
        let lastNameViewModel = EditProfileViewModel(editProfileItem: lastName,profileContext: .LastName)
        
        let city = EditProfileTextItem(title: NSLocalizedString("City", comment: ""), currentValue: self.userObjectToEdit.city )
        
        let cityViewModel = EditProfileViewModel(editProfileItem: city,profileContext: .None)
        
        let privateAccount = EditProfileItem(title: NSLocalizedString("Private Account", comment: "lorem ipsum"))
        
        privateAccount.canBeToggled = true
        
        let privateAccountViewModel = EditProfileViewModel(editProfileItem: privateAccount, profileContext: .None)
        privateAccountViewModel.canExpand = false
        privateAccountViewModel.toggleState = !self.userObjectToEdit.visible
        
        self.editProfileItems = [nickNameViewModel, firstNameViewModel, lastNameViewModel, cityViewModel, privateAccountViewModel]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "IcondarkXdisabled"), style: .Plain, target: self, action: #selector(handleCancelButtonTap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icondarktickdisabled"), style: .Plain, target: self, action: #selector(handleSaveButtonTap))
        self.navigationController?.navigationBar.setNavigationBarStyleOpaque()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.editProfileTableView.reloadData()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Actions
    
    func handleCancelButtonTap() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleSaveButtonTap() {
        
        self.showIndicator(true)
        
        if self.userObjectToEdit.nickNameEnabled {
            
            if let nickname = self.userObjectToEdit.nickname {
                
                self.userObjectToEdit.nickNameEnabled = nickname.characters.count > 0
            }
        }
        
        var newProfileImage = UIImage()
        
        if includeNewProfileImage == true {
            if let header = self.editProfileTableView.tableHeaderView as? EditProfileHeaderView {
                newProfileImage = header.profileImageView.image!
            }
            let data = UIImageJPEGRepresentation(newProfileImage, 0.7)
            let encodedDataString : String = (data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
            
            self.userObjectToEdit.profileImageContent = encodedDataString
        } else {
            self.userObjectToEdit.profileImageContent = ""
        }
        
        let parametrs : NSDictionary = try! MTLJSONAdapter.JSONDictionaryFromModel(self.userObjectToEdit)
        
        APIClient.sharedInstance().editUserProfileWithEditedObject(parametrs as [NSObject : AnyObject], successBlock: { (element) in
            
            self.showIndicator(false)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }) { (Error, integerV, stringV) in
            
            self.showIndicator(false)
            print("failed with error \(Error.description) code \(integerV)")
            self.dismissViewControllerAnimated(true, completion: nil)            
        }
    }
    
    
    func handleHeaderTapGesture() {
        
        self.showMediaSourceActionSheet(nil)
    }
    
    
    func handleDismissTapGesture() {
        
        if let indexPath = self.editProfileTableView.indexPathForSelectedRow {
            
            if let cell = self.editProfileTableView.cellForRowAtIndexPath(indexPath) as? EditProfileTextFieldTableViewCell {
                
                cell.textField.resignFirstResponder()
            }
        }
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {
            
            print("Keyboard frame changed but no user info provided.")
            return
        }
        
        if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            
            if keyboardFrame.origin.y < self.view.bounds.size.height {
                self.dismissTapGestureRecognizer.enabled = true
                
                self.editProfileTableViewBottomConstraint.constant = keyboardFrame.size.height
            }
            else {
                
                self.dismissTapGestureRecognizer.enabled = false
                self.editProfileTableViewBottomConstraint.constant = 0.0
            }
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Table view data source
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.editProfileItems.count
    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let viewModel = self.editProfileItems[indexPath.row]
        let item = viewModel.editProfileItem
        
        var cell: UITableViewCell?
        
        if item is EditProfileTextItem {
            
            cell = tableView.dequeueReusableCellWithIdentifier(EditProfileTextFieldCellIdentifier, forIndexPath: indexPath) as? EditProfileTextFieldTableViewCell
            
            if let textFieldCell = cell as? EditProfileTextFieldTableViewCell {
                
                switch viewModel.profileContext {
                case .Nickname:
                    if viewModel.expanded {
                        textFieldCell.textField.text = userObjectToEdit.nickname
                    }
                    break
                case .FirstName:
                    textFieldCell.textField.text = userObjectToEdit.firstName
                    break
                case .LastName:
                    textFieldCell.textField.text = userObjectToEdit.lastName
                    break
                    
                case .City:
                    textFieldCell.textField.text = userObjectToEdit.city
                    break
                //
                default:
                    textFieldCell.textField.text = "default cell"
                }
                
                textFieldCell.textField.tag = indexPath.row
                textFieldCell.textField.delegate = self
            }
        }
        else {
            
            cell = tableView.dequeueReusableCellWithIdentifier(EditProfileCellIdentifier, forIndexPath: indexPath) as? EditProfileTableViewCell
        }
        
        if cell is EditProfileTableViewCell {
            
            let editProfileCell = cell as! EditProfileTableViewCell
            
            editProfileCell.delegate = self
            editProfileCell.updateWithModel(viewModel)
            editProfileCell.separatorInset = UIEdgeInsetsZero
            editProfileCell.layoutMargins = UIEdgeInsetsZero
            
        }
      
        return cell!
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath == self.selectedIndexPath {
            
            return 88.0
        }
        
        return 44.0
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func showMediaSourceActionSheet(mediaTypes: [String]?) {
        
        let imagePickerController = UIImagePickerController()
        
        if let navigationController = self.navigationController {
            
            imagePickerController.navigationBar.barStyle = navigationController.navigationBar.barStyle
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .ActionSheet)
        
        let photoAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .Default) { [weak self] (action) in
            
            imagePickerController.sourceType = .PhotoLibrary
            
            self?.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        alertController.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .Default) { [weak self] (action) in
            
            imagePickerController.sourceType = .Camera
            
            self?.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        alertController.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        imagePickerController.delegate = self
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: EditProfileTableViewCellDelegate
    
    func cellDidUpdate(cell: EditProfileTableViewCell) {
        
        if let indexPath = self.editProfileTableView.indexPathForCell(cell) {
            
            let viewModel = self.editProfileItems[indexPath.row]
            
            switch indexPath.row {
            case 0:
                
                userObjectToEdit.nickNameEnabled = !userObjectToEdit.nickNameEnabled;
            
                break
            case 4:
                userObjectToEdit.visible = !userObjectToEdit.visible
                viewModel.toggleState = !viewModel.toggleState
                break
            default:
                break
            }
            
            if (viewModel.canExpand) {
                
                viewModel.expanded = cell.toggleSwitch.on
                viewModel.toggleState = !viewModel.toggleState
                
                if firstLoaded {
                    [UIView .performWithoutAnimation({
                        self.editProfileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    })]
                    firstLoaded = false
                }
                
                self.editProfileTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)


            }
        }
        
    }
    
    // MARK: UITextFieldDelegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        
        for cell in self.editProfileTableView.visibleCells {
            
            if let textFieldCell = cell as? EditProfileTextFieldTableViewCell {
                
                if textFieldCell.textField === textField {
                    
                    let indexPath = self.editProfileTableView.indexPathForCell(textFieldCell)
                    
                    self.editProfileTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                    
                    tableView(self.editProfileTableView, didSelectRowAtIndexPath: indexPath!)
                }
            }
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let output = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
    
        let outputString = output as NSString
        
        if outputString.length > charLimit {
            return false
        }
        
        switch textField.tag {
        case 0:
            userObjectToEdit.nickname = output;
            break
        case 1:
            userObjectToEdit.firstName = output;
            break
        case 2:
            userObjectToEdit.lastName = output;
            break
        case 3:
            userObjectToEdit.city = output;
            break
        default:
            break
        }
        return true
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let header = self.editProfileTableView.tableHeaderView as? EditProfileHeaderView, let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            
            header.profileImageView.image = image
            includeNewProfileImage = true
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
