//
//  PhotoponHowItWorksTutorialViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 10/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FireUIPagedScrollView.h"

@class StyledPageControl;

@interface PhotoponHowItWorksTutorialViewController : UIViewController

@property (nonatomic, strong) IBOutlet FireUIPagedScrollView * photoponTutorialPagesScrollView;

@property(nonatomic,strong) IBOutlet UIView *photoponPagesContainerView;

//@property (nonatomic, strong) IBOutlet UIView *photoponToolTipOverlay;

@property (nonatomic, strong) IBOutlet StyledPageControl *photoponTutorialPageControl;

@end
