//
//  PhotoponImageView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponUIImageView.h"

@interface PhotoponImageView : PhotoponUIImageView

@property (nonatomic, strong) PhotoponFile *file;

@property (nonatomic, strong) UIProgressView *progressView;

/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 */
@property (assign) float progress;

- (void)loadInBackground;
- (void)loadInBackground:(void (^)(UIImage *image, NSError *error))completion;

@end
