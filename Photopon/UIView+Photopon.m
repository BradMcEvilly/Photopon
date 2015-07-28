//
//  UIView+Photopon.m
//  Photopon
//
//  Created by Brad McEvilly on 8/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIView+Photopon.h"

@implementation UIView (Photopon)

- (void) dismiss {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGRect startFrame = self.frame;
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                        if(self.alpha == 0) {
                             self.frame = startFrame;
                             //UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                        }
                     }];
}


//- (void) presentWithFrame:(CGRect)targetFrame {
- (void) present{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGFloat startWidth = self.frame.size.width*0.8f;
    CGFloat startHeight = self.frame.size.height*0.8f;
    CGFloat startOffsetX = (self.frame.size.width - startWidth) / 2;
    CGFloat startOffsetY = (self.frame.size.height - startHeight) / 2;
    CGRect startFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, startWidth + startOffsetX, startHeight + startOffsetY);
    
    CGRect targetFrame = self.frame;
    self.frame = startFrame;
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 1;
                         self.frame = targetFrame;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 1) {
                             self.frame = targetFrame;
                             //UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                         }
                     }];
}

- (void)fadeInView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.6];
    self.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)fadeOutView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.6];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)fadeInView:(UIView*)targetView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     [UIView beginAnimations:@"fade in" context:nil];
     [UIView setAnimationDuration:FADE_TIMING];
     targetView.alpha = 1.0;
     [UIView commitAnimations];
     
     //[targetView setAlpha:0.0f];
     */
    
    [targetView setHidden:NO];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
        [UIView setAnimationDuration:0.5f];
        targetView.alpha = 1.0;
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            [targetView setAlpha:1.0f];
        }
    }];
    
    
}

- (void)fadeOutView:(UIView*)targetView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[UIView beginAnimations:@"fade out" context:nil];
    //[UIView commitAnimations];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
        [UIView setAnimationDuration:0.5f];
        targetView.alpha = 0.0;
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            [targetView setAlpha:0.0f];
            [targetView setHidden:YES];
        }
    }];
    
}



@end
