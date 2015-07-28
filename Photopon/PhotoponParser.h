//
//  PhotoponParser.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PhotoponConstants.h"
#import "PhotoponACL.h"
#import "PhotoponObject.h"
#import "PhotoponGeoPointModel.h"
#import "PhotoponQuery.h"
#import "PhotoponUser.h"
#import "PhotoponFile.h"
#import "PhotoponPush.h"
#import "PhotoponInstallation.h"
#import "PhotoponImageView.h"
//#import "PhotoponLoginView.h"
#import "PhotoponTableViewCell.h"
#import "PhotoponQueryTableViewController.h"
#import "PhotoponAdapterUtils.h"
#import "PhotoponApplicationKey.h"
//#import "PhotoponFacebookUtils.h"
#import "PhotoponLoginViewController.h"

@interface PhotoponParser : NSObject
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (void)setRequestLogEnabled:(BOOL)flag;
@end