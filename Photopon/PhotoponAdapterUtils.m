//
//  PFAdapterUtils.m
//  ParseKit
//
//  Created by Denis Berton on 22/09/12.
//
//

#import "PhotoponAdapterUtils.h"
#import "PhotoponFile.h"
#import "PhotoponModel.h"
#import "PhotoponUserModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponModelManager.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponGeoPointModel.h"
#import "Photopon8CouponsModel.h"


@implementation PhotoponAdapterUtils

+(id)convertObjToNS:(id) obj{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if([obj isKindOfClass:[PhotoponFile class]])
        return ((PhotoponFile*)obj).name;
    if([obj isKindOfClass:[PhotoponUserModel class]] || [obj isKindOfClass:[PhotoponModel class]])
        return [((PhotoponModel*)obj).dkEntity entityId];
    if([obj isKindOfClass:[PhotoponGeoPointModel class]]){
		return [NSArray arrayWithObjects: [NSNumber numberWithDouble:((PhotoponGeoPointModel*)obj).longitude],
                          				  [NSNumber numberWithDouble: ((PhotoponGeoPointModel*)obj).latitude], nil];
	}
     */
    return obj;
}

+(id)convertObjToPhotopon:(id) obj{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if([obj isKindOfClass:[NSDictionary class]]){
		NSDictionary* entity = (NSDictionary*)obj;
		id pfObj = nil;
		if([[entity objectForKey:kPhotoponEntityNameKey] isEqualToString: kPhotoponUserClassName])
			pfObj = [PhotoponUserModel modelWithDictionary:entity];
		else if([[entity objectForKey:kPhotoponEntityNameKey] isEqualToString: kPhotoponMediaClassName])
            pfObj = [PhotoponMediaModel modelWithDictionary:entity];
        else if([[entity objectForKey:kPhotoponEntityNameKey] isEqualToString: kPhotoponCouponClassName])
            pfObj = [PhotoponCouponModel modelWithDictionary:entity];
        else if([[entity objectForKey:kPhotoponEntityNameKey] isEqualToString: kPhotoponPlaceClassName])
            pfObj = [PhotoponPlaceModel modelWithDictionary:entity];
        else
			pfObj = [PhotoponModel objectWithClassName:[entity objectForKey:kPhotoponEntityNameKey]];
        
		[pfObj setObject:[NSString stringWithFormat:@"%@_%@", [entity objectForKey:kPhotoponEntityNameKey], [entity objectForKey:kPhotoponModelIdentifierKey]] forKey:kPhotoponEntityIdentifierKey];
		[pfObj setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
		return pfObj;
	}
	else if([obj isKindOfClass:[NSArray class]]){
	    NSArray* arr = (NSArray*)obj;
	    return [PhotoponGeoPointModel geoPointWithLatitude:[(NSNumber*)arr[1] doubleValue] longitude:[(NSNumber*)arr[0] doubleValue]];
	}
    return obj;
}

+(id)convert8CouponsObjToPhotopon:(Photopon8CouponsModel*) obj{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //NSString *feed = (NSString *)response;
    // sanitize our 8coupons data
    //feed = [feed stringByReplacingOccurrencesOfString:@"[" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"]" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //NSArray *offers = (NSArray*)obj;
    
    /*
    NSMutableDictionary *photoponDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               [obj objectForKey:k8CouponsAPIReturnDataPostDateKey]
                                               nil];
    
    */
    
    if([obj isKindOfClass:[NSDictionary class]]){
        
        
        
        
        
        
    }
    
    
    
}

+(NSArray*)convert8CouponsArrayToPhotoponArray:(NSArray*) someArray{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *offers = someArray;
    
    
    
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (id el in someArray) {
		[newArray addObject: [self convert8CouponsObjToPhotopon:el]];
    }
    return newArray;
}

+(NSString*)sanitize8CouponsString:(NSString*)targetString includeSpaceChars:(BOOL)includeSpaceChars{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!targetString)
        return nil;
    
    if (targetString==NULL)
        return nil;
    
    @try {
        if (includeSpaceChars)
            targetString = [targetString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        
        targetString = [targetString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        targetString = [targetString stringByReplacingOccurrencesOfString:@")" withString:@""];
        targetString = [targetString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        targetString = [targetString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }
    @catch (NSException *exception) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            @catch (NSException *exception) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"error description%@", exception.description);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        targetString = kPhotoponNullFieldString;
        
    }
    @finally {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            @catch (NSException *exception) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    }
    
    return targetString;
}

+(NSString*)sanitizeRawJSONString:(NSString*)targetString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    targetString = [targetString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"]" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return targetString;
}

/*
 {
    "affiliate":    "yes",
    "name":         "'Odyssey&rsquo;s Shipwreck! Pirates & Treasure: The Exhibition'",
    "address":"226 W 44th St.",
    "address2":"",
    "storeID":"3431901",
    "chainID":null,
    "totalDealsInThisStore":"50",
    "homepage":"http:\/\/www.discoverytsx.com\/",
    "phone":"866.987.9692",
    "state":"NY",
    "city":"New York",
    "ZIP":"10036",
    "URL":"http:\/\/www.8coupons.com\/apiout\/showdeal\/deal\/10914179\/1857578\/aff",
    "storeURL":"http:\/\/www.8coupons.com\/discounts\/shipwreck-pirates-treasure-new-york-10036",
    "dealSource":"jdoqocy.com",
    "user":"Deals of the Day",
    "userID":"18381",
    "ID":"10914179",
    "dealTitle":"$15 -- Times Square: Hands-On Shipwreck Exhibit for Families",
    "disclaimer":"Vouchers may be redeemed now through Oct. 31, 2013. To redeem, bring a printed voucher to the Discovery Times Square box office. Limit 8 vouchers per person. Discounts reflect TSX Operating Co.'s current ticket prices. Full prices may differ on the day of the event. This deal cannot be combined with any other offers. Must be used in 1 visit. This is a date-specific event. All sales final. No refunds or exchanges.",
    "dealinfo":"Save more than 40% on tickets to \"Odyssey&rsquo;s Shipwreck! Pirates & Treasure: The Exhibition\" at Discovery Times Square   Tickets are $12-$15, regularly $21.69-$26.13, including all fees   Choose from adult, senior and child ticket prices   Valid for visits through Oct. 31",
    "expirationDate":"2013-08-06",
    "postDate":"2013-08-04 04:26:33",
    "showImage":"http:\/\/www.tzoo-img.com\/images\/tzoo.g.local.20628.80756.shipwreck.jpg",
    "showImageStandardBig":"http:\/\/www.8coupons.com\/image\/deal\/10914179\/featured",
    "showImageStandardSmall":"http:\/\/www.8coupons.com\/image\/deal\/10914179",
    "showLogo":"http:\/\/www.8coupons.com\/partners\/logo\/small\/TZOO.jpeg",
    "up":null,
    "down":null,
    "DealTypeID":"1",
    "categoryID":"2",
    "subcategoryID":"47",
    "lat":"40.7579",
    "lon":"-73.9875",
    "distance":"1.37725169301442",
    "dealOriginalPrice":"26",
    "dealPrice":"15",
    "dealSavings":"11",
    "dealDiscountPercent":"43"
 }
 */

+(NSArray*)convertArrayToNS:(NSArray*) array{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (id el in array) {
		[newArray addObject: [self convertObjToNS:el]];
    }
    return newArray;
}

+(NSArray*)convertArrayToPhotopon:(NSArray*) array{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (id el in array) {
		[newArray addObject: [self convertObjToPhotopon:el]];
    }
    return newArray;
}

@end
