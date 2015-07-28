//
//  PhotoponHowItWorksTutorialViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponHowItWorksTutorialViewController.h"
#import "StyledPageControl.h"

#import "PhotoponHowItWorksFirstPageViewController.h"
#import "PhotoponHowItWorksSecondPageViewController.h"
#import "PhotoponHowItWorksThirdPageViewController.h"
#import "PhotoponHowItWorksFourthPageViewController.h"
#import "PhotoponHowItWorksFinishPageViewController.h"

@interface PhotoponHowItWorksTutorialViewController ()

@end

@implementation PhotoponHowItWorksTutorialViewController

@synthesize photoponTutorialPageControl;
@synthesize photoponPagesContainerView;
@synthesize photoponTutorialPagesScrollView;

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
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self configurePhotoponPageControlStyle];
    
    // Add Photopon HIW Tutorial Page 1
    [self.photoponTutorialPagesScrollView addPagedViewController:[[PhotoponHowItWorksFirstPageViewController alloc] initWithNibName:@"PhotoponHowItWorksFirstPageViewController" bundle:nil] ];
    
    // Add Photopon HIW Tutorial Page 2
    [self.photoponTutorialPagesScrollView addPagedViewController:[[PhotoponHowItWorksSecondPageViewController alloc] initWithNibName:@"PhotoponHowItWorksSecondPageViewController" bundle:nil] ];
    
    // Add Photopon HIW Tutorial Page 3
    [self.photoponTutorialPagesScrollView addPagedViewController:[[PhotoponHowItWorksThirdPageViewController alloc] initWithNibName:@"PhotoponHowItWorksThirdPageViewController" bundle:nil] ];
    
    // Add Photopon HIW Tutorial Page 4
    [self.photoponTutorialPagesScrollView addPagedViewController:[[PhotoponHowItWorksFourthPageViewController alloc] initWithNibName:@"PhotoponHowItWorksFourthPageViewController" bundle:nil] ];
    
    // Add Photopon HIW Finish Page 5
    [self.photoponTutorialPagesScrollView addPagedViewController:[[PhotoponHowItWorksFinishPageViewController alloc] initWithNibName:@"PhotoponHowItWorksFinishPageViewController" bundle:nil] ];
    
    
    
}

-(void)configurePhotoponPageControlStyle{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponTutorialPageControl setPageControlStyle:PageControlStyleDefault];
    
    [self.photoponTutorialPageControl setNumberOfPages:5];
    [self.photoponTutorialPageControl setCurrentPage:1];
    [self.photoponTutorialPageControl setCoreNormalColor:[UIColor colorWithRed:30.0 green:94.0 blue:174.0 alpha:1.0f]];
    [self.photoponTutorialPageControl setCoreSelectedColor:[UIColor whiteColor]];
    [self.photoponTutorialPageControl setGapWidth:28];
    [self.photoponTutorialPageControl setDiameter:8];
    [self.photoponTutorialPageControl setAlpha:1.0f];
    
    /* custom page control thumbnails
     [pageControl setPageControlStyle:PageControlStyleThumb];
     [pageControl setThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-normal.png"]];
     [pageControl setSelectedThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-selected.png"]];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
