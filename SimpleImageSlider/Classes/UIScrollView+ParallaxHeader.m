//
//  UIScrollView+ParallaxHeader.m
//
//  Created by Marek Serafin on 2014-09-18.
//  Copyright (c) 2013 VG. All rights reserved.
//

#import "UIScrollView+ParallaxHeader.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <PureLayout/PureLayout.h>

static char UIScrollViewParallaxHeader;
static void *ParallaxHeaderObserverContext = &ParallaxHeaderObserverContext;

#pragma mark - ParallaxHeader (Interface)
@interface ParallaxHeader ()

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(ParallaxHeaderMode)mode
                            height:(CGFloat)height;

@property (nonatomic, assign, readwrite, getter=isInsideTableView) BOOL insideTableView;

@property (nonatomic, assign, readwrite) ParallaxHeaderMode mode;

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UIView *contentView;

@property (nonatomic, weak, readwrite) UIScrollView *scrollView;

@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalHeight;

@property (nonatomic, readwrite) CGFloat headerHeight;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwarePositionConstraint;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwareSizeConstraint;

@property (nonatomic, assign, readwrite) CGFloat progress;

@property (nonatomic, strong, readwrite) NSArray *stickyViewContraints;

@end

#pragma mark - UIScrollView (Implementation)
@implementation UIScrollView (ParallaxHeader)

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(ParallaxHeaderMode)mode
                       height:(CGFloat)height
                  shadowBehaviour:(ParallaxHeaderShadowBehaviour)shadowBehaviour
{
    [self setParallaxHeaderView:view
                           mode:mode
                         height:height];
}

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(ParallaxHeaderMode)mode
                       height:(CGFloat)height
{
    // New ParallaxHeader
    self.parallaxHeader = [[ParallaxHeader alloc] initWithScrollView:self
                                                           contentView:view
                                                                  mode:mode
                                                                height:height];
    
    self.parallaxHeader.headerHeight = height;
    
    // Calling this to position everything right
    [self shouldPositionParallaxHeader];
    
    // If UIScrollView adjust inset
    if (!self.parallaxHeader.isInsideTableView) {
        UIEdgeInsets selfContentInset = self.contentInset;
        selfContentInset.top += height;
        
        self.contentInset = selfContentInset;
        self.contentOffset = CGPointMake(0, -selfContentInset.top);
    }
    
    // Watch for inset changes
    [self addObserver:self.parallaxHeader
           forKeyPath:NSStringFromSelector(@selector(contentInset))
              options:NSKeyValueObservingOptionNew
              context:ParallaxHeaderObserverContext];
}

- (void)updateParallaxHeaderViewHeight:(CGFloat)height
{
    CGFloat newContentInset = 0;
    UIEdgeInsets selfContentInset = self.contentInset;
    
    if (height < self.parallaxHeader.headerHeight) {
        newContentInset = self.parallaxHeader.headerHeight - height;
        selfContentInset.top -= newContentInset;
    } else {
        newContentInset = height - self.parallaxHeader.headerHeight;
        selfContentInset.top += newContentInset;
    }
    
    self.contentInset = selfContentInset;
    self.contentOffset = CGPointMake(0, -selfContentInset.top);
    
    self.parallaxHeader.headerHeight = height;
    [self.parallaxHeader setNeedsLayout];
}

- (void)shouldPositionParallaxHeader
{
    if(self.parallaxHeader.isInsideTableView) {
        [self positionTableViewParallaxHeader];
    }
    else {
        [self positionScrollViewParallaxHeader];
    }
}

- (void)positionTableViewParallaxHeader
{
    CGFloat scaleProgress = fmaxf(0, (1 - ((self.contentOffset.y + self.parallaxHeader.originalTopInset) / self.parallaxHeader.originalHeight)));
    self.parallaxHeader.progress = scaleProgress;
    
    if (self.contentOffset.y < self.parallaxHeader.originalHeight) {
        // We can move height to if here because its uitableview
        CGFloat height = self.contentOffset.y * -1 + self.parallaxHeader.originalHeight;
        // Im not 100% sure if this will only speed up ParallaxHeaderModeCenter
        // but on other modes it can be visible. 0.5px
        if (self.parallaxHeader.mode == ParallaxHeaderModeCenter) {
            height = round(height);
        }
        // This is where the magic is happening
        self.parallaxHeader.containerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
    }
}

