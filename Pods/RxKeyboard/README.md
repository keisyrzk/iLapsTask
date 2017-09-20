# RxKeyboard

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxKeyboard.svg)](https://cocoapods.org/pods/RxKeyboard)
[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxKeyboard.svg?branch=master)](https://travis-ci.org/RxSwiftCommunity/RxKeyboard)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxKeyboard provides a reactive way of observing keyboard frame changes. Forget about keyboard notifications. It also perfectly works with `UIScrollViewKeyboardDismissMode.interactive`.

![rxkeyboard](https://cloud.githubusercontent.com/assets/931655/19223656/14bd915c-8eb0-11e6-93ea-7618fc9c5d81.gif)

> ▲ Interactive keyboard dismissing in UITextView.

## Getting Started

RxKeyboard provides two [`Driver`](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Units.md#driver-unit)s.

```swift
/// An observable keyboard frame.
let frame: Driver<CGRect>

/// An observable visible height of keyboard. Emits keyboard height if the keyboard is visible
/// or `0` if the keyboard is not visible.
let visibleHeight: Driver<CGFloat>
```

Use `RxKeyboard.instance` to get singleton instance.

```swift
RxKeyboard.instance
```

Subscribe `RxKeyboard.instance.frame` to observe keyboard frame changes.

```swift
RxKeyboard.instance.frame
  .drive(onNext: { frame in
    print(frame)
  })
  .addDisposableTo(disposeBag)
```

## Tips and Tricks

- <a name="tip-content-inset" href="#tip-content-inset">🔗</a> **I want to adjust `UIScrollView`'s `contentInset` to fit keyboard height.**

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        scrollView.contentInset.bottom = keyboardVisibleHeight
      })
      .addDisposableTo(disposeBag)
    ```

- <a name="tip-toolbar" href="#tip-toolbar">🔗</a> **I want to make `UIToolbar` move along with the keyboard in an interactive dismiss mode. (Just like the wonderful GIF above!)**

    If you're not using Auto Layout:

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        toolbar.frame.origin.y = self.view.height - toolbar.frame.height - keyboardVisibleHeight
      })
      .addDisposableTo(disposeBag)
    ```

    If you're using Auto Layout, you have to capture the toolbar's bottom constraint and set `constant` to keyboard visible height.

    ```swift
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        toolbarBottomConstraint.constant = -1 * keyboardVisibleHeight
      })
      .addDisposableTo(disposeBag)
    ```

    > **Note**: In real world, you should use `setNeedsLayout()` and `layoutIfNeeded()` with animation block. See the [demo project](https://github.com/devxoul/RxKeyboard/blob/master/Demo/Sources/ViewControllers/ViewController.swift#L62-L70) for example.

- Anything else? Please open an issue or make a Pull Request.
    
## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) (>= 3.0)
- [RxCocoa](https://github.com/ReactiveX/RxSwift) (>= 3.0)

## Requirements

- Swift 3
- iOS 8+

## Installation

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxKeyboard', '~> 0.3'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxKeyboard" ~> 0.3
    ```

## License

RxKeyboard is under MIT license.
