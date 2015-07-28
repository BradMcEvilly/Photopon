//
//  UINavigationController+PhotoponTransitions.m
//  Photopon
//
//  Created by Brad McEvilly on 9/16/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UINavigationController+PhotoponTransitions.h"
#import "UIView+Screenshot.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponNavigationViewController.h"
#import "PhotoponTabBarController.h"
#import "PhotoponNewPhotoponPickerController.h"

@implementation UINavigationController (PhotoponTransitions)



//

- (void)setPhotoponPlaceholderNewPhotoponOverlayImageView:(UIImageView *)photoponPlaceholderNewPhotoponOverlayImageView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponPlaceholderNewPhotoponOverlayImageView = photoponPlaceholderNewPhotoponOverlayImageView;
    
}

- (UIImageView*)photoponPlaceholderNewPhotoponOverlayImageView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.photoponPlaceholderNewPhotoponOverlayImageView;

}

-(void)pushPhotoponPickerViewController:(UIViewController *)viewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // detect device type to determine which preloaded screenshot to use as view simulation
    
    
    
    
    
    
    /*
    
    [viewController.view setAlpha:0.0f];
    
    self.photoponPlaceholderNewPhotoponOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponPlaceholderNewPhotoponOverlay.png"]];
    
    [self.presentedViewController presentSemiView:self.photoponPlaceholderNewPhotoponOverlayImageView withOptions:nil completion:^{
        
        [UIView animateWithDuration:0.5f animations:^{
            
            viewController.view.alpha = 1.0f;
            
            //[self.presentedViewController.navigationController pushViewController:viewController animated:NO];
            
            //[self pushViewController:viewController animated:NO];
            
            
            self.photoponPlaceholderNewPhotoponOverlayImageView.alpha = 0.0f;
            
            
        } completion:^(BOOL finished) {
        
            if(finished){
            
                
                
            }
            
        }];
        
    }];
    */
}

-(void)popPhotoponPickerViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponPlaceholderNewPhotoponOverlayImageView setImage:[self.presentedViewController.view screenshot]];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.photoponPlaceholderNewPhotoponOverlayImageView.alpha = 1.0f;
        self.presentedViewController.view.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if(finished){
            
            [self.presentedViewController.view setAlpha: 0.0f];
            [self popViewControllerAnimated:NO];
            
            [self.presentedViewController dismissSemiModalViewWithCompletion:^{
                
                self.photoponPlaceholderNewPhotoponOverlayImageView = nil;
                
            }];
            
        }
        
    }];
    
}

-(void)pushPhotoponViewController:(UIViewController *)viewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self pushViewController:viewController animated:NO];
    
    
    
    /*
    
    [viewController.view setAlpha:0.0f];
    
    [viewController loadView];
    
    UIImageView *photoponPlaceholderVCImageView = [[UIImageView alloc] initWithImage:[viewController.view screenshot]];
    
    
    //[viewController.view setAlpha:0.0f];
    
    //self.photoponPlaceholderNewPhotoponOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponPlaceholderNewPhotoponOverlay.png"]];
    
    
    [self.presentedViewController presentSemiView:photoponPlaceholderVCImageView withOptions:nil completion:^{
        
        [self pushViewController:viewController animated:NO];
        
        
        
        [UIView animateWithDuration:0.5f animations:^{
            
            //viewController.view.alpha = 1.0f;
            
            
            //[self pushViewController:viewController animated:NO];
            
            viewController.view.alpha = 1.0f;
            
            self.photoponPlaceholderNewPhotoponOverlayImageView.alpha = 0.0f;
            
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                //[self.presentedViewController.navigationController pushViewController:viewController animated:NO];
                
                
            }
            
        }];
        
    }];
    
    
    /*
    
    
    
    
    
    [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] welcomeViewController] presentSemiView:photoponPlaceholderVCImageView withOptions:nil completion:^{
        
        [UIView animateWithDuration:0.5f animations:^{
            
            photoponPlaceholderVCImageView.alpha = 0.0f;
            viewController.view.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                [viewController.view setAlpha:1.0f];
                
                [self pushViewController:viewController animated:NO];
                
                
                
                [photoponPlaceholderVCImageView setAlpha:1.0f];
                
                //[photoponPlaceholderVCImageView removeFromSuperview];
                
                
            }
            
        }];
        
    }];
    */
}

