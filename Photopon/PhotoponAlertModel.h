//
//  PhotoponAlertModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoponUserModel;

@interface PhotoponAlertModel : NSObject
{
    NSString* identifier;
    NSString* details;
    NSString* terms;
    NSString* instructions;
    NSDate* createdDate;
    PhotoponUserModel* user;
    NSNumber *readFlag;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* details;
@property (nonatomic, retain) NSString* terms;
@property (nonatomic, retain) NSString* instructions;
@property (nonatomic, retain) NSDate* createdDate;
@property (nonatomic, retain) PhotoponUserModel* user;
@property (nonatomic, retain) NSNumber *readFlag;


@end