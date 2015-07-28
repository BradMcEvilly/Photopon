//
//  UIView+Photopon.h
//  Photopon
//
//  Created by Brad McEvilly on 8/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Photopon)

- (void) dismiss;

- (void) present;

- (void)fadeIn;

- (void)fadeOut;

- (void)fadeInView:(UIView*)targetView;
- (void)fadeOutView:(UIView*)targetView;


@end
