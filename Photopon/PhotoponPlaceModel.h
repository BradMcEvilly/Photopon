//
//  PhotoponPlaceModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel+Subclass.h"

@interface PhotoponPlaceModel : PhotoponModel

@property (readonly) NSString* identifier;
@property (readonly) NSString* publicID;
@property (readonly) NSString* name;
@property (readonly) NSString* addressFull;
@property (readonly) NSString* street;
@property (readonly) NSString* city;
@property (readonly) NSString* state;
@property (readonly) NSString* zip;
@property (readonly) NSString* phone;
@property (readonly) NSString* category;
@property (readonly) NSString* imageUrl;
@property (readonly) NSString* bio;
@property (readonly) NSString* locationIdentifier;
@property (readonly) NSString* locationLatitude;
@property (readonly) NSString* locationLongitude;
@property (readonly) NSNumber* rating;
@property (readonly) NSString* url;
@property (readonly) NSString* offerSourceImageURL;

@property (nonatomic, strong) NSMutableDictionary* dictionary;

/**
 Creates an empty local post associated with blog
 */
+ (PhotoponPlaceModel *)newPhotoponDraftPlace;

+ (void)setNewPhotoponDraftPlace:(PhotoponPlaceModel *)place;

+ (void)clearNewPhotoponDraftPlace;

+ (PhotoponPlaceModel *)modelWithDictionary:(NSDictionary*)dict;

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

//+ (void)clearNewPhotoponDraftPlace;

- (void) cachePlaceAttributes;

@end
