//
//  SISInterfaceBuilderViewController.m
//  SimpleImageSlider
//
//  Created by Christian Hatch on 5/31/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "SISInterfaceBuilderViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface SISInterfaceBuilderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SimpleImageSlider *imageSlider;
@end

@implementation SISInterfaceBuilderViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupTheHeader];
}

- (void)setupTheHeader {
    NSArray *images = @[[UIImage imageNamed:@"image1"],
                        [UIImage imageNamed:@"image2"],
                        [UIImage imageNamed:@"image3"],
                        [UIImage imageNamed:@"image4"],
                        [UIImage imageNamed:@"image5"]];
    
    self.imageSlider.images = images;
}

@end
