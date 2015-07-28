//
//  PhotoponOfferOverlayView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponOfferOverlayView : UIView

//@property (nonatomic,retain) IBOutlet UILabel *photoponPersonalMessage;
@property (nonatomic,retain) IBOutlet UILabel *photoponOfferDetails;
@property (nonatomic,retain) IBOutlet UILabel *photoponPlaceDetails;
@property (nonatomic,retain) IBOutlet UILabel *photoponOfferValue;
@property (nonatomic,retain) IBOutlet UILabel *photoponPersonalMessage;
//@property (nonatomic, strong) NSString *distanceText;
@property (nonatomic, strong) NSString *distanceText;
@property (nonatomic, strong) NSString *sourceURL;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) IBOutlet UIImageView *sourceImageView;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabelView;

@property (readwrite, weak) IBOutlet UIView *offerSourceImageContainer;

+ (PhotoponOfferOverlayView *)photoponOfferOverlayViewWithOfferDetails:(NSString *)detailsText offerValue:(NSString *)valueText personalMessage:(NSString *)personalMessageText;
- (void)setDetail:(NSString *)detailText offerValue:(NSString *)valueText personalMessage:(NSString *)personalMessageText;
- (void)setPlaceName:(NSString *)placeNameText placeDistance:(NSString *)placeDistanceText offerSourceImageURL:(NSString *)sourceImageURL;
- (void)setPlaceDetails:(NSString *)detailText;
- (void)centerInSuperview;

@end
