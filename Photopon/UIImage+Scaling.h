//
//  UIImage+Scaling.h
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)
-(UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
-(UIImage*) croppedImageWithRect: (CGRect) rect;
@end
