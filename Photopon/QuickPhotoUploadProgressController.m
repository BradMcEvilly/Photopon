//
//  QuickPhotoUploadProgressController.m
//  Photopon
//
//  Created by Bradford McEvilly on 5/16/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "QuickPhotoUploadProgressController.h"
//#import "PhotoponProgressViewController.h"

@implementation QuickPhotoUploadProgressController

@synthesize label, spinner;
@synthesize photoponProgressBar;
@synthesize prog;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{
    self.label = nil;
    self.spinner = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.label = nil;
    self.spinner = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
