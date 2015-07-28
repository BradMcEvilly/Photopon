//
//  PhotoponProfileImageView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponImageView;
@interface PhotoponProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PhotoponImageView *profileImageView;

- (void)setFile:(PhotoponFile *)file;

@end