- (void)positionScrollViewParallaxHeader
{
    CGFloat height = self.contentOffset.y * -1;
    CGFloat scaleProgress = fmaxf(0, (height / (self.parallaxHeader.originalHeight + self.parallaxHeader.originalTopInset)));
    self.parallaxHeader.progress = scaleProgress;
    
    if (self.contentOffset.y < 0) {
        // This is where the magic is happening
        self.parallaxHeader.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
    }
}

- (void)setParallaxHeader:(ParallaxHeader *)parallaxHeader
{
    // Remove All Subviews
    if([self.subviews count] > 0) {
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isMemberOfClass:[ParallaxHeader class]]) {
                [obj removeFromSuperview];
            }
        }];
    }
    
    parallaxHeader.insideTableView = [self isKindOfClass:[UITableView class]];
    
    // Add Parallax Header
    if(parallaxHeader.isInsideTableView) {
        [(UITableView*)self setTableHeaderView:parallaxHeader];
        [parallaxHeader setNeedsLayout];
    }
    else {
        [self addSubview:parallaxHeader];
    }
    
    // Set Associated Object
    objc_setAssociatedObject(self, &UIScrollViewParallaxHeader, parallaxHeader, OBJC_ASSOCIATION_ASSIGN);
}

- (ParallaxHeader *)parallaxHeader
{
    return objc_getAssociatedObject(self, &UIScrollViewParallaxHeader);
}

@end

#pragma mark - ParallaxHeader (Implementation)
@implementation ParallaxHeader

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    // FIXME: Init with storyboards not yet supported

    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(ParallaxHeaderMode)mode
                            height:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), height)];
    if (!self) {
        return nil;
    }
    
    self.mode = mode;
    
    self.scrollView = scrollView;
    
    self.originalHeight = height;
    self.originalTopInset = scrollView.contentInset.top;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.clipsToBounds = YES;
    
    if (!self.isInsideTableView) {
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    [self addSubview:self.containerView];
    
    self.contentView = view;
    
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    if(_contentView != nil) {
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView addSubview:_contentView];

    // Constraints
    [self setupContentViewMode];
}

- (void)setupContentViewMode
{
    switch (self.mode) {
        case ParallaxHeaderModeFill:
            [self addContentViewModeFillConstraints];
            break;
        case ParallaxHeaderModeTop:
            [self addContentViewModeTopConstraints];
            break;
        case ParallaxHeaderModeTopFill:
            [self addContentViewModeTopFillConstraints];
            break;
        case ParallaxHeaderModeCenter:
        default:
            [self addContentViewModeCenterConstraints];
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentInset))] && context == ParallaxHeaderObserverContext) {
        UIEdgeInsets edgeInsets = [[change valueForKey:@"new"] UIEdgeInsetsValue];
        
        // If scroll view we need to fix inset (TableView has parallax view in table view header)
        self.originalTopInset = edgeInsets.top - ((!self.isInsideTableView) ? self.originalHeight : 0);
        
        switch (self.mode) {
            case ParallaxHeaderModeFill:
                self.insetAwarePositionConstraint.constant = self.originalTopInset / 2;
                self.insetAwareSizeConstraint.constant = -self.originalTopInset;
                break;
            case ParallaxHeaderModeTop:
                self.insetAwarePositionConstraint.constant = self.originalTopInset;
                break;
            case ParallaxHeaderModeTopFill:
                self.insetAwarePositionConstraint.constant = self.originalTopInset;
                self.insetAwareSizeConstraint.constant = -self.originalTopInset;
                break;
            case ParallaxHeaderModeCenter:
            default:
                self.insetAwarePositionConstraint.constant = self.originalTopInset / 2;
                break;
        }
        
        if(!self.isInsideTableView) {
            self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        }
        
        // Refresh Sticky View Constraints
        [self updateStickyViewConstraints];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        if ([self.superview respondsToSelector:@selector(contentInset)]) {
            [self.superview removeObserver:self
                                forKeyPath:NSStringFromSelector(@selector(contentInset))
                                   context:ParallaxHeaderObserverContext];
        }
    }
}

