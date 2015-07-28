//
//  PhotoponSnipTutorialViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 10/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponSnipTutorialViewController.h"

@interface PhotoponSnipTutorialViewController ()

@end

@implementation PhotoponSnipTutorialViewController

@synthesize photoponBtnOK;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)photoponBtnOKHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] dismissTutorialSnip];
    
}

@end
