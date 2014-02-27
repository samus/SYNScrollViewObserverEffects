# SYNParallaxScrollObserver

[![Version](http://cocoapod-badges.herokuapp.com/v/SYNParallaxScrollObserver/badge.png)](http://cocoadocs.org/docsets/SYNParallaxScrollObserver)
[![Platform](http://cocoapod-badges.herokuapp.com/p/SYNParallaxScrollObserver/badge.png)](http://cocoadocs.org/docsets/SYNParallaxScrollObserver)

SYNParallaxScrollObserver is a class that observes the content offset of one scrollview and applies a parallaxed version of the offset to another scrollview.

![Alt text](/Readme_Images/parallaxdemo1.png "Scroll start")
![Alt text](/Readme_Images/parallaxdemo2.png "Scrolling")

Note: This library doesn't apply the blur shown in the screenshots but the example project shows how it can be done.

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

Using in a project can be done with the following code.

``` objc
self.parallaxObserver = [[SYNParallaxScrollObserver alloc] initWithObservedScrollView:self.observed parallaxedScrollView:self.parallaxed];
[self.parallaxObserver startObserving];
```

## Requirements

## Installation

SYNParallaxScrollObserver is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "SYNParallaxScrollObserver"

## Author

Sam Corder, samus@codeargyle.com

## License

SYNParallaxScrollObserver is available under the MIT license. See the LICENSE file for more info.

