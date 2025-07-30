# SideBarPlayground

This project is a playground to find a viable solution for integrating a custom side-bar into an iOS app. The UI component is sometimes referenced as “slide-out panel navigation”, "side menu”, and “hamburger menu”.

## Why?

There are many projects on GitHub providing the functionality you’d expect from a side-bar. After reviewing a couple of them, it became apparent that the implementations are not meeting some of our requirements for production-ready iOS applications.

- The side-bar must not be managed using a singleton.
- The view lifecycle events (`viewDidLoad`, `viewDidAppear`, `viewDidDisappear`, etc.) must be kept intact.
- The side-bar must be correctly deallocated after dismissal.
- The integration should be controlled by the view controller setting up the side-bar and the navigation items.
- The side-bar is supposed to: 
    - support fully customizable content, preferably via `SwiftUI` 
    - show destination view controllers onto the root navigation controller of the app/tab bar controller 
    - be accessible via interactive gesture (edge-swipe)
    - be accessible via tap on a navigation bar button item

## How?

Looking into Apple’s developer documentation showed that a good approach is to present a view controller modally and apply a custom transition to achieve the side-bar sliding in from the left.

- https://developer.apple.com/documentation/uikit/uipresentationcontroller
- https://developer.apple.com/documentation/uikit/uipercentdriveninteractivetransition
- https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning
- https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate

Inspiration taken from the book "iOS Animations by Tutorials"
    - https://github.com/kodecocodes/iat-materials/blob/editions/7.0/25-uiviewpropertyanimator-view-controller-transitions/projects/final/LockSearch/PresentTransition.swift
