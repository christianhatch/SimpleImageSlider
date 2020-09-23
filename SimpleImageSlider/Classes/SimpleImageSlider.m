//
//  SimpleImageSlider.m
//  Pods
//
//  Created by Christian Hatch on 5/31/16.
//
//

#import "SimpleImageSlider.h"
#import "UIScrollView+ParallaxHeader.h"

const CGFloat ImageOffset = 0;

@interface UIImageView (SimpleImageSlider)
- (void)setImageAnimated:(UIImage *)image;
- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;
@end

@interface SimpleImageSlider () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *slideshowTimer;
@end

@implementation SimpleImageSlider

#pragma mark - Initialization

+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                           imageURLs:(NSArray *)imageURLs
{
    SimpleImageSlider *slider = [[SimpleImageSlider alloc] initWithFrame:frame];
    slider.imageURLs = imageURLs;
    return slider;
}

+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                              images:(NSArray<UIImage *> *)images
{
    SimpleImageSlider *slider = [[SimpleImageSlider alloc] initWithFrame:frame];
    slider.images = images;
    return slider;
}

+ (nonnull instancetype)imageSliderWithFrame:(CGRect)frame
                                 customViews:(nullable NSArray<UIView *> *)customViews;
{
    SimpleImageSlider *slider = [[SimpleImageSlider alloc] initWithFrame:frame];
    slider.customViews = customViews;
    return slider;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.stopsSlideShowOnScroll = YES;
    self.showsPageIndicators = YES;
}

#pragma mark - Main Method

- (void)render
{
    //bail if we don't have any data
    if ([self proxyData] == nil) {
        return;
    }

    //first clear out all extant imageviews
    if (self.subviews.count > 0) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    
    //get sizes
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
        //iterate through the imageobjects and create an imageview
    for (int i = 0; i < [self proxyData].count; i++) {
        //create frame size & position
        CGRect imageSize = CGRectMake(i * width + ImageOffset,
                                      0,
                                      width - ImageOffset - ImageOffset,
                                      height);
        
        if ([self proxyData] == self.customViews) {
            UIView *view = self.customViews[i];
            view.frame = imageSize;
            view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            view.clipsToBounds = YES;
            [self addSubview:view];
        } else {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:imageSize];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.83 alpha:1];
            imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self addSubview:imgView];
            
            if ([self proxyData] == self.images) {
                //get image
                UIImage *image = self.images[i];
                [imgView setImageAnimated:image];
            }
            else if ([self proxyData] == self.imageURLs) {
                //get imageurl
                NSURL *imageURL = self.imageURLs[i];
                [imgView setImageAnimatedWithURL:imageURL placeholder:nil];
            }
        }
    }
    
    CGFloat sizeWidth = ([self proxyData].count * width) + (ImageOffset * [self proxyData].count) - ImageOffset;
    self.contentSize = CGSizeMake(sizeWidth, height);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        //find the new 'current page' and set it on the pageControl
        CGFloat pageWidth = self.frame.size.width;
        NSUInteger page = floor((self.contentOffset.x - (pageWidth + ImageOffset) / 2.0f) / (pageWidth + ImageOffset)) + 1;
        self.pageControl.currentPage = page;
        
        //resize the pageControl
        CGFloat height = 30;
        CGFloat width = self.frame.size.width;
        CGRect pageControlRect = CGRectMake(scrollView.contentOffset.x,
                                            5,
                                            width,
                                            height);
        
        self.pageControl.frame = pageControlRect;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.stopsSlideShowOnScroll) {
        [self stopSlideShow];
    }
}

- (void)changePage:(UIPageControl *)pageControl
{
    CGRect imagesFrame = self.frame;
    imagesFrame.origin.x = imagesFrame.size.width * pageControl.currentPage;
    imagesFrame.origin.y = 0;
    [self scrollRectToVisible:imagesFrame animated:YES];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    CGRect imagesFrame = self.frame;
    imagesFrame.origin.x = imagesFrame.size.width * page;
    imagesFrame.origin.y = 0;
    [self scrollRectToVisible:imagesFrame animated:animated];
}

#pragma mark - Setters

- (void)setImageURLs:(NSArray *)imageURLs
{
    if (_imageURLs != imageURLs) {
        _imageURLs = imageURLs;
        
        [self render];
        [self setupPageControl];
    }
}

- (void)setImages:(NSArray *)images
{
    if (_images != images) {
        _images = images;
        
        [self render];
        [self setupPageControl];
    }
}

- (void)setCustomViews:(NSArray<UIView *> *)customViews
{
    if (_customViews != customViews) {
        _customViews = customViews;
        
        [self render];
        [self setupPageControl];
    }
}

- (void)setShowsPageIndicators:(BOOL)showsPageIndicators
{
    if (_showsPageIndicators != showsPageIndicators) {
        _showsPageIndicators = showsPageIndicators;
        [self setupPageControl];
    }
}

#pragma mark - Getters

- (NSArray *)proxyData
{
    if (self.images != nil) {
        return self.images;
    }
    if (self.imageURLs != nil) {
        return self.imageURLs;
    }
    if (self.customViews != nil) {
        return self.customViews;
    }
    return nil;
}

- (NSInteger)currentPageIndex {
    return self.pageControl.currentPage;
}

#pragma mark - Private Methods

- (void)setupPageControl
{
    [self.pageControl removeFromSuperview];
    
    if (self.showsPageIndicators) {
        CGFloat height = 30;
        CGFloat width = self.frame.size.width;
        CGRect pageControlRect = CGRectMake(0,
                                            5,
                                            width,
                                            height);
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlRect];
        self.pageControl.numberOfPages = [self proxyData].count;
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        
        [self.pageControl removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
    }
}

#pragma mark - Parallax

- (void)addParallaxToScrollView:(nonnull UIScrollView *)scrollView height:(CGFloat)height;
{
    [scrollView setParallaxHeaderView:self
                                 mode:ParallaxHeaderModeTopFill
                               height:height];
}

- (void)scrollViewScrolled:(UIScrollView *)scrollView;
{
    [scrollView shouldPositionParallaxHeader];
}

#pragma mark - Slideshow

- (void)startSlideshowWithTime:(NSTimeInterval)time;
{
    self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

- (void)scrollToNextPage
{
    NSInteger nextPage = self.pageControl.currentPage + 1;
    if (self.pageControl.currentPage == [self proxyData].count - 1) {
        nextPage = 0;
    }
    [self scrollToPage:nextPage animated:YES];
}

- (void)stopSlideShow;
{
    [self.slideshowTimer invalidate];
    self.slideshowTimer = nil;
}

@end

@implementation UIImageView (SimpleImageSlider)

- (void)setImageAnimated:(UIImage *)image
{
    [UIView transitionWithView:self
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        self.image = image;
                                    });
                                }
                    completion:nil];
}

- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;
{
    __block UIImageView *weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Failed to load image for url: %@, error: %@", request.URL.absoluteString, error);
            [weakSelf setImageAnimated:placeholder];
            return;
        }
        
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSLog(@"Not an NSHTTPURLResponse from %@", request.URL.absoluteString);
            [weakSelf setImageAnimated:placeholder];
            return;
        }
        
        NSHTTPURLResponse *httpResponse = ((NSHTTPURLResponse *)response);
        
        if (httpResponse.statusCode != 200) {
            NSLog(@"Bad response status code: %li while loading url %@", (long)httpResponse.statusCode, request.URL.absoluteString);
            [weakSelf setImageAnimated:placeholder];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf setImageAnimated:[UIImage imageWithData:data]];
        });
    }] resume];
}

@end
