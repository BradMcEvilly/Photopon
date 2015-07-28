//
//  PhotoponHomeViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/8/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTimelineViewController.h"
#import "PhotoponUploadHeaderView.h"

@interface PhotoponHomeViewController : PhotoponTimelineViewController <PhotoponUploadHeaderViewDelegate>

@property (nonatomic, strong) PhotoponUploadHeaderView *uploadHeaderView;

- (void) addUploadHeader;

- (void) removeUploadHeaderReload:(BOOL)reload;

- (void) showShareSheet;

@end
