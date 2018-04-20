# LOCSearchBar

This is a quick subclass from the UITextField which provides a left view for the search bar icon, and a customisable placeholder text.

## Requirements

iOS 8.0+

## Installation

Add the following line to your Podfile:

    pod 'LOCSearchBar', :git => 'https://bitbucket.org/locassa/locsearchbar.git'

## Usage

To run the example project; clone the repo, then open LOCSearchBar.xcodeproj.

Assign the custom class `LOCSearchTextField` to your storyboard or xib file.

You can customise the search text field:


```
#!Swift
self.customisedTextField.placeholder = "Test Search Bar"
self.customisedTextField.placeholderColour = UIColor.darkGrayColor()
self.customisedTextField.placeholderFont = UIFont.italicSystemFontOfSize(21.0)
self.customisedTextField.font = UIFont.systemFontOfSize(21.0)
self.customisedTextField.accessoryImage = UIImage(named: "search")
self.customisedTextField.accessoryImagePosition = .Right

```