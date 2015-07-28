//
//  PhotoponWelcomeViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/8/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

//#import "PhotoponQueryTableViewController.h"

@interface PhotoponWelcomeViewController : UIViewController <UINavigationControllerDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

- (void)logIn;
- (void)logOut;

- (void) initHUD;
- (void) showHUD;
- (void) showHUDWithStatusText:(NSString*)status;
- (void) showHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode;
- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode;
- (void) hideHud;
- (void) hideHudAfterDelay:(float)delay;
- (void) updateHUDWithStatusText:(NSString*)status;

@end
