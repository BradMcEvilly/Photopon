//
//  PhotoponNewPhotoponShutterViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponNewPhotoponShutterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *photoponShutterPanelTop;
@property (nonatomic, strong) IBOutlet UIView *photoponShutterPanelBottom;

@property (nonatomic, strong) IBOutlet UIImageView *photoponShutterSceneForegroundView;
@property (nonatomic, strong) IBOutlet UIImageView *photoponShutterSceneBackgroundView;

- (void) open;

- (void) close;

- (void) configureViewForModeOpen;

- (void) configureViewForModeClose;

- (void) hide;

@end
