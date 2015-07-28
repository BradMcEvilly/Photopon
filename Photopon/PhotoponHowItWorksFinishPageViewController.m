//
//  PhotoponHowItWorksFinishPageViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "PhotoponHowItWorksFinishPageViewController.h"

@interface PhotoponHowItWorksFinishPageViewController ()

@end

@implementation PhotoponHowItWorksFinishPageViewController

@synthesize photoponBtnFinish;
@synthesize photoponBtnInvite;
@synthesize smsMessageViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    if ([MFMessageComposeViewController canSendText]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([MFMessageComposeViewController canSendText]) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            weakSelf.smsMessageViewController = [[MFMessageComposeViewController alloc] init];
            weakSelf.smsMessageViewController.messageComposeDelegate = self;
            weakSelf.smsMessageViewController.body = [PhotoponUtility appShareMessage];
        
        });
    }
    
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - MFMessageComposeViewController Delegate methods

// Then implement the delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"Entered messageComposeController");
    switch (result) {
        case MessageComposeResultSent:
        {
            
            NSLog(@"SENT");
            //[self showHUDWithStatusText:@"SENT"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
            
        }
            break;
        case MessageComposeResultFailed:
        {
            
            NSLog(@"FAILED");
            //[self showHUDWithStatusText:@"Failed"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
        }
            break;
        case MessageComposeResultCancelled:
        {
            
            NSLog(@"CANCELLED");
            //[self showHUDWithStatusText:@"CANCELLED"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
            
        }
            break;
    }
    
}

- (void)presentMessageViewController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self presentViewController:self.smsMessageViewController animated:YES completion:nil];
    
}

- (void)dismissMessageViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidHideShareApp object:nil];
    
}

-(IBAction)photoponBtnFinishHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] dismissTutorialHowItWorks];
    
    //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] popViewControllerAnimated:YES];
    
}

-(IBAction)photoponBtnInviteHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self presentMessageViewController];
    
    
    //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] popViewControllerAnimated:YES];
    
}


@end