#pragma mark - ParallaxHeader (Auto Layout)
- (void)addContentViewModeFillConstraints
{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                       withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:0];
    
    self.insetAwarePositionConstraint = [self.contentView autoAlignAxis:ALAxisHorizontal
                                                       toSameAxisOfView:self.containerView
                                                             withOffset:self.originalTopInset/2];
    
    NSLayoutConstraint *constraint = [self.contentView autoSetDimension:ALDimensionHeight
                                                                 toSize:self.originalHeight
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
    constraint.priority = UILayoutPriorityRequired;
    
    self.insetAwareSizeConstraint = [self.contentView autoMatchDimension:ALDimensionHeight
                                                             toDimension:ALDimensionHeight
                                                                  ofView:self.containerView
                                                              withOffset:-self.originalTopInset];
    self.insetAwareSizeConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)addContentViewModeTopConstraints
{
    NSArray *array = [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.originalTopInset, 0, 0, 0)
                                                                excludingEdge:ALEdgeBottom];
    self.insetAwarePositionConstraint = [array firstObject];
    
    [self.contentView autoSetDimension:ALDimensionHeight
                                toSize:self.originalHeight];
}

- (void)addContentViewModeTopFillConstraints
{
    NSArray *array = [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.originalTopInset, 0, 0, 0)
                                                                excludingEdge:ALEdgeBottom];
    self.insetAwarePositionConstraint = [array firstObject];
    
    NSLayoutConstraint *constraint = [self.contentView autoSetDimension:ALDimensionHeight
                                                                 toSize:self.originalHeight
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
    constraint.priority = UILayoutPriorityRequired;
    
    self.insetAwareSizeConstraint = [self.contentView autoMatchDimension:ALDimensionHeight
                                                             toDimension:ALDimensionHeight
                                                                  ofView:self.containerView
                                                              withOffset:-self.originalTopInset];
    self.insetAwareSizeConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)addContentViewModeCenterConstraints
{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                       withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:0];
    [self.contentView autoSetDimension:ALDimensionHeight
                                toSize:self.originalHeight];
    
    self.insetAwarePositionConstraint = [self.contentView autoAlignAxis:ALAxisHorizontal
                                                       toSameAxisOfView:self.containerView
                                                             withOffset:round(self.originalTopInset/2)];
}

#pragma mark - ParallaxHeader (Sticky View)
- (void)setStickyView:(UIView *)stickyView
{
    // Make sure it will work with AutLayout
    stickyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add it to Parallax Header
    [self.containerView insertSubview:stickyView
                         aboveSubview:self.contentView];
    
    // Set Local Var
    _stickyView = stickyView;
    
    // Refresh Constraints
    [self updateStickyViewConstraints];
}

- (void)setStickyView:(UIView *)stickyView withHeight:(CGFloat)height
{
    // Set Sticky View
    [self setStickyView:stickyView];
    
    // Add Height Constraint
    self.stickyViewHeightConstraint = [self.stickyView autoSetDimension:ALDimensionHeight
                                                                 toSize:height];
}

- (void)setStickyViewPosition:(ParallaxHeaderStickyViewPosition)stickyViewPosition
{
    // Set Local Var
    _stickyViewPosition = stickyViewPosition;
    
    // Refresh Constraints
    [self updateStickyViewConstraints];
}

- (void)setStickyViewHeightConstraint:(NSLayoutConstraint *)stickyViewHeightConstraint
{
    // Remove Previous Height Constraint
    if (_stickyViewHeightConstraint != nil) {
        [self.stickyView removeConstraint:_stickyViewHeightConstraint];
    }
    
    // Add Height Constraint
    if ([self.stickyView.superview isEqual:self.containerView]) {
        [self.stickyView addConstraint:stickyViewHeightConstraint];
    }
    
    // Set Local Var
    _stickyViewHeightConstraint = stickyViewHeightConstraint;
}

- (void)updateStickyViewConstraints
{
    // Make sure stickyView is added to Parallax Header
    if ([self.stickyView.superview isEqual:self.containerView]) {
        // Set Edges
        ALEdge nonStickyEdge;
        switch (self.stickyViewPosition) {
            case ParallaxHeaderStickyViewPositionTop:
                nonStickyEdge = ALEdgeBottom;
                break;
            case ParallaxHeaderStickyViewPositionBottom:
            default:
                nonStickyEdge = ALEdgeTop;
                break;
        }
        
        // Remove Previous Constraints
        if (self.stickyViewContraints != nil) {
            [self.stickyView removeConstraints:self.stickyViewContraints];
            [self.containerView removeConstraints:self.stickyViewContraints];
        }
       
        // Add Constraints
        self.stickyViewContraints = [self.stickyView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.originalTopInset, 0, 0, 0)
                                                                              excludingEdge:nonStickyEdge];
    }
}

@end
