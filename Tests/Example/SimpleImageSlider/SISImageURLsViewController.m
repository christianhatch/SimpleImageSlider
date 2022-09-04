//
//  SISImageURLsViewController.m
//  ImageSlider
//
//  Created by Christian Hatch on 5/31/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "SISImageURLsViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface SISImageURLsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SISImageURLsViewController

- (void)setupHeader {
    NSArray *images = @[[NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/main/url_1.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/main/url_2.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/main/url_3.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/main/url_4.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/main/url_5.jpg"]];
    
    SimpleImageSlider *slider = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) imageURLs:images];
    self.tableView.tableHeaderView = slider;
}

@end
