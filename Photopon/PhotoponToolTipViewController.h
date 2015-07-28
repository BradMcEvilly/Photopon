//
//  PhotoponToolTipViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponToolTipViewController : UIViewController

@property(nonatomic, strong) id delegate;
@property(nonatomic, strong) NSString *toolTipImageName;
@property(nonatomic, strong) IBOutlet UIImageView *toolTipImageView;
@property(nonatomic, strong) IBOutlet UIButton *closeBtn;

- (void) showToolTipImageView;

- (void) fadeInView;
- (void) fadeOutView;

- (IBAction)closeBtnHandler:(id)sender;

@end
