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
 Designated Initializer!
 
 @param frame  The frame of the ImageSlider.
 @param images The images to be set on the ImageSlider
 
 @return A new intialized ImageSlider
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                      images:(nullable NSArray<UIImage *> *)images;

/**
 Designated Initializer!
 
 @param frame  The frame of the ImageSlider.
 @param images The urls of the images to be set on the ImageSlider
 
 @return A new intialized ImageSlider
 */
+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                   imageURLs:(nullable NSArray<NSURL *> *)imageURLs;

/**
 An array of imageURLs used to populate the image scroller. Nil if the ImageSlider was created with images.
 */
@property (nonatomic, copy, nullable) NSArray *imageURLs;

/**
 An array of images used to populate the image scroller. Nil if the ImageSlider was created with imageURLs.
 */
@property (nonatomic, copy, nullable) NSArray *images;


@end
