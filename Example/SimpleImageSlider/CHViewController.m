//
//  CHViewController.m
//  SimpleImageSlider
//
//  Created by Christian Hatch on 5/31/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "CHViewController.h"

@interface CHViewController ()  <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeader];
}

- (void)setupHeader {
    
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
