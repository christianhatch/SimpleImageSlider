//
//  CHCollectionViewController.m
//  SimpleImageSlider
//
//  Created by Christian Hatch on 6/16/16.
//  Copyright © 2016 Christian Hatch. All rights reserved.
//

#import "CHCollectionViewController.h"
#import <SimpleImageSlider/SimpleImageSlider.h>

@interface CHCollectionViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) SimpleImageSlider *header;
@end

@implementation CHCollectionViewController

static NSString * const reuseIdentifier = @"UICollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self setupHeader];
}

- (void)setupHeader {
    NSArray *images = @[[UIImage imageNamed:@"image1"],
                        [UIImage imageNamed:@"image2"],
                        [UIImage imageNamed:@"image3"],
                        [UIImage imageNamed:@"image4"],
                        [UIImage imageNamed:@"image5"]];
    
    self.header = [SimpleImageSlider imageSliderWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) images:images];
    [self.header addParallaxToScrollView:self.collectionView height:300];
    
    [self.header startSlideshowWithTime:5];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.header scrollViewScrolled:scrollView];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor lightGrayColor];

    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.text = [NSString stringWithFormat:@"%li, %li", (long)indexPath.section, (long)indexPath.row];
    [cell.contentView addSubview:label];
    
    return cell;
}

@end










