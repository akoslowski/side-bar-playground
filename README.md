# Wayfinder

> wayfinder | ˈweɪfʌɪndə |
>
> noun
>
> a sign, landmark, or other indicator used to assist people in navigating to a particular location: the chimney stacks have been a wayfinder for nearly five decades.
> • a person navigating to a particular location: the wilderness wayfinder should strive to be proficient at both map and compass work.

## Abstract
This project is a playground to find approaches to integrating a "slide-out panel navigation" / "side menu" / "hamburger menu". It is a mixture of SwiftUI and UIKit to show how an integration into an UIKit-based app could work.

## Boundary Conditions

- The view lifecycle events (`viewDidLoad`, `viewDidAppear`, `viewDidDisappear`, and friends) must be kept intact
- The side-menu must be deallocated after dimiss
- The side-menu is supposed to 
    - push new view controllers onto the root navigation controller of the app/tab bar controller
    - push new view controllers onto its own navigation controller
    - be integrated into all root view controllers of a tab bar controller 
    - be accessible via interactive gesture, plus tap on a navigation bar button item

## Provided approach

- A side-bar is presented as a modal user-interface component
- Inspiration taken from the book "iOS Animations by Tutorials"
  - https://github.com/kodecocodes/iat-materials
  - https://github.com/kodecocodes/iat-materials/tree/editions/7.0/25-uiviewpropertyanimator-view-controller-transitions/projects/final
