//
//  SimpleImageSlider.h
//  Pods
//
//  Created by Christian Hatch on 5/31/16.
//
//

@import UIKit;

@interface SimpleImageSlider : UIScrollView

#pragma mark - Initializers

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
 @param imageURLs The urls of the images to be set on the SimpleImageSlider
 
 @return A new intialized SimpleImageSlider.
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                   imageURLs:(nullable NSArray<NSURL *> *)imageURLs;

/**
 *  Designated Initializer for custom views. This is useful for when you have a custom view that you want to laid out in the gallery.
 *
 *  @param frame The frame of the SimpleImageSlider.
 *  @param customViews The custom views with which to populate the SimpleImageSlider.
 *
 *  @return A new intialized SimpleImageSlider.
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                 customViews:(nullable NSArray<UIView *> *)customViews;

/**
 Determines whether or not the SimpleImageSlider shows page indicators.
 */

@property (nonatomic) BOOL showsPageIndicators;

/**
 The index of the current photo being displayed.
 */
@property (nonatomic) NSInteger currentPageIndex;

/**
 *  Scrolls to the given page index.
 *
 *  @param page The index of the image to scroll to.
 *
 */
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

#pragma mark - Data properties

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

#pragma mark - Slideshow

/**
 *  Automatically scrolls the SimpleImageSlider to the next page every [time] seconds. This method is great for when you need a slideshow, and for when you want to give the user an indication that the SimpleImageSlider is scrollable.
 *
 *  @param time The amount of time to wait before scrolling to the next image.
 */
- (void)startSlideshowWithTime:(NSTimeInterval)time;

/**
 *  Stops the automatic scrolling slideshow.
 */
- (void)stopSlideShow;

/**
 If set to YES, the SimpleImageSlider will stop the automatic scrolling slideshow (if it is running) when the user scrolls the SimpleImageSlider. Useful for when you are using the slideshow feature as an indication that the SimpleImageSlider is scrollable. Set to NO to only stop the slideshow when calling - (void)stopSlideShow;
    Default is YES.
 */
@property (nonatomic) BOOL stopsSlideShowOnScroll;

@end
