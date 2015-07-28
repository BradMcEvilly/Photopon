//
//  PFAdapterUtils.h
//  ParseKit
//
//  Created by Denis Berton on 22/09/12.
//
//

#import <Foundation/Foundation.h>


@interface PhotoponAdapterUtils : NSObject
    
+(id)convertObjToPhotopon:(id) obj;

+(id)convertObjToNS:(id) obj;

+(NSArray*)convertArrayToPhotopon:(NSArray*) array;

+(NSArray*)convertArrayToNS:(NSArray*) array;

+(NSArray*)convert8CouponsArrayToPhotoponArray:(NSArray*) someArray;

+(NSString*)sanitize8CouponsString:(NSString*)targetString includeSpaceChars:(BOOL)includeSpaceChars;

+(NSString*)sanitizeRawJSONString:(NSString*)targetString;

@end
