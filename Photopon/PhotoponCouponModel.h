//
//  PhotoponCouponModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel+Subclass.h"

@class PhotoponPlaceModel;

@interface PhotoponCouponModel : PhotoponModel

@property (readonly) NSString* identifier;
@property (readonly) NSString* title;
@property (readonly) NSString* details;
@property (readonly) NSString* terms;
@property (readonly) NSString* instructions;
@property (readonly) NSDate* start;
@property (readonly) NSString *startString;
@property (readonly) NSDate* expiration;
@property (readonly) NSString *expirationString;
@property (readonly) NSString *expirationTextString;
@property (readonly) PhotoponPlaceModel* place;
@property (readonly) NSString *couponType;
@property (readonly) NSString *couponURL;
@property (readonly) NSString *value;

/**
 Creates an empty local post associated with blog
 */
+ (PhotoponCouponModel *)newPhotoponDraftCoupon;

+ (void)setNewPhotoponDraftCoupon:(PhotoponCouponModel *)coupon;

+ (void)clearNewPhotoponDraftCoupon;

+ (NSString*)extractOfferValueFromOfferContent:(NSString *)offerContent;

+ (PhotoponCouponModel *)modelWithDictionary:(NSDictionary*)dict;

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

+ (void)clearNewPhotoponDraftCoupon;

- (void) cacheCouponAttributes;

@end
