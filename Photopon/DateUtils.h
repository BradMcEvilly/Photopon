//
//  DateUtils.h
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "NSDate-Utilities.h"
#import "NSDate+Helper.h"

@interface DateUtils : NSObject {

}
+ (NSDate *) currentGMTDate;
+ (NSDate *) GMTDateTolocalDate:(NSDate *)gmtDate;
+ (NSDate *) localDateToGMTDate:(NSDate *)localDate;
+ (NSString *) createdDateString:(NSDate *)createdDate;
+ (NSString *) expiresDateString:(NSDate *)expiresDate;

@end
