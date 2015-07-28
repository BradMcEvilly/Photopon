//
//  PhotoponCoordinateModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoponCoordinateModel : NSObject
{
    CLLocation *location;
    NSString *latitudeString;
    NSString *longitudeString;
}

@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) NSString *latitudeString;
@property (nonatomic,strong) NSString *longitudeString;
@property (readonly) CLLocationDegrees latitude;
@property (readonly) CLLocationDegrees longitude;
@property (assign) CLLocationCoordinate2D coordinate;

@end
