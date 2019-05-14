# ATExpandableButton

An animated interactive button class which supports expanding within the view or performing an animated transition to another view controller.

## Installing

Copy these 3 files to your project
```
ATExpandableButton.swift
CustomTransitionViewController.swift
Animators.swift
```
And that's it!
Check out the demo project for a more thorough look.

## Usage

### Expandable Buttons
1. Create your inner UIView `Class + Nib` and make an instance of it in your view controller just like this 
```
let newView: YourViewClass = .fromNib()
```
2. Create the button using the expandable type init
```
init(frame: CGRect, expandedFrame: CGRect, innerView: UIView, title: String)
```
frame: the button frame in normal state
expandedFrame: the button frame in expanded state
innerView: the view within the expanded button as created in step 1
title: the button title label text

3. Customize and add it as a subview and that's it

Customizable values:
``` swift
  /// Title of the button.
  open var title = "Expandable"
  
  /// Font of the title
  open var titleFont: UIFont?
  
  /// Text color of the title.
  open var titleColor: UIColor = .white
  
  /// Background color for inner View
  open var innerViewBackgroundColor: UIColor = .clear
  
  /// Background color for main button
  open var backGroundColor: UIColor = .blue
  
  /// Image for button icon
  open var iconImage: UIImage?
  
  /// tint color for icon image
  open var iconTint: UIColor = .white
  
  /// Decides if title should relocate to top after expansion or disappear. default is true
  open var keepsTitleWhenExpanded = true
  
  /// Decides if icon should relocate to top after expansion or disappear. default is true
  open var keepsIconWhenExpanded = true
  
  /// Sets the frame of the button in the normal state.
  open var originalFrame: CGRect?
  
  /// Sets the frame of the button in the expanded state.
  open var expandedFrame: CGRect?
  ```
### Transition Buttons
1. Make your destination ViewController and source ViewController subclasses to CustomTransitionViewController instead of UIViewController
2. Use the transition Protocol `ATTransitionButtonDelegate` on the source (first) ViewController to implement its method 
  ``` swift
  func didEndTransitionAnimation(_ button: ATExpandableButton) {
     performSegue(withIdentifier: "toVC2", sender: nil)
  }
  ```
3. Create the button with the transition init 
```
init(frame: CGRect, title: String)
```
then customize it same as the expandable one 
Customizable values:
``` swift
  /// Title of the button.
  open var title = "Expandable"
  
  /// Font of the title
  open var titleFont: UIFont?
  
  /// Text color of the title.
  open var titleColor: UIColor = .white
  
  /// Background color for main button
  open var backGroundColor: UIColor = .blue
  
  /// Image for button icon
  open var iconImage: UIImage?
  
  /// tint color for icon image
  open var iconTint: UIColor = .white
  
  /// Sets the frame of the button in the normal state.
  open var originalFrame: CGRect?

  ```
  then add it as a subview and that's it!
