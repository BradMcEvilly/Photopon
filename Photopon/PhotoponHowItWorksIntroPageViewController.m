//
//  PhotoponHowItWorksIntroPageViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponHowItWorksIntroPageViewController.h"
#import "PhotoponHowItWorksTutorialViewController.h"

@interface PhotoponHowItWorksIntroPageViewController ()

@end

@implementation PhotoponHowItWorksIntroPageViewController

@synthesize photoponHowItWorksTutorialViewController;
@synthesize photoponBtnGetStarted;

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
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)photoponBtnGetStartedHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponHowItWorksTutorialViewController) {
        if (IS_IPAD) {
            self.photoponHowItWorksTutorialViewController = [[PhotoponHowItWorksTutorialViewController alloc] initWithNibName:@"PhotoponHowItWorksTutorialViewController-iPad" bundle:nil];
        }else{
            self.photoponHowItWorksTutorialViewController = [[PhotoponHowItWorksTutorialViewController alloc] initWithNibName:@"PhotoponHowItWorksTutorialViewController" bundle:nil];
        }
    }
    
    [self presentViewController:self.photoponHowItWorksTutorialViewController animated:YES completion:nil];
    
}

@end
