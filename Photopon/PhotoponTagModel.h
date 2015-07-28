//
//  PhotoponTagModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel+Subclass.h"

@interface PhotoponTagModel : PhotoponModel

// tag photopon wordpress identifier
@property (readonly) NSString* identifier;

// if user, the username; if hashtag, the hashtag name/title; if place, place name... etc
@property (readonly) NSString* taggedObjectTitle;

// if user, photoponUserModel.identifier, if place, photoponPlaceModel.identifier, etc
@property (readonly) NSString* taggedObjectID;

// PhotoponUserClass, PhotoponPlaceClass, PhotoponMediaClass
@property (readonly) NSString* taggedObjectClassName;

@property (readonly) NSDate* addedTime;

@end
