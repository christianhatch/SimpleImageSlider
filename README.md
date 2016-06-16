# SimpleImageSlider

[![Version](https://img.shields.io/cocoapods/v/SimpleImageSlider.svg?style=flat)](http://cocoapods.org/pods/SimpleImageSlider)
[![License](https://img.shields.io/cocoapods/l/SimpleImageSlider.svg?style=flat)](http://cocoapods.org/pods/SimpleImageSlider)
[![Platform](https://img.shields.io/cocoapods/p/SimpleImageSlider.svg?style=flat)](http://cocoapods.org/pods/SimpleImageSlider)

## Example
![Sample](https://github.com/christianhatch/SimpleImageSlider/blob/master/sample.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

##Usage
SimpleImageSlider can be initialized with an array of NSURL objects that point to images, or with an array of UIImage objects. These will populate the ImageSlider. Check out the examples to see how to instantiate a SimpleImageSlider with images, urls, in code, and via Interface Builder.

###Parallax
To enable the parallax ('stretchy header') feature, call `- (void)addParallaxToScrollView:(nonnull UIScrollView *)scrollView` passing the scrollview (or subclass, such as UICollectionView or UITableView) to which you want to add the SimpleImageSlider. 
You must also call `- (void)scrollViewScrolled:(nonnull UIScrollView *)scrollView` on the SimpleImageSlider when the scrollview scrolls, to update the parallax effect. 

## Requirements

## Installation

SimpleImageSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SimpleImageSlider'
```

## Author

Christian Hatch, christianhatch@gmail.com

## License

ImageSlider is available under the MIT license. See the LICENSE file for more info.
