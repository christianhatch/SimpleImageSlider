//
//  CHImagesViewController.m
//  ImageSlider
//
//  Created by Christian Hatch on 5/31/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "CHImagesViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface CHImagesViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation CHImagesViewController

- (void)setupHeader {
    NSArray *images = @[[UIImage imageNamed:@"image1"],
                        [UIImage imageNamed:@"image2"],
                        [UIImage imageNamed:@"image3"],
                        [UIImage imageNamed:@"image4"],
                        [UIImage imageNamed:@"image5"]];
  
    NSMutableArray *views = [NSMutableArray array];
    for (UIImage *image in images) {
        [views addObject:[[UIImageView alloc] initWithImage:image]];
    }
    
    SimpleImageSlider *slider = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) customViews:views];
    self.tableView.tableHeaderView = slider;
    slider.showsPageIndicators = false;
    [slider startSlideshowWithTime:3];
}

@end












