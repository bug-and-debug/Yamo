# LOCPermissions

This component provides a set of handlers for permission requests of the iOS device.

## Requirements

iOS 8.0+

## Installation

LOCPermissions is available from Locassa private repo (Bitbucket), to install it add the Locassa iOS components source to your Podfile

	source 'https://bitbucket.org/locassa/specs'

Then add any or all of the following lines to your Podfile:

    pod 'LOCPermissions/Location'
    pod 'LOCPermissions/Notification'
    pod 'LOCPermissions/Camera'
    pod 'LOCPermissions/Photos'
    pod 'LOCPermissions/CalendarEvents'
    pod 'LOCPermissions/CalendarReminders'
    pod 'LOCPermissions/Contacts'
    pod 'LOCPermissions/Microphone'
    pod 'LOCPermissions/Activities'
    pod 'LOCPermissions/SocialFacebook'
    pod 'LOCPermissions/SocialTwitter'
    pod 'LOCPermissions/Health'

Only add the pod for the permissions you plan on using.  Apple rejects apps that include Healthkit API's but do not use them.

## Usage

To run the example project; clone the repo, then open LOCPermissions.xcodeproj.

The method for asking for each type of permission is virtually identical.  Here are the examples:

**Objective-C**
```
#!objective-c

// Option 1: Ask for permission directly
[[PermissionRequestLocation sharedInstance] requestPermissionInViewController:self
                                                                   completion:
 ^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo) {
     NSLog(@"%ld", (unsigned long)outcome);
 }];

// Option 2: Prompt an alert before the system dialogue
[[PermissionRequestLocation sharedInstance] requestPermissionWithPromptPreAlertInViewController:self
                                                                                     completion:
 ^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo) {
    NSLog(@"%ld", (unsigned long)outcome);
}];

// Option 3: Present a modal view controller before the system dialogue
PermissionsAccessView *view = [PermissionRequest defaultAccessView];
view.titleLabel.text = @"Hey this is a test";
view.messageLabel.text = @"Test";
[[PermissionRequestLocation sharedInstance] requestPermissionWithPromptPresentedView:view
                                                                    inViewController:self
                                                                          completion:
 ^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo)
{
    NSLog(@"Completed");
}];

// Option 4 Use a PermissionRequestViewModel

```
PermissionRequest *request = [PermissionRequest new];

PermissionRequestViewModel *viewModel = [[PermissionRequestViewModel alloc] initWithPermissionRequest:request];

viewModel.title = NSLocalizedString(@"My Title", nil);
viewModel.logo = [UIImage imageNamed:@"MyImage.png"];
PermissionsAccessView *view = [PermissionRequest defaultAccessView];
view.permissionViewModel = viewModel; // Updates UI

```
#!swift

// Option 1: Ask for permission directly
let handler = PermissionRequestLocation.sharedInstance
handler.requestPermission(inViewController: self, completion: { (outcome, userInfo) -> Void in
    print(outcome.rawValue)
})

// Option 2: Prompt an alert before the system dialogue
let handler = PermissionRequestLocation.sharedInstance
handler.requestPermission(promptPreAlertInViewController: self, completion: { (outcome, userInfo) -> Void in
    print(outcome.rawValue)
})

// Option 3: Present a modal view controller before the system dialogue
let handler = PermissionRequestLocation.sharedInstance

let view = PermissionRequest.defaultAccessView()
view.titleLabel.text = "Hey test"
view.messageLabel.text = "Just allow me"

// or you can customise yourself one
// let view = PermissionsAccessView.loadFromNibNamed("MyPermissionsAccessView")

handler.requestPermission(promptPresentedView: view, inViewController: self, completion: { (outcome, userInfo) -> Void in
    print(outcome.rawValue)
})

// Option 4 Use a PermissionRequestViewModel

```
let request = PermissionRequest()
let viewModel = PermissionRequestViewModel(permissionRequest: request)

viewModel.title = NSLocalizedString("My Title", "")
viewModel.logo = UIImage(named: "MyImage.png")
let view = PermissionRequest.defaultAccessView()
view.permissionViewModel = viewModel // Updates UI

```

```