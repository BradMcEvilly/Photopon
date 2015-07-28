//
//  PhotoponHowItWorksIntroPageViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponHowItWorksTutorialViewController;

@interface PhotoponHowItWorksIntroPageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnGetStarted;

@property(nonatomic,strong) IBOutlet PhotoponHowItWorksTutorialViewController *photoponHowItWorksTutorialViewController;

-(IBAction)photoponBtnGetStartedHandler:(id)sender;

@end