-(void)popPhotoponViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[viewController.view setAlpha:0.0f];
    
    //[self popViewControllerAnimated:NO];
    
    
    
    [self popViewControllerAnimated:NO];
    
    [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] welcomeViewController] dismissSemiModalViewWithCompletion:^{
        
        
        
    }];
    
}
    /*
    
    UIViewController * vc = [[UIViewController alloc] init];
    
    
    UIImageView *photoponPlaceholderVCImageView = [[UIImageView alloc] initWithImage:[self.view screenshot]];
    
    
    vc.view = photoponPlaceholderVCImageView;
    
    [vc.view setAlpha:0.0f];
    
    [self presentViewController:vc animated:NO completion:^{
    
        [UIView animateWithDuration:0.3f animations:^{
            
            vc.view.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                
                
                
            }
            
        }];
        
    }];
    
    
    
    
    
    
    
    
    
    [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] welcomeViewController] dismissSemiModalViewWithCompletion:^{
        
        
        
        / *
        [UIView animateWithDuration:0.5f animations:^{
         
            photoponPlaceholderVCImageView.alpha = 0.0f;
            viewController.view.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                [viewController.view setAlpha:1.0f];
                
                [self pushViewController:viewController animated:NO];
                
                [photoponPlaceholderVCImageView setAlpha:1.0f];
                
                //[photoponPlaceholderVCImageView removeFromSuperview];
                
                
            }
            
        }];* /
        
    }];

    
    
}


    / *
    
    CGFloat scale = 0.7f;
    
    CGFloat targetWidth     = self.navigationController.view.frame.size.width   * scale;
    CGFloat targetHeight    = self.navigationController.view.frame.size.height  * scale;
    CGFloat targetX         = (self.navigationController.view.frame.size.width      - targetWidth  )    / 2;
    CGFloat targetY         = (self.navigationController.view.frame.size.height     - targetHeight )    / 2;
    
    
    
    UIView *pushedView = viewController.view;
    [pushedView setFrame:CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.size.height, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    
    UIView *target = [[UIView alloc] initWithFrame:CGRectMake(targetX, targetY, targetWidth, targetHeight)];
    
    
    
	// Child controller containment
	[viewController willMoveToParentViewController:nil];
	if ([viewController respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[viewController beginAppearanceTransition:NO animated:YES]; // iOS 6
	}
	
    // Take screenshot and scale
    UIImageView *ss = [[UIImageView alloc] initWithImage: [self.navigationController.presentedViewController.view screenshot]];
    [target addSubview:ss];
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                // As the view is centered, we perform a vertical translation
                self.navigationController.presentedViewController.view.frame = CGRectMake((target.bounds.size.width - pushedView.frame.size.width) / 2.0, target.bounds.size.height, pushedView.frame.size.width, pushedView.frame.size.height);
            } else {
                pushedView.frame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
            }
        
    } completion:^(BOOL finished) {
        
        
        [overlay removeFromSuperview];
        [pushedView removeFromSuperview];
        
        // Child controller containment
        [vc removeFromParentViewController];
        if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
            [vc endAppearanceTransition];
        }
        
        if (dismissBlock) {
            dismissBlock();
        }
        
        objc_setAssociatedObject(self, kSemiModalDismissBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, kSemiModalViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }];
    
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
	if ([[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.pushParentBack] boolValue]) {
		[ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
	}
    [UIView animateWithDuration:duration animations:^{
        ss.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidHideNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    / *
    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         
         [self.navigationController pushViewController:viewController animated:NO];
         
     }
     
     completion:NULL];
    
    [UIView commitAnimations];
    
    
    
    / *
     CATransition* transition = [CATransition animation];
     transition.duration = 1.0;
     transition.type = kCATransitionMoveIn;
     transition.subtype = kCATransitionFromLeft;
     
     [self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
     * /
}
/ *
-(void)pushPhotoponViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options
					  completion:(KNTransitionCompletionBlock)completion
					dismissBlock:(KNTransitionCompletionBlock)dismissBlock {
    [self kn_registerDefaultsAndOptions:options]; // re-registering is OK
	UIViewController *targetParentVC = [self kn_parentTargetViewController];
    
	// implement view controller containment for the semi-modal view controller
	[targetParentVC addChildViewController:vc];
	if ([vc respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[vc beginAppearanceTransition:YES animated:YES]; // iOS 6
	}
	objc_setAssociatedObject(self, kSemiModalViewController, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kSemiModalDismissBlock, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self presentSemiView:vc.view withOptions:options completion:^{
		[vc didMoveToParentViewController:targetParentVC];
		if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
			[vc endAppearanceTransition]; // iOS 6
		}
		if (completion) {
			completion();
		}
	}];
}
 

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionFromView:src.view
                        toView:dst.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:nil];
    [UIView transitionFromView:src.navigationItem.titleView
                        toView:dst.navigationItem.titleView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:nil];
    [src.navigationController pushViewController:dst animated:NO];
}


- (void)resizeSemiView:(CGSize)newSize {
    
    
    
    UIView * target = [self parentTarget];
    UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
    CGRect mf = modal.frame;
    mf.size.width = newSize.width;
    mf.size.height = newSize.height;
    mf.origin.y = target.frame.size.height - mf.size.height;
    UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
    UIButton * button = (UIButton*)[overlay viewWithTag:kSemiModalDismissButtonTag];
    CGRect bf = button.frame;
    bf.size.height = overlay.frame.size.height - newSize.height;
	NSTimeInterval duration = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.animationDuration] doubleValue];
	[UIView animateWithDuration:duration animations:^{
        modal.frame = mf;
        button.frame = bf;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalWasResizedNotification
                                                                object:self];
        }
    }];
}

#pragma mark Push-back animation group

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // The rotation angle is minor as the view is nearer
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Minor shift to mantai perspective
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.04, 0);
        t2 = CATransform3DScale(t2, 0.88, 0.88, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.animationDuration] doubleValue];
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}



-(void)p{
    
    CGFloat scale = 0.7f;
    
    CGFloat targetWidth     = self.navigationController.view.frame.size.width   * scale;
    CGFloat targetHeight    = self.navigationController.view.frame.size.height  * scale;
    CGFloat targetX         = (self.navigationController.view.frame.size.width      - targetWidth  )    / 2;
    CGFloat targetY         = (self.navigationController.view.frame.size.height     - targetHeight )    / 2;
    
    
    UIView *pushedView  = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    
    UIView *target = [[UIView alloc] initWithFrame:CGRectMake(targetX, targetY, targetWidth, targetHeight)];
    
    
    if (![target.subviews containsObject:view]) {
        // Set associative object
        objc_setAssociatedObject(view, kSemiModalPresentingViewController, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // Register for orientation changes, so we can update the presenting controller screenshot
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kn_interfaceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        // Get transition style
        NSUInteger transitionStyle = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.transitionStyle] unsignedIntegerValue];
        
        // Calulate all frames
        CGFloat semiViewHeight = view.frame.size.height;
        CGRect vf = target.bounds;
        CGRect semiViewFrame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // We center the view and mantain aspect ration
            semiViewFrame = CGRectMake((vf.size.width - view.frame.size.width) / 2.0, vf.size.height-semiViewHeight, view.frame.size.width, semiViewHeight);
        } else {
            semiViewFrame = CGRectMake(0, vf.size.height-semiViewHeight, vf.size.width, semiViewHeight);
        }
        
        CGRect overlayFrame = CGRectMake(0, 0, vf.size.width, vf.size.height-semiViewHeight);
        
        // Add semi overlay
        UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlay.tag = kSemiModalOverlayTag;
        
        // Take screenshot and scale
        UIImageView *ss = [self kn_addOrUpdateParentScreenshotInView:overlay];
        [target addSubview:overlay];
        
        // Dismiss button (if allow)
        if(![[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.disableCancel] boolValue]) {
            // Don't use UITapGestureRecognizer to avoid complex handling
            UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
            dismissButton.backgroundColor = [UIColor clearColor];
            dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            dismissButton.frame = overlayFrame;
            dismissButton.tag = kSemiModalDismissButtonTag;
            [overlay addSubview:dismissButton];
        }
        
        // Begin overlay animation
		if ([[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.pushParentBack] boolValue]) {
			[ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
		}
		NSTimeInterval duration = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.animationDuration] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            ss.alpha = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.parentAlpha] floatValue];
        }];
        
        // Present view animated
        view.frame = (transitionStyle == KNSemiModalTransitionStyleSlideUp
                      ? CGRectOffset(semiViewFrame, 0, +semiViewHeight)
                      : semiViewFrame);
        if (transitionStyle == KNSemiModalTransitionStyleFadeIn || transitionStyle == KNSemiModalTransitionStyleFadeInOut) {
            view.alpha = 0.0;
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // Don't resize the view width on rotating
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        } else {
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        }
        
        view.tag = kSemiModalModalViewTag;
        [target addSubview:view];
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, -2);
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOpacity = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.shadowOpacity] floatValue];
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        [UIView animateWithDuration:duration animations:^{
            if (transitionStyle == KNSemiModalTransitionStyleSlideUp) {
                view.frame = semiViewFrame;
            } else if (transitionStyle == KNSemiModalTransitionStyleFadeIn || transitionStyle == KNSemiModalTransitionStyleFadeInOut) {
                view.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            if (!finished) return;
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidShowNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }];
    }

    
    
}

-(void)popPhotoponViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
*/
@end
