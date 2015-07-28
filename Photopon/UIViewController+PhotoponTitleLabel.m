//
//  UIViewController+PhotoponTitleLabel.m
//  Photopon
//
//  Created by Brad McEvilly on 7/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIViewController+PhotoponTitleLabel.h"

@implementation UIViewController (PhotoponTitleLabel)

-(void)initTitleLabelWithText:(NSString*)title{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite-768.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor  whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, -1.0f);
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:159.0f green:169.0f blue:179.0f alpha:1.0f]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(title, @"");
    [label sizeToFit];
}

@end
