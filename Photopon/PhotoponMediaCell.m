//
//  PhotoponMediaCell.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaCell.h"
#import "PhotoponUtility.h"
#import "PhotoponOfferOverlayView.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponMediaCell

@synthesize photoButton;
@synthesize offerOverlay;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        // Initialization code
        /*
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.backgroundColor = [UIColor clearColor];
        dropshadowView.frame = CGRectMake( 0.0f, -44.0f, 309.0f, 322.0f);
        [self.contentView addSubview:dropshadowView];
        
        CALayer *layer = dropshadowView.layer;
        layer.masksToBounds = NO;
        layer.shadowRadius = 2.0f;
        layer.shadowOpacity = 0.5f;
        layer.shadowOffset = CGSizeMake( 0.0f, -1.0f);
        layer.shouldRasterize = NO;
        
        self.imageView.frame = CGRectMake( 0.0f, 0.0f, 309.0f, 309.0f);
        self.imageView.backgroundColor = [UIColor colorWithRed:230.0f green:230.0f blue:230.0f alpha:1.0f];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake( 0.0f, 0.0f, 309.0f, 309.0f);
        self.photoButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoButton];
        
        [self.contentView bringSubviewToFront:self.imageView];
        
        [self.contentView addSubview:offerOverlay];
    
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        */
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    
        
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.backgroundColor = [UIColor clearColor];
        dropshadowView.frame = CGRectMake( 0.0f, -44.0f, 309.0f, 322.0f);
        [self.contentView addSubview:dropshadowView];
        
        CALayer *layer = dropshadowView.layer;
        layer.masksToBounds = NO;
        layer.shadowRadius = 2.0f;
        layer.shadowOpacity = 0.5f;
        layer.shadowOffset = CGSizeMake( 0.0f, -1.0f);
        layer.shouldRasterize = NO;
        
        self.imageView.frame = CGRectMake( 6.0f, 56.0f, 309.0f, 309.0f);
        self.imageView.backgroundColor = [UIColor colorWithRed:230.0f green:230.0f blue:230.0f alpha:1.0f];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake( 6.0f, 56.0f, 309.0f, 309.0f);
        self.photoButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoButton];
        
        [self.contentView bringSubviewToFront:self.imageView];
        
        [self.contentView addSubview:offerOverlay];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}

- (void)setDetail:(NSString *)detailText offerValue:(NSString *)valueText personalMessage:(NSString *)personalMessageText{
    
    if (self.offerOverlay!=nil) {
        [self.offerOverlay setDetail:detailText offerValue:valueText personalMessage:personalMessageText];
        [self addSubview:self.offerOverlay];
        return;
    }
    
    self.offerOverlay = [PhotoponOfferOverlayView photoponOfferOverlayViewWithOfferDetails:detailText offerValue:valueText personalMessage:personalMessageText];
    
    [self addSubview:self.offerOverlay];
    [self.offerOverlay centerInSuperview];
    
    //self.offerOverlay = [PhotoponOfferOverlayView photoponOfferOverlayViewWithOfferDetails:[[NSString alloc] initWithFormat:@"%@", @""] offerValue:[[NSString alloc] initWithFormat:@"%@", @""]];
}

- (void)setPlaceName:(NSString *)placeNameText placeDistance:(NSString *)placeDistanceText offerSourceImageURL:(NSString *)sourceImageURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.offerOverlay!=nil) {
        [self.offerOverlay setPlaceName:placeNameText placeDistance:placeDistanceText offerSourceImageURL:sourceImageURL];
        //[self.offerOverlay setNeedsDisplay];
    }
    
}

#pragma mark - UIView

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 6.0f, 56.0f, 309.0f, 309.0f);
    self.photoButton.frame = CGRectMake( 6.0f, 56.0f, 309.0f, 309.0f);
    
    [self.contentView bringSubviewToFront:self.photoButton];
    
    
    // CGRectMake(0, CGRectGetMaxY(self.topMaskView.frame), CGRectGetWidth(self.frame), CGRectGetMinY(self.bottomMaskView.frame) - CGRectGetMaxY(self.topMaskView.frame));
    
    
}
/*
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    
    //if (!hideDropShadow) {
    
    [PhotoponUtility drawSideAndBottomDropShadowForRect:self.frame inContext:UIGraphicsGetCurrentContext()];
    //[PhotoponUtility drawSideAndBottomDropShadowForRect:self.frame inContext:UIGraphicsGetCurrentContext()];
    
    
    //}
}

*/

@end