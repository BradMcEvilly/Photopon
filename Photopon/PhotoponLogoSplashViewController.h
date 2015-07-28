//
//  PhotoponLogoSplashViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 8/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponLogoSplashView;
@interface PhotoponLogoSplashViewController : UIViewController
{


@private
    CGFloat progressValue;
    PhotoponLogoSplashView* progress;
}
@property (nonatomic, strong) IBOutlet UIImageView *photoponLogoCameraImageView;

@end


