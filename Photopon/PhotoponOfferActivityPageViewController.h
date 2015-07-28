//
//  PhotoponOfferActivityPageViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 8/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PhotoponOfferActivityPageViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) NSString *photoponStatusText;

@property (nonatomic, strong) IBOutlet UILabel *photoponSwipeLabelLeft;
@property (nonatomic, strong) IBOutlet UILabel *photoponSwipeLabelRight;
@property (nonatomic, strong) IBOutlet UILabel *photoponTapLabel;

@property (nonatomic, strong) NSString *photoponSwipeLabelLeftText;
@property (nonatomic, strong) NSString *photoponSwipeLabelRightText;
@property (nonatomic, strong) NSString *photoponTapLabelText;

@property (nonatomic, strong) IBOutlet UIView *photoponProgressHUDContainer;

- (void) showHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode;

- (void) hideHud;

- (void) hideHudAfterDelay:(float)delay;

@end
