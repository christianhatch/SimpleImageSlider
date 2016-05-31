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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeader];
}

- (void)setupHeader {
    NSArray *images = @[[NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_1.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_2.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_3.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_4.jpg"],
                        [NSURL URLWithString:@"https://raw.githubusercontent.com/christianhatch/SimpleImageSlider/master/url_5.jpg"]];
    
    SimpleImageSlider *slider = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) imageURLs:images];
    self.tableView.tableHeaderView = slider;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %li", (long)indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

@end
