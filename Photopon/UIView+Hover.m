//
//  UIView+Hover.m
//  Photopon
//
//  Created by Brad McEvilly on 7/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIView+Hover.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Hover)

#define NUM_VIEW_HOVER_FACTORS 22

+ (CAKeyframeAnimation*)dockHoverAnimationWithViewHeight:(CGFloat)viewHeight
{
    CGFloat const kFactorsPerSec    = 30.0f;
    CGFloat const kFactorsMaxValue  = 128.0f;
    CGFloat factors[NUM_VIEW_HOVER_FACTORS]    = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};
    
    NSMutableArray* transforms = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < NUM_VIEW_HOVER_FACTORS; i++)
    {
        
        
        CGFloat positionOffset  = factors[i] / kFactorsMaxValue * viewHeight;
        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -positionOffset, 0.0f);
        
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = NUM_VIEW_HOVER_FACTORS * 1.0f/kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES; // final stage is equal to starting stage
    animation.autoreverses          = NO;
    
    return animation;
}

- (void)hover:(float)hoverFactor{
    CGFloat midHeight = self.frame.size.height * hoverFactor;
    CAKeyframeAnimation* animation = [[self class] dockHoverAnimationWithViewHeight:midHeight];
    [self.layer addAnimation:animation forKey:@"hovering"];    
}


@end
