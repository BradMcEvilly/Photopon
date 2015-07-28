//
//  PhotoponSnipsViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 9/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTimelineViewController.h"
#import "PhotoponUploadHeaderView.h"

@interface PhotoponSnipsViewController : PhotoponTimelineViewController <PhotoponUploadHeaderViewDelegate>

@property (nonatomic, strong) PhotoponUploadHeaderView *uploadHeaderView;

- (void) addUploadHeader;

- (void) removeUploadHeaderReload:(BOOL)reload;

@end
