//
//  PhotoponLogoSplashView.h
//  Photopon
//
//  Created by Brad McEvilly on 8/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PhotoponLogoSplashView : UIView
{
@private
    CGFloat maxValue;
    CGFloat currentValue;
    
    CALayer* progressLayer;
    CALayer* maskLayer;
}
-(id) initWithBackgroundImage:(UIImage*)_bgImg progressImage:(UIImage*)_progressImg progressMask:(UIImage*)_progressMaskImg insets:(CGSize)barInset;;

@property (nonatomic) CGFloat currentValue;
@property (nonatomic) CGFloat maxValue;

@end
