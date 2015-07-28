//
//  UIViewController+Photopon.m
//  Photopon
//
//  Created by Brad McEvilly on 9/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIViewController+Photopon.h"

@implementation UIViewController (Photopon)

- (void)photoponDismissSemiModalSelf {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

- (void) photoponDismissSemiModalViewWithController:(UIViewController*)targetController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    UIViewController * parent = [targetController.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
    
}


@end
