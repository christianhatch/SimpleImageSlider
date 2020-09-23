//
//  SISParallaxViewController.m
//  SimpleImageSlider
//
//  Created by Christian Hatch on 6/16/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "SISParallaxViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface SISParallaxViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SimpleImageSlider *header;
@end


@implementation SISParallaxViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTheHeader];
}
    
- (void)setupTheHeader {
    NSArray *images = @[[UIImage imageNamed:@"image1"],
                        [UIImage imageNamed:@"image2"],
                        [UIImage imageNamed:@"image3"],
                        [UIImage imageNamed:@"image4"],
                        [UIImage imageNamed:@"image5"]];
    
    self.header = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) images:images];
    [self.header addParallaxToScrollView:self.tableView height:300];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.header scrollViewScrolled:scrollView];
}

@end
