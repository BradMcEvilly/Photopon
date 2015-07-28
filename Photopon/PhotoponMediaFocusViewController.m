//
//  PhotoponMediaFocusViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/28/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFocusViewController.h"
#import "PhotoponQueryTableViewController.h"
//#import "ASMediaThumbnailsViewController.h"

@interface PhotoponMediaFocusViewController ()
@property (nonatomic, strong) PhotoponQueryTableViewController *thumbnailsViewController;
@end

@implementation PhotoponMediaFocusViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.thumbnailsViewController = [[PhotoponQueryTableViewController alloc] initWithEntityName:kPhotoponActivityClassKey];
    [self addChildViewController:self.thumbnailsViewController];
    [self.contentView addSubview:self.thumbnailsViewController.view];
    self.thumbnailsViewController.view.frame = self.contentView.bounds;
    self.view.clipsToBounds = NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    // return UIInterfaceOrientationMaskAll;
}
@end
