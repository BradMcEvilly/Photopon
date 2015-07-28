//
//  PhotoponLogoSplashViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponLogoSplashViewController.h"
#import "PhotoponLogoSplashView.h"

@interface PhotoponLogoSplashViewController ()

@end

@implementation PhotoponLogoSplashViewController

@synthesize photoponLogoCameraImageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.6];
    self.photoponLogoCameraImageView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.6];
    self.photoponLogoCameraImageView.alpha = 0.0;
    [UIView commitAnimations];
    
}

#pragma mark - View lifecycle
-(void) setProgressNextValue
{
    progressValue += 0.2f;
    if(progressValue > progress.maxValue)
        return;// progressValue = progress.maxValue;
        
        progress.currentValue = progressValue;
        [self performSelector:@selector(setProgressNextValue) withObject:nil afterDelay:0.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    progress = [[PhotoponLogoSplashView alloc] initWithBackgroundImage:[UIImage imageNamed:@"PhotoponLogoTextBlueBG.png"]
                                                    progressImage:[UIImage imageNamed:@"PhotoponLogoTextBlue.png"]
                                                     progressMask:[UIImage imageNamed:@"PhotoponLogoTextBlueMask.png"]
                                                           insets:CGSizeMake(0, 0)];
    [self.view addSubview:progress];
    
    progress.center = CGPointMake(76, 114);
    progress.maxValue = 43.0f; //200.0f;
    
    //progress.currentValue = progress.maxValue;
    
    [self fadeInView];
    
    [self setProgressNextValue];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end