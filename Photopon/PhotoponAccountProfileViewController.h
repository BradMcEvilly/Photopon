//
//  PhotoponAccountProfileViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTimelineViewController.h"
#import "ASMediaFocusManager.h"
#import "PhotoponProfileHeaderView.h"

@class PhotoponUserModel;

@interface PhotoponAccountProfileViewController : PhotoponTimelineViewController <ASMediasFocusDelegate, PhotoponProfileHeaderViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) PhotoponUserModel *user;

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;

@end
