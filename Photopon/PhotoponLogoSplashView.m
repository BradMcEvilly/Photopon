//
//  PhotoponLogoSplashView.m
//  Photopon
//
//  Created by Brad McEvilly on 8/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponLogoSplashView.h"

@implementation PhotoponLogoSplashView
@synthesize currentValue, maxValue;

-(void) dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        maxValue = 43.0f;
    }
    return self;
}

-(id) initWithBackgroundImage:(UIImage*)_bgImg progressImage:(UIImage*)_progressImg progressMask:(UIImage*)_progressMaskImg insets:(CGSize)barInset;
{
    if(self = [super initWithFrame:CGRectMake(0, 0, _bgImg.size.width, _bgImg.size.height)])
    {
        maskLayer = [[CALayer alloc] init];
        maskLayer.frame = CGRectMake(barInset.width, barInset.height, _progressMaskImg.size.width, _progressMaskImg.size.height);
        maskLayer.contents = (id)_progressMaskImg.CGImage;
        self.layer.mask = maskLayer;
        
        // making background layer;
        CALayer* bgLayer = [[CALayer alloc] init];
        bgLayer.frame = self.bounds;
        bgLayer.contents = (id)_bgImg.CGImage;
        [self.layer addSublayer:bgLayer];
        
        progressLayer = [[CALayer alloc] init];
        progressLayer.frame = CGRectMake(barInset.width, barInset.height, _progressImg.size.width, _progressImg.size.height);
        progressLayer.contents = (id)_progressImg.CGImage;
        
        [self.layer addSublayer:progressLayer];
        
    }
    return self;
}


-(void) setCurrentValue:(CGFloat)val
{
    currentValue = val;
    // calculate progressLayerPosition depends on currentValue Here
    CGRect f = maskLayer.frame;
    f.origin.y = f.size.height / maxValue * currentValue - f.size.height;
    maskLayer.frame = f;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
