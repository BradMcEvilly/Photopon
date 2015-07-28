//
//  PhotoponCouponModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponCouponModel.h"
#import "PhotoponPlaceModel.h"

@implementation PhotoponCouponModel

static PhotoponCouponModel* newDraftCoupon = nil;

+ (PhotoponCouponModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }* /
    
    if(![dict isKindOfClass:[NSDictionary class]])
        return nil;
    */
    
    PhotoponCouponModel* pModel = [[PhotoponCouponModel alloc] init];
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    if ([pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationKey]) {
        
        if (![pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationStringKey] || ([(NSString*)[pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationStringKey] length]==0)) {
            [pModel.dictionary setObject:[[NSString alloc] initWithFormat:@"%@", [pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationKey]] forKey:kPhotoponCouponAttributesExpirationStringKey];
        }
        
        // CALCULATE & SET EXPIRATION DATE DISPLAY TEXT ONLY ONCE
        if (![pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationTextStringKey] || ([(NSString*)[pModel.dictionary objectForKey:kPhotoponCouponAttributesExpirationTextStringKey] length]==0)) {
            if ([pModel.expirationString isEqualToString:[PhotoponUtility photoponDateStringWith8CouponsDateString:kPhotoponNullDBDateFieldString]]) {
                [pModel.dictionary setObject:[[NSString alloc] initWithFormat:@"%@", @"N/A"] forKey:kPhotoponCouponAttributesExpirationTextStringKey];
            }else{
                [pModel.dictionary setObject:[[NSString alloc] initWithFormat:@"%@", [pModel.expiration stringWithFormat:kPhotoponDateTextFormat]] forKey:kPhotoponCouponAttributesExpirationTextStringKey];
            }
        }
    }
    
    
    [pModel.dictionary setObject:kPhotoponCouponClassName forKey:kPhotoponEntityNameKey];
    [pModel.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
    
    return pModel;
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSDictionary* modelDict in dicts) {
        [models addObject:[PhotoponCouponModel modelWithDictionary:modelDict]];
    }
    return models;
}

+ (NSString *)extractOfferValueFromOfferContent:(NSString *)offerContent{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *offerValue = [[NSString alloc] init];
    
    if (!offerContent || offerContent.length==0)
        return @"<null>";
    
    offerValue = nil;
    NSError *errorFREE = NULL;
    NSRegularExpression *regexFREE = [NSRegularExpression
                                      regularExpressionWithPattern:@"\\b(f)(r)(e)(e)\\b"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&errorFREE];
    
    NSTextCheckingResult *matchFREE = [regexFREE
                                       firstMatchInString:offerContent
                                       options:0
                                       range:NSMakeRange(0, [offerContent length])];
    if (matchFREE) {
        //offerValue = NSLocalizedString(@"FREE", @"");
        offerValue = @"FREE";
    }else{
        NSError *errorPERCENT = NULL;
        NSRegularExpression *regexPERCENT = [NSRegularExpression
                                             regularExpressionWithPattern:@"\\b[0-9]*\\s*(%)+\\s*[0-9]*\\b"
                                             options:NSRegularExpressionCaseInsensitive
                                             error:&errorPERCENT];
        NSTextCheckingResult *matchPERCENT = [regexPERCENT
                                              firstMatchInString:offerContent
                                              options:0
                                              range:NSMakeRange(0, [offerContent length])];
        if (matchPERCENT) {
            offerContent = [offerContent substringWithRange:[matchPERCENT rangeAtIndex:0]];
        }else{
            NSError *errorDOLLAR = NULL;
            NSRegularExpression *regexDOLLAR = [NSRegularExpression
                                                regularExpressionWithPattern:@"(\\$[0-9]+)"
                                                options:NSRegularExpressionCaseInsensitive
                                                error:&errorDOLLAR];
            NSTextCheckingResult *matchDOLLAR = [regexDOLLAR
                                                 firstMatchInString:offerContent
                                                 options:0
                                                 range:NSMakeRange(0, [offerContent length])];
            if (matchDOLLAR)
                offerValue = [offerContent substringWithRange:[matchDOLLAR rangeAtIndex:0]];
        }
    }
    if (offerValue == nil) {
        offerValue = @"SAVE";
    }
    return offerValue;
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesIdentifierKey];
}

-(NSString*)details{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesDetailsKey];
}

-(NSString*)terms{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesTermsKey];
}

-(NSString*)instructions{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesInstructionsKey];
}

-(NSDate*)start{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCouponAttributesStartKey];
}

-(NSString*)startString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesStartStringKey];
}

-(NSDate*)expiration{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUtility photoponDateWithString:(NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesExpirationKey]];
    
    //return [PhotoponUtility photoponDateWithString:(NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesExpirationStringKey]];
    
    //return [self.dictionary objectForKey:kPhotoponCouponAttributesExpirationKey];
}

-(NSString*)expirationString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesExpirationStringKey];
}

-(NSString*)expirationTextString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesExpirationTextStringKey];
}


-(PhotoponPlaceModel*)place{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponPlaceModel modelWithDictionary:(NSMutableDictionary*)[self.dictionary objectForKey:kPhotoponCouponAttributesPlaceKey]];
}

-(NSString*)couponType{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesCouponTypeKey];
}

-(NSString*)couponURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesCouponURLKey];
}

-(NSString*)value{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesValueKey];
}

- (void) cacheCouponAttributes{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // make sure we have a dictionary and and image or something already went wrong
    if (!self.dictionary) {
        NSLog(@"cacheCouponAttributes 0-1");
        return;
    }
    
    NSLog(@"cacheCouponAttributes 0-2");
    
    PhotoponPlaceModel *cPlace = self.place;
    
    NSLog(@"cacheCouponAttributes 0-3");
    
    if (cPlace) {
        
        NSLog(@"cacheCouponAttributes 1");
        
        [PhotoponPlaceModel setNewPhotoponDraftPlace:cPlace];
        
        NSLog(@"cacheCouponAttributes 2");
        
        [self.dictionary removeObjectForKey:kPhotoponCouponAttributesPlaceKey];
        
        NSLog(@"cacheCouponAttributes 3");
        
        [[EGOCache globalCache] setObject:newDraftCoupon.dictionary forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheCouponAttributes 4");
        
        [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheCouponAttributes 5");
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"cacheCouponAttributes 6");
        
        [self.dictionary setObject:cPlace forKey:kPhotoponCouponAttributesPlaceKey];
        
        NSLog(@"cacheCouponAttributes 7");
        
    }else{
        
        NSLog(@"cacheCouponAttributes 8");
        
        [[EGOCache globalCache] setObject:newDraftCoupon.dictionary forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheCouponAttributes 9");
        
        [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheCouponAttributes 10");
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"cacheCouponAttributes 11");
    }
    
}

+ (void)setNewPhotoponDraftCoupon:(PhotoponCouponModel *)coupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"setNewPhotoponDraftCoupon 1");
    
    newDraftCoupon = coupon;
    
    NSLog(@"setNewPhotoponDraftCoupon 2");
    
    [newDraftCoupon cacheCouponAttributes];
}

/**
 Creates an empty local post associated with blog
 */
+ (PhotoponCouponModel *)newPhotoponDraftCoupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraftCoupon != nil)
        return newDraftCoupon;
    
    newDraftCoupon = nil;
    
    //NSMutableDictionary *newPhotoponDraftCoupon = [(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey] mutableCopy];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
    NSMutableDictionary *newPhotoponDraftCoupon = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    
    if(newPhotoponDraftCoupon){
        // see if we have an image filepath
        
        NSString *newPhotoponDraftCouponDetails = (NSString*)[newPhotoponDraftCoupon objectForKey:kPhotoponCouponAttributesDetailsKey];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            newPhotoponDraftCouponDetails = %@", self, NSStringFromSelector(_cmd), newPhotoponDraftCouponDetails);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        PhotoponPlaceModel *pModel = [PhotoponPlaceModel newPhotoponDraftPlace];
        
        if (pModel) {
            [newPhotoponDraftCoupon setObject:pModel forKey:kPhotoponCouponAttributesPlaceKey];
        }
        
        newDraftCoupon = [PhotoponCouponModel modelWithDictionary:newPhotoponDraftCoupon];
        
        
        //newDraftPlace = [PhotoponPlaceModel modelWithDictionary:newPhotoponDraftCoupon];
        
    }else{
        
        
        
        NSMutableDictionary *newPhotoponDraftMedia = [(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponMediaKey] mutableCopy];
        
        if (newPhotoponDraftMedia)
            newDraftCoupon = (PhotoponCouponModel*)[newPhotoponDraftMedia objectForKey:kPhotoponMediaAttributesCouponKey];
    }
    
    return newDraftCoupon;
    
}

+ (void)clearNewPhotoponDraftCoupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraftCoupon){
        newDraftCoupon = nil;
        
        [[EGOCache globalCache] removeCacheForKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [PhotoponPlaceModel clearNewPhotoponDraftPlace];
        
    }
    
}

@end
