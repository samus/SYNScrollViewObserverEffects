# SYNScrollViewObserverEffects

[![Version](http://cocoapod-badges.herokuapp.com/v/SYNScrollViewObserverEffects/badge.png)](http://cocoadocs.org/docsets/SYNScrollViewObserverEffects)
[![Platform](http://cocoapod-badges.herokuapp.com/p/SYNScrollViewObserverEffects/badge.png)](http://cocoadocs.org/docsets/SYNScrollViewObserverEffects)

SYNScrollViewObserverEffects is a set of classes that observe the content offset of one scrollview and generate different effects.  The primary goal was to be unobtrussive and able to react to changes in a scroll view without having to be the delegate.  Effects included:

1. Parallax scrolling to show depth of UI.
1. Enlarge a view when the scrollview is pulled down too far.
1. An image blur of a UIImageView image.
1. An effect to show and hide the a Navigation bar based on scrolling.

![Alt text](/Readme_Images/parallaxdemo1.png "Scroll start")
![Alt text](/Readme_Images/parallaxdemo2.png "Scrolling")

Note: The blur effect in this library is requires iOS 7+.  All else should work with at least iOS 6.

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

Using in a project can be done with the following code.

``` objc
self.parallaxObserver = [[SYNParallaxScrollObserver alloc] initWithObservedScrollView:self.observed parallaxedScrollView:self.parallaxed];
[self.parallaxObserver startObserving];
```

## Requirements
To use all of the effects iOS 7 is required.
## Installation

SYNParallaxScrollObserver is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "SYNScrollViewObserverEffects"

## Author

Sam Corder, sam.corder@gmail.com [@SamCorder](http://twitter.com/samcorder)

## License

SYNScrollViewObserverEffects is available under the MIT license. See the LICENSE file for more info.
