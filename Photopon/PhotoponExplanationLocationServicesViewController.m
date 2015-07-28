//
//  PhotoponExplanationLocationServicesViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 10/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponExplanationLocationServicesViewController.h"
#import "PhotoponSnipTutorialViewController.h"

@interface PhotoponExplanationLocationServicesViewController ()

@end

@implementation PhotoponExplanationLocationServicesViewController

@synthesize photoponBtnOK;

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
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)photoponBtnOKHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([[PhotoponAppDelegate sharedPhotoponApplicationDelegate].photoponSnipTutorialViewController isViewLoaded]) {
        NSLog(@"if ([[PhotoponAppDelegate sharedPhotoponApplicationDelegate].photoponSnipTutorialViewController");
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate].photoponSnipTutorialViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"else");
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] dismissExplanationLocationServices];
    }
    
    //[self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] dismissTutorialSnip];
    
}

@end
