//
//  PhotoponGeoPointModel.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponGeoPointModel.h"

@implementation PhotoponGeoPointModel

+ (PhotoponGeoPointModel *)geoPointWithLatitude:(double)latitude longitude:(double)longitude{
    PhotoponGeoPointModel* point = [[self alloc] init];
	point.latitude = latitude;
	point.longitude = longitude;
	return point;
}

- (id)copyWithZone:(NSZone *)zone{
	return [PhotoponGeoPointModel geoPointWithLatitude:self.latitude longitude:self.longitude];
}

@end
