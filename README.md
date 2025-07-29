# SideBarPlayground

This project is a playground to find approaches to integrating a custom side-bar, a.k.a. "slide-out panel navigation" / "side menu" / "hamburger menu". It is a mixture of SwiftUI and UIKit to show how an integration into an UIKit-based app could work.

## Boundary Conditions

- The view lifecycle events (`viewDidLoad`, `viewDidAppear`, `viewDidDisappear`, etc.) must be kept intact
- The side-bar must be deallocated after dimiss
- The side-bar is supposed to 
    - push new view controllers onto the root navigation controller of the app/tab bar controller 
    - be accessible via interactive gesture, plus tap on a navigation bar button item

## Provided approach

- A side-bar is presented as a modal user-interface component
- Inspiration taken from the book "iOS Animations by Tutorials"
  - https://github.com/kodecocodes/iat-materials
  - https://github.com/kodecocodes/iat-materials/tree/editions/7.0/25-uiviewpropertyanimator-view-controller-transitions/projects/final
