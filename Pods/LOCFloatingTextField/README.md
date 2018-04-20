LOCFloatingTextField
======================

Floating TextField for inputing text

How to Install it
=================
#### Podfile
```ruby
platform :ios, '8.0'
pod "LOCFloatingTextField", :git => "https://bitbucket.org/locassa/locfloatingtextfield"
```

How to use it?
==============

Initialise the floating text field as normal like a normal UITextField. 
When setting the placeholderLabelText property, it will now have a placeholder that animates up (on default).

- Change the placeholderTextColor and the placeholderAnimatedTextColor separately. 
- Change the placeholderTextFont and the placeholderAnimatedTextFont separately. 
- posibility to animate the placeholder upwards or downwards using the "animationType" property

Also the size of the componente can variable in width but the height should be in the interval of [44, 60] - as it was disscussed with the design team. For more then one line the component called LOCTextView should be used instead.

The position of the component will be set using constraints in code as in the example below.


Example:
```
#!objective-c
#import "LOCFloatingTextField.h"
```
```
#!objective-c
@property (nonatomic, strong)  LOCFloatingTextField *firstNameTextField;
```
```
#!objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameTextField = [[LOCFloatingTextField alloc] initWithFrame:CGRectZero];
    self.firstNameTextField.placeholderLabelText = @"First Name";
    self.firstNameTextField.placeholderTextColor = [UIColor cyanColor];
    self.firstNameTextField.placeholderTextFont = [UIFont systemFontOfSize:13.0f];
    self.firstNameTextField.placeholderAnimatedTextColor = [UIColor orangeColor];
    self.firstNameTextField.placeholderAnimatedTextFont = [UIFont boldSystemFontOfSize:13.0f];

    self.firstNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstNameTextField.font = [UIFont fontWithName:@"Avenir" size:13.0f];
    self.firstNameTextField.textColor = [UIColor redColor];
    self.firstNameTextField.returnKeyType = UIReturnKeyNext;
    self.firstNameTextField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.firstNameTextField];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.firstNameTextField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstNameTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.firstNameTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.firstNameTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [self.firstNameTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.firstNameTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0  constant:40]];
}

```
 
Hope you like it!