//
//  UIScrollView+VKParallaxHeader.m
//
//  Created by Marek Serafin on 2014-09-18.
//  Copyright (c) 2013 VG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ParallaxHeaderMode) {
    ParallaxHeaderModeCenter = 0,
    ParallaxHeaderModeFill,
    ParallaxHeaderModeTop,
    ParallaxHeaderModeTopFill,
};

typedef NS_ENUM(NSInteger, ParallaxHeaderStickyViewPosition) {
    ParallaxHeaderStickyViewPositionBottom = 0,
    ParallaxHeaderStickyViewPositionTop,
};

typedef NS_ENUM(NSInteger, ParallaxHeaderShadowBehaviour) {
    ParallaxHeaderShadowBehaviourHidden = 0,
    ParallaxHeaderShadowBehaviourAppearing,
    ParallaxHeaderShadowBehaviourDisappearing,
    ParallaxHeaderShadowBehaviourAlways,
} __deprecated;

@interface ParallaxHeader : UIView
@property (nonatomic, assign, readonly) ParallaxHeaderMode mode;

@property (nonatomic, assign, readwrite) ParallaxHeaderStickyViewPosition stickyViewPosition;
@property (nonatomic, assign, readwrite) NSLayoutConstraint *stickyViewHeightConstraint;
@property (nonatomic, strong, readwrite) UIView *stickyView;

@property (nonatomic, assign, readonly, getter=isInsideTableView) BOOL insideTableView;
@property (nonatomic, assign, readonly) CGFloat progress;

@property (nonatomic, assign, readonly) ParallaxHeaderShadowBehaviour shadowBehaviour __deprecated;

- (void)setStickyView:(UIView *)stickyView
           withHeight:(CGFloat)height;

@end

@interface UIScrollView (ParallaxHeader)

@property (nonatomic, strong, readonly) ParallaxHeader *parallaxHeader;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(ParallaxHeaderMode)mode
                       height:(CGFloat)height;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(ParallaxHeaderMode)mode
                       height:(CGFloat)height
              shadowBehaviour:(ParallaxHeaderShadowBehaviour)shadowBehaviour __deprecated_msg("Use sticky view instead of shadow");

- (void)updateParallaxHeaderViewHeight:(CGFloat)height;

- (void)shouldPositionParallaxHeader;

@end
