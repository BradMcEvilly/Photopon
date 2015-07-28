//
//  UINavigationController+PhotoponTransitions.h
//  Photopon
//
//  Created by Brad McEvilly on 9/16/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PhotoponTransitions)

@property (nonatomic, strong) UIImageView *photoponPlaceholderNewPhotoponOverlayImageView;

-(void)pushPhotoponPickerViewController:(UIViewController *)viewController;

-(void)popPhotoponPickerViewController;

-(void)pushPhotoponViewController:(UIViewController *)viewController;

-(void)popPhotoponViewController;



@end
