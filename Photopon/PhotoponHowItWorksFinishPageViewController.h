//
//  PhotoponHowItWorksFinishPageViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponHowItWorksFinishPageViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) MFMessageComposeViewController *smsMessageViewController;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnInvite;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnFinish;

//@property(nonatomic,strong) IBOutlet PhotoponHowItWorksTutorialViewController *photoponHowItWorksTutorialViewController;

-(IBAction)photoponBtnFinishHandler:(id)sender;

-(IBAction)photoponBtnInviteHandler:(id)sender;

@end
