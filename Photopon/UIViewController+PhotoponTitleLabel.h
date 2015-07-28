//
//  UIViewController+PhotoponTitleLabel.h
//  Photopon
//
//  Created by Brad McEvilly on 7/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PhotoponTitleLabel) <UINavigationControllerDelegate, UINavigationBarDelegate>

-(void)initTitleLabelWithText:(NSString*)title;

@end
