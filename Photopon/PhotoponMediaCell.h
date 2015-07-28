//
//  PhotoponMediaCell.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponImageView;
@class PhotoponOfferOverlayView;

@interface PhotoponMediaCell : PhotoponTableViewCell

@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *offerOverlay;

@property (nonatomic, strong) UIButton *photoButton;

- (void)setDetail:(NSString *)detailText offerValue:(NSString *)valueText personalMessage:(NSString *)personalMessageText;

- (void)setPlaceName:(NSString *)placeNameText placeDistance:(NSString *)placeDistanceText offerSourceImageURL:(NSString *)sourceImageURL;

@end
