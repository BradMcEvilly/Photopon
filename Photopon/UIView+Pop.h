//
//  UIView+Pop.h
//  Photopon
//
//  Created by Brad McEvilly on 7/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "easing.h"

@interface UIView (Pop)

@property(nonatomic, assign) AHEasingFunction easingFunction;
@property(nonatomic, strong) UIView *boid;

@property(nonatomic, assign) CGRect gridBounds;

- (void)popOpen:(float)popFactor;

- (void)popClose:(float)popFactor;

- (void)popClose:(float)popFactor target:(id)target;

- (void)popOpen:(float)popFactor target:(id)target;

@end
