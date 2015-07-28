//
//  UIViewController+Photopon.h
//  Photopon
//
//  Created by Brad McEvilly on 9/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UIViewController (Photopon)

- (void) photoponDismissSemiModalSelf;

- (void) photoponDismissSemiModalViewWithController:(UIViewController*)targetController;

@end

