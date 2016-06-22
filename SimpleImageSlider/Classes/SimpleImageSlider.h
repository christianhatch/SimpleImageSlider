//
//  SimpleImageSlider.h
//  Pods
//
//  Created by Christian Hatch on 5/31/16.
//
//

@import UIKit;

@interface SimpleImageSlider : UIScrollView

/**
 Designated Initializer for images!
 
 @param frame  The frame of the SimpleImageSlider.
 @param images The images to be set on the SimpleImageSlider
 
 @return A new intialized SimpleImageSlider.
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                      images:(nullable NSArray<UIImage *> *)images;

/**
 Designated Initializer for image URLs!
 
 @param frame  The frame of the SimpleImageSlider.
 @param images The urls of the images to be set on the SimpleImageSlider
 
 @return A new intialized SimpleImageSlider.
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                   imageURLs:(nullable NSArray<NSURL *> *)imageURLs;

/**
 *  Designated Initializer for custom views. This is useful for when you have a custom view that you want to laid out in the gallery.
 *
 *  @param frame The frame of the SimpleImageSlider.
 *  @param views The custom views with which to populate the SimpleImageSlider.
 *
 *  @return A new intialized SimpleImageSlider.
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                 customViews:(nullable NSArray<UIView *> *)customViews;

/**
 An array of images used to populate the image scroller. Nil if the SimpleImageSlider was not created with images.
 */
@property (nonatomic, copy, nullable) NSArray<UIImage *> *images;

/**
 An array of imageURLs used to populate the image scroller. Nil if the SimpleImageSlider was not created with imageURLs.
 */
@property (nonatomic, copy, nullable) NSArray<NSURL *> *imageURLs;

/**
 *  The array of custom views used to populate the image scroller. Nil if the SImpleImageSlider was not created with custom views.
 */
@property (nullable, nonatomic, strong) NSArray<UIView *> *customViews;


/**
 *  Adds a parallax effect when scrolling in the scrollview. Use this method to add the effect with a fixed height.
 *
 *  @param scrollView The scrollview to which the parallax effect should be added.
 */
- (void)addParallaxToScrollView:(nonnull UIScrollView *)scrollView height:(CGFloat)height;

/**
 *  Adds a parallax effect when scrolling in the scrollview. Use this method to add the effect with a height based on a given aspect ratio of the scrollview's width, clamped to within a min and max value.
 *
 *  @param scrollView  The scrollview to which the parallax effect should be added.
 *  @param aspectRatio The aspect ratio of the SimpleImageSlider.
 *  @param minHeight   The minimum height that the SimpleImageSlider should be.
 *  @param maxHeight   The maximum height that the SimpleImageSlider should be.
 */
- (void)addParallaxToScrollView:(nonnull UIScrollView *)scrollView aspectRatio:(CGFloat)aspectRatio minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;

/**
 *  If the parallax effect has been added (by calling 'addParallaxToScrollView:') then you must call this method as the scroll view scrolls.
 *
 *  @param scrollView The scrollview that is scrolling, and to which the SimpleImageSlider has been added as a subview and on which 'addParallaxToScrollView:height:' has been called.
 */
- (void)scrollViewScrolled:(nonnull UIScrollView *)scrollView;

@end











