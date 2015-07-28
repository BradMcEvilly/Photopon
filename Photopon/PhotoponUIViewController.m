//
//  PhotoponUIViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUIViewController.h"

@interface PhotoponUIViewController ()

@end

@implementation PhotoponUIViewController

// container views
@synthesize pickerContainer;
@synthesize offersContainer;
@synthesize shutterContainer;
@synthesize currentScreenShot;
@synthesize overlayContainer;




// container controllers
// @synthesize offersContainerController;
// @synthesize shutterContainerController;
// @synthesize pickerContainerController;



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
	// Do any additional setup after loading the view.
}
-(void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
