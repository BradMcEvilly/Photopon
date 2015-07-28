//
//  PhotoponGeoPointModel.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoponGeoPointModel : NSObject<NSCopying>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

+ (PhotoponGeoPointModel *)geoPointWithLatitude:(double)latitude longitude:(double)longitude;

@end
