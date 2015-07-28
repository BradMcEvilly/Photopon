//
//  PhotoponBaseUIViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponBaseUIViewController.h"
#import "PhotoponToolTipViewController.h"

@interface PhotoponBaseUIViewController ()

@end

@implementation PhotoponBaseUIViewController

@synthesize photoponBackgroundImageNameString;
@synthesize photoponBackgroundImageView;
@synthesize photoponBackgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
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
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    
    if (IS_IPAD) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite-768.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    }
    /*
    self.photoponBackgroundImageNameString = [[NSString alloc] initWithFormat:@"%@", @"PhotoponBackgroundShort@2x.png"];
    self.photoponBackgroundImage = [UIImage photoponImageNamed:self.photoponBackgroundImageNameString];
    [self.photoponBackgroundImageView setImage:self.photoponBackgroundImage];
    */

}

-(void) showToolTipImageName:(NSString*)imageName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // this should be overridden but if it's not then show a generic empty message view
    if (!imageName) {
        // set default image
        imageName = @"PhotoponEmptyTable.png";
    }
    
    NSLog(@"Table is empty");
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.view.bounds];
    
    
    
    PhotoponToolTipViewController *photoponToolTipViewController = [[PhotoponToolTipViewController alloc] initWithNibName:@"PhotoponToolTipViewController" bundle:nil];
    
    photoponToolTipViewController.delegate = self;
    photoponToolTipViewController.toolTipImageName = @"PhotoponToolTipDefault.png";
    
    [self presentSemiViewController:photoponToolTipViewController withOptions:nil completion:^{
        [photoponToolTipViewController fadeInView];
    } dismissBlock:nil];
    
    /*[self presentViewController:photoponToolTipViewController animated:YES completion:^{
        [photoponToolTipViewController fadeInView];
    }];*/
    
    //[self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
