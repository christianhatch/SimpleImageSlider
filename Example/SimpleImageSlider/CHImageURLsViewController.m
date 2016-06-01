//
//  CHImageURLsViewController.m
//  ImageSlider
//
//  Created by Christian Hatch on 5/31/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "CHImageURLsViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface CHImageURLsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation CHImageURLsViewController


- (void)setupHeader {
    NSArray *images = @[[NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_1.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_2.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_3.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_4.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_5.jpg"]];
    
    SimpleImageSlider *slider = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) imageURLs:images];
    self.tableView.tableHeaderView = slider;
}


@end
