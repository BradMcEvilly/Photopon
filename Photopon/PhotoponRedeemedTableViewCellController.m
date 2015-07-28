//
//  PhotoponRedeemedTableViewCellController.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/24/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import "PhotoponRedeemedTableViewCellController.h"

@interface PhotoponRedeemedTableViewCellController ()

@end

@implementation PhotoponRedeemedTableViewCellController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
