//
//  DateUtils.m
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "DateUtils.h"
#import "NSDate-Utilities.h"
#import "NSDate+Helper.h"

@implementation DateUtils

+ (NSDate *) currentGMTDate {
	NSDate *currentLocalDate = [NSDate date];
	return [DateUtils localDateToGMTDate:currentLocalDate];
}

+ (NSDate *) localDateToGMTDate:(NSDate *)localDate {
 	NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone]; 
	NSTimeZone* destinationTimeZone= [NSTimeZone timeZoneWithAbbreviation:@"GMT"]; 
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:localDate]; 
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:localDate]; 
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset; 
	return [[NSDate alloc] initWithTimeInterval:interval sinceDate:localDate];
}

+ (NSDate *) GMTDateTolocalDate:(NSDate *)gmtDate {
	NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"]; 
 	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone]; 
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:gmtDate]; 
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:gmtDate]; 
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset; 
	return [[NSDate alloc] initWithTimeInterval:interval sinceDate:gmtDate];
}

// Photopon Date of Post - implementing GMT for accuracy //
+(NSString *) createdDateString:(NSDate *)createdDate
{
    //createdDate = [DateUtils GMTDateTolocalDate:createdDate];
    
    if ([[DateUtils currentGMTDate] minutesAfterDate:createdDate] > 59) {
        if ([[DateUtils currentGMTDate] hoursAfterDate:createdDate] > 23) {
            // display as "days ago"
            //NSLog(@"%i days ago", [[DateUtils GMTDateTolocalDate:createdDate] daysAgoAgainstMidnight]);
            return [[NSString alloc] initWithFormat:@"%i days ago", [[DateUtils currentGMTDate] daysAfterDate:createdDate]];
        }else {
            //NSLog(@"%i hours ago", [[DateUtils GMTDateTolocalDate:createdDate] hoursAfterDate:[DateUtils currentGMTDate]]);
            return [[NSString alloc] initWithFormat:@"%i hours ago", [[DateUtils currentGMTDate] hoursAfterDate:createdDate]];
        }
    }else {
        if ([[DateUtils currentGMTDate] minutesAfterDate:createdDate] < 1.0f) {
            return [[NSString alloc] initWithFormat:@"%i seconds ago", [createdDate seconds]];
        }        
        //NSLog(@"%i hours ago", [[DateUtils currentGMTDate] minutesAfterDate:[DateUtils GMTDateTolocalDate:createdDate]]);
        return [[NSString alloc] initWithFormat:@"%i minutes ago", [[DateUtils currentGMTDate] minutesAfterDate:createdDate]];
    }    
}

// Photopon Date of Expiration - implementing GMT for accuracy //
+(NSString *) expiresDateString:(NSDate *)expiresDate
{
    if ([[DateUtils localDateToGMTDate:[NSDate date]] minutesBeforeDate:expiresDate] > 59.0f) {
        if ([[DateUtils localDateToGMTDate:[NSDate date]] hoursBeforeDate:expiresDate]>23.0f) {
            // display as "days until"
            //NSLog(@"in %i days", [[DateUtils GMTDateTolocalDate:createdDate] daysAgoAgainstMidnight]);
            return [NSString stringWithFormat:@"in %i days", [[DateUtils currentGMTDate] daysBeforeDate:expiresDate]];
        }else {
            //NSLog(@"in %i hours", [[DateUtils GMTDateTolocalDate:createdDate] hoursBeforeDate:[DateUtils currentGMTDate]]);
            return [NSString stringWithFormat:@"in %i hours", [[DateUtils currentGMTDate] hoursBeforeDate:[DateUtils GMTDateTolocalDate:expiresDate]]];
        }
    }else {
        if ([[DateUtils localDateToGMTDate:[NSDate date]] minutesBeforeDate:expiresDate] < 1.0f) {
            return [NSString stringWithFormat:@"in %i seconds", [[DateUtils GMTDateTolocalDate:expiresDate] seconds]];
        }
        //NSLog(@"in %i hours", [[DateUtils currentGMTDate] minutesBeforeDate:[DateUtils GMTDateTolocalDate:expiresDate]]);
        return [NSString stringWithFormat:@"in %i minutes", [[DateUtils currentGMTDate] minutesBeforeDate:[DateUtils GMTDateTolocalDate:expiresDate]]];
    }
}


@end
