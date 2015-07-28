//
//  UIView+Pop.m
//  Photopon
//
//  Created by Brad McEvilly on 7/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIView+Pop.h"
#import <QuartzCore/QuartzCore.h>
#import "CAKeyframeAnimation+AHEasing.h"

#define NUM_VIEW_POP_FACTORS 22

@implementation UIView (Pop)

@dynamic easingFunction;

- (void)popOpen:(float)popFactor
{
    [self setAlpha:1.0f];
    
    CGFloat midHeight = self.frame.size.height / popFactor;
    CGFloat midWidth = self.frame.size.width / popFactor;
    CGSize startSize = CGSizeMake(midWidth, midHeight);
    CGSize targetSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    CALayer *layer= self.layer;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:1.00] forKey:kCATransactionAnimationDuration];
    
    CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"poppingOpen"
                                                          function:ElasticEaseOut fromSize:startSize toSize:targetSize];
    
    [chase setDelegate:self];
    [layer addAnimation:chase forKey:@"poppingOpen"];
    
    [CATransaction commit];
    
}

- (void)popClose:(float)popFactor
{
    CGFloat midHeight = self.frame.size.height / popFactor;
    CGFloat midWidth = self.frame.size.width / popFactor;
    CGSize startSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGSize targetSize = CGSizeMake(midWidth, midHeight);
    
    CALayer *layer= self.layer;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:1.00] forKey:kCATransactionAnimationDuration];
    
    CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"poppingClosed"
                                                          function:BackEaseIn fromSize:startSize toSize:targetSize];
    
    [chase setDelegate:self];
    [layer addAnimation:chase forKey:@"poppingClosed"];
    
    [CATransaction commit];
    
    [self setAlpha:0.0f];
}

- (void)popOpen:(float)popFactor target:(id)target
{
    /*
    //[self setAlpha:1.0f];
    self.gridBounds = CGRectMake(-1.3, -0.4, 3.6, 1.8);
    
    CGFloat midHeight = self.frame.size.height * popFactor;
    CGFloat midWidth = self.frame.size.width * popFactor;
    
    CGSize startSize = CGSizeMake(midWidth, midHeight);
    CGSize targetSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    self.boid = [[UIView alloc] initWithFrame:CGRectMake(140.0f, 140.0f, 140.0f, 140.0f)];
    
    CALayer *layer= self.layer;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:1.00] forKey:kCATransactionAnimationDuration];
    
    CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"poppingOpen"
                                                          function:ElasticEaseOut fromSize:self.boid.frame.size toSize:self.frame.size];
    
    [chase setDelegate:target];
    [layer addAnimation:chase forKey:@"poppingOpen"];
    
    [CATransaction commit];
    */
}

- (void)popClose:(float)popFactor target:(id)target
{
    CGFloat midHeight = self.frame.size.height * popFactor;
    CGFloat midWidth = self.frame.size.width * popFactor;
    CGSize startSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGSize targetSize = CGSizeMake(midWidth, midHeight);
    
    CALayer *layer= self.layer;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:1.00] forKey:kCATransactionAnimationDuration];
    
    CAAnimation *chase = [CAKeyframeAnimation  animationWithKeyPath:@"poppingClosed"
                                                          function:BackEaseIn fromSize:startSize toSize:targetSize];
    
    [chase setDelegate:self];
    [layer addAnimation:chase forKey:@"poppingClosed"];
    
    [CATransaction commit];
    
    //[self setAlpha:0.0f];
}

@end