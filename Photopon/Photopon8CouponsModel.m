//
//  Photopon8CouponsModel.m
//  Photopon
//
//  Created by Brad McEvilly on 8/2/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "Photopon8CouponsModel.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponAdapterUtils.h"
#import "PhotoponUtility.h"
#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "NSString+Helpers.h"
#import "DateUtils.h"

@implementation Photopon8CouponsModel


/**
 API RESPONSE INFO:
 URL: http://api.8coupons.com/v1/getdeals?key=XYZ&zip=10022&mileradius=20&limit=500&userid=18381
 
 RETURN DATA OBJECT:
 
 "affiliate":"yes",
 "name":"Morning Star Farm",
 "address":"489 State Rt 94 S",
 "address2":"",
 "storeID":"3073650",
 "chainID":null,
 "totalDealsInThisStore":"1",
 "homepage":"",
 "phone":"973.579.1226",
 "state":"NJ",
 "city":"Newton",
 "ZIP":"07860",
 "URL":"http:\/\/www.8coupons.com\/apiout\/showdeal\/deal\/9701994\/1857578\/aff",
 "storeURL":"http:\/\/www.8coupons.com\/discounts\/morning-star-farm-newton-07860",
 "dealSource":"yelp.com",
 "user":"yelp",
 "userID":"733207",
 "ID":"9701994",
 "dealTitle":"$75 for $100 Certificate",
 "disclaimer":"",
 "dealinfo":"You get a voucher redeemable for $100 at Morning Star Farm. Print out your voucher, or redeem on your phone with the  Yelp app .",
 "expirationDate":"2013-03-02",
 "postDate":"2013-02-27 01:14:04",
 "showImage":"http:\/\/s3-media1.ak.yelpcdn.com\/bphoto\/wtcDCE1kgoROeehzNLxc5Q\/l.jpg",
 "showLogo":"http:\/\/www.8coupons.com\/partners\/logo\/small\/yelp.png",
 "up":null,
 "down":null,
 "DealTypeID":"1",
 "categoryID":"4",
 "subcategoryID":"69",
 "lat":"41.0279",
 "lon":"-74.8222",
 "distance":"3.03354048160047",
 "dealOriginalPrice":"100",
 "dealPrice":"75",
 "dealSavings":"25",
 "dealDiscountPercent":"25"
 */

+ (Photopon8CouponsModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /**
     ----------------------------------------------------
     1. VARIABLE DECLARATIONS
     ----------------------------------------------------
     */
    Photopon8CouponsModel* pModel;
    NSString *postDateRaw;
    NSString *expirationDateRaw;
    
    /**
     ----------------------------------------------------
     2. FILTERED INITIALIZATION / RESPONSE WRAPPING
     ----------------------------------------------------
     */
    pModel = [[Photopon8CouponsModel alloc] init];
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    postDateRaw = [[NSString alloc]
                   initWithFormat:@"%@",
                   (NSString*)[pModel.dictionary valueForKey:k8CouponsAPIReturnDataPostDateKey]];
    expirationDateRaw = [[NSString alloc]
                         initWithFormat:@"%@",
                         (NSString*)[pModel.dictionary valueForKey:k8CouponsAPIReturnDataExpirationDateKey]];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"                        postDateRaw = %@", postDateRaw);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"                        expirationDateRaw = %@", expirationDateRaw);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![postDateRaw isEqualToString:kPhotoponNullFieldString]){
        
        NSString *cleanPostDateStr = [[NSString alloc] initWithFormat:@"%@", postDateRaw];
        [pModel.dictionary setObject:cleanPostDateStr forKey:k8CouponsAPIReturnDataPostDateKey];
    }else{
        [pModel.dictionary setObject:postDateRaw forKey:k8CouponsAPIReturnDataPostDateKey];
    }
    
    if (![expirationDateRaw isEqualToString:kPhotoponNullFieldString]){
        NSString *cleanExpDateStr = [[NSString alloc] initWithFormat:@"%@", expirationDateRaw];
        [pModel.dictionary setObject:cleanExpDateStr forKey:k8CouponsAPIReturnDataExpirationDateKey];
    }else{
        [pModel.dictionary setObject:expirationDateRaw forKey:k8CouponsAPIReturnDataExpirationDateKey];
        
    }
    
    //[pModel.dictionary setObject:[NSDate date] forKey:expirationDateRaw];
    
    
    [pModel.dictionary setObject:kPhotopon8CouponsClassName forKey:kPhotoponEntityNameKey];
    [pModel.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
    [pModel.dictionary setObject:[NSNumber numberWithUnsignedInteger:PhotoponCouponSourceType8Coupons] forKey:kPhotoponCouponAttributesCouponTypeKey];
    
    /**
     ----------------------------------------------------
     3. INIT PLACE DICTIONARY
     ----------------------------------------------------
     */
    NSMutableDictionary *placeModel = [[NSMutableDictionary alloc] init];
    
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataAddressKey] forKey:kPhotoponPlaceAttributesStreetKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataCityKey] forKey:kPhotoponPlaceAttributesCityKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataStateKey] forKey:kPhotoponPlaceAttributesStateKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataZIPKey] forKey:kPhotoponPlaceAttributesZipKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataNameKey] forKey:kPhotoponPlaceAttributesNameKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataLatitudeKey] forKey:kPhotoponPlaceAttributesLocationLatitudeKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataLongitudeKey] forKey:kPhotoponPlaceAttributesLocationLongitudeKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataPhoneKey] forKey:kPhotoponPlaceAttributesPhoneKey];
    [placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataHomepageKey] forKey:kPhotoponPlaceAttributesURLKey];
    //[placeModel setObject:[dict objectForKey:k8CouponsAPIReturnDataIDKey] forKey:kPhotoponModelIdentifierKey];
    [pModel.dictionary setObject:placeModel forKey:kPhotoponCouponAttributesPlaceKey];
    
    [pModel deriveOfferValue];
    
    return pModel;
}

+ (NSMutableDictionary*)couponModelWith8CouponsDictionary:(NSMutableDictionary*)dict{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *dictCoupon = [[NSMutableDictionary alloc] init];
    
    Photopon8CouponsModel *mod = [Photopon8CouponsModel modelWithDictionary:dict];
    
    //[dictCoupon setObject:mod.title forKey:kPhotoponCouponAttributesDetailsKey];
    
    NSMutableDictionary *placeDict = [mod.dictionary objectForKey:kPhotoponCouponAttributesPlaceKey];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"-------->                mod.showLogo = %@", mod.showLogo);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // setup place bio (bio is actually a set of meta data wrapped in tags)
    NSString *srcString = [NSString stringWithFormat:@"%@", mod.showLogo];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"-------->                srcString = %@", srcString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *bio = [[NSString alloc] initWithFormat:@"%@", [srcString wrapInTagNamed:kPhotoponPlaceAttributesMetaOfferSourceImageURLKey]];
    
    //NSString *bio = [NSString stringWithFormat:@"%@", mod.showLogo];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"-------->                bio = %@", bio);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [placeDict setObject:bio forKey:kPhotoponPlaceAttributesBioKey];
    
    
    
    if (mod.terms)
        [dictCoupon setObject:mod.terms forKey:kPhotoponCouponAttributesTermsKey];
    if (mod.details)
        [dictCoupon setObject:mod.details forKey:kPhotoponCouponAttributesDetailsKey];
    if (mod.instructions)
        [dictCoupon setObject:mod.instructions forKey:kPhotoponCouponAttributesInstructionsKey];
    if (mod.start)
        [dictCoupon setObject:mod.start forKey:kPhotoponCouponAttributesStartKey];
    if (mod.startString)
        [dictCoupon setObject:mod.startString forKey:kPhotoponCouponAttributesStartStringKey];
    if (mod.expiration)
        [dictCoupon setObject: mod.expirationString forKey:kPhotoponCouponAttributesExpirationKey];
    if (mod.expirationString)
        [dictCoupon setObject:mod.expirationString forKey:kPhotoponCouponAttributesExpirationStringKey];
    if (mod.expirationTextString)
        [dictCoupon setObject:mod.expirationTextString forKey:kPhotoponCouponAttributesExpirationTextStringKey];
    if ([mod.dictionary objectForKey:kPhotoponCouponAttributesPlaceKey])
        [dictCoupon setObject:[mod.dictionary objectForKey:kPhotoponCouponAttributesPlaceKey] forKey:kPhotoponCouponAttributesPlaceKey];
    if (mod.couponType)
        [dictCoupon setObject:mod.couponType forKey:kPhotoponCouponAttributesCouponTypeKey];
    if (mod.couponURL)
        [dictCoupon setObject:mod.couponURL forKey:kPhotoponCouponAttributesCouponURLKey];
    if (mod.value)
        [dictCoupon setObject:mod.value forKey:kPhotoponCouponAttributesValueKey];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"-------->                mod.place.offerSourceImageURL = %@", mod.place.offerSourceImageURL);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //if (mod.identifier)
        //[dictCoupon setObject:mod.identifier forKey:kPhotoponModelIdentifierKey];
    
    
    return (NSMutableDictionary*)dictCoupon;
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSDictionary* modelDict in dicts) {
        [models addObject:[Photopon8CouponsModel modelWithDictionary:modelDict]];
    }
    return models;
}

-(void)sanitize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:self.dictionary];
    
        for(id key in self.dictionary) {
            
            id value = [self.dictionary objectForKey:key];
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            // modifying dictionary properties while iterating through same dictionary causes crash
            id newDictValue = [value copy];
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"|||||||-------->        PRE-SANITIZED value = %@", value);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            if([newDictValue isKindOfClass:[NSString class]]){
                
                newDictValue = [PhotoponAdapterUtils sanitize8CouponsString:value includeSpaceChars:(key == k8CouponsAPIReturnDataURLKey || key == k8CouponsAPIReturnDataShowImageStandardBigKey || key == k8CouponsAPIReturnDataShowImageStandardSmallKey || key == k8CouponsAPIReturnDataShowImageStandardBigKey || key == k8CouponsAPIReturnDataShowLogoKey || key == k8CouponsAPIReturnDataShowImageKey || key == k8CouponsAPIReturnDataHomepageKey)];
            }
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"|||||||-------->        POST-SANITIZED value = %@", value);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
            if (key==k8CouponsAPIReturnDataExpirationDateKey || key==k8CouponsAPIReturnDataPostDateKey) {
            
                if (![newDictValue isEqualToString:kPhotoponNullFieldString]) {
                    // sanitize - change start date format for mysql
                    NSDate *newDateObj = [NSDate dateFromString:value withFormat:[NSDate dateFormatString]];
                    newDictValue = [[NSString alloc] initWithFormat:@"%@", [newDateObj stringWithFormat:[NSDate dbFormatString]]];
                }
            }
            
            
            @try {
                
                if (newDictValue) {
                    [newDict setObject:newDictValue forKey:key];
                }
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //
            }
            
            
            
        }
    
    self.dictionary = [[NSMutableDictionary alloc] initWithDictionary:newDict];;
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", @""];
    //return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataIDKey];
}

-(NSString*)title{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealTitleKey];
}

-(NSString*)details{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealTitleKey];
}

-(NSString*)terms{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDisclaimerKey];
}

-(NSString*)instructions{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDisclaimerKey];
}

-(NSString*)value{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponCouponAttributesValueKey];
}

-(void)deriveOfferValue {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *sanitizedContentString;
    
    NSString *offerValue;
    
    if (self.dealDiscountPercent){
        
        sanitizedContentString = [PhotoponAdapterUtils sanitize8CouponsString:self.dealDiscountPercent includeSpaceChars:NO];
        
        if (![sanitizedContentString isEqualToString:kPhotoponNullFieldString]) {
            
            offerValue = [[NSString alloc] initWithFormat:@"%@%@", sanitizedContentString, @"%"];
            [self.dictionary setObject:sanitizedContentString forKey:k8CouponsAPIReturnDataDealDiscountPercentKey];
            [self.dictionary setObject:offerValue forKey:kPhotoponCouponAttributesValueKey];//TitleKey];
            
            return;
        }
        
    }
    if (self.dealSavings){
        sanitizedContentString = [PhotoponAdapterUtils sanitize8CouponsString:self.dealDiscountPercent includeSpaceChars:NO];
        
        if (![sanitizedContentString isEqualToString:kPhotoponNullFieldString]) {
            
            offerValue = [[NSString alloc] initWithFormat:@"%@%@", @"$", sanitizedContentString];
            [self.dictionary setObject:sanitizedContentString forKey:k8CouponsAPIReturnDataDealSavingsKey];
            [self.dictionary setObject:offerValue forKey:kPhotoponCouponAttributesValueKey];//TitleKey];
            
            return;
        }
    }
    if (self.title){
        
        sanitizedContentString = [[NSString alloc] initWithFormat:@"%@", [PhotoponAdapterUtils sanitize8CouponsString:self.title includeSpaceChars:NO]];
        
        if (![sanitizedContentString isEqualToString:kPhotoponNullFieldString]) {
            
            [self.dictionary setObject:sanitizedContentString forKey:k8CouponsAPIReturnDataDealTitleKey];
            offerValue = [[NSString alloc] initWithFormat:@"%@", [PhotoponCouponModel extractOfferValueFromOfferContent:sanitizedContentString]];
            [self.dictionary setObject:offerValue forKey:kPhotoponCouponAttributesValueKey];//TitleKey];
            
            return;
        }
    }
    
    [self.dictionary setObject:[[NSString alloc] initWithFormat:@"%@", @"<null>"] forKey:kPhotoponCouponAttributesValueKey];    //TitleKey];
    
}

-(NSDate*)start{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [PhotoponUtility photopon8CouponsDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]] = %@", [PhotoponUtility photopon8CouponsDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUtility photopon8CouponsDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]];
}

-(NSString*)startString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [PhotoponUtility photoponDateStringWith8CouponsDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]] = %@", [PhotoponUtility photoponDateStringWith8CouponsDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUtility photoponDateStringWith8CouponsDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataPostDateKey]];
}

-(NSDate*)expiration{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    return [PhotoponUtility photopon8CouponsExpirationDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]];
}

-(NSString*)expirationString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[PhotoponUtility photopon8CouponsExpirationDateWithString:]
    
    //return [[PhotoponUtility photopon8CouponsExpirationDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]] stringWithFormat: k8CouponsAPIReturnDataExpirationDateFormat];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [PhotoponUtility photoponDateStringWith8CouponsExpirationDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]] = %@", [PhotoponUtility photoponDateStringWith8CouponsExpirationDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUtility photoponDateStringWith8CouponsExpirationDateString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]];
    
}

-(NSString*)expirationTextString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    return self.expirationString;//[[PhotoponUtility photopon8CouponsExpirationDateWithString:(NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataExpirationDateKey]] stringWithFormat:kPhotoponDateFormat];
}

-(PhotoponPlaceModel*)place{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponPlaceModel modelWithDictionary:(NSDictionary*)[self.dictionary objectForKey:kPhotoponCouponAttributesPlaceKey]];
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
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataURLKey];
}

-(NSString*)dealOriginalPrice{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealOriginalPriceKey];
}

-(NSString*)dealPrice{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealPriceKey];
}

-(NSString*)dealSavings{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealSavingsKey];
}

-(NSString*)dealDiscountPercent{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealDiscountPercentKey];
}

-(NSString*)dealSource{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDealSourceKey];
}

-(NSString*)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataUserKey];
}

-(NSString*)userID{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataUserIDKey];
}

-(NSString*)showLogo{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataShowLogoKey];
}

-(NSString*)showImage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataShowImageKey];
}

-(NSString*)showImageStandardBig{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataShowImageStandardBigKey];
}

-(NSString*)showImageStandardSmall{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataShowImageStandardSmallKey];
}





+(NSString*)username{ // obsolete
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return @"";
}

+(NSString*)password{ // obsolete
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return @"";
}

+(NSString*)method{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", k8CouponsAPIMethodName];
}

+(NSString*)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", k8CouponsAPIParamsAPIKey];
}

+(NSString*)lat{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%3.6f", [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponLatitude]];
}

+(NSString*)lon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%3.6f", [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponLongitude]];
}

-(NSString*)distance{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%@", (NSString*)[self.dictionary objectForKey:k8CouponsAPIReturnDataDistanceKey]];
    
    //return [[NSString alloc] initWithFormat:@"%3.1f", [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponLatitude]];
}

+(NSString*)radius{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%i", k8CouponsAPIParamsMileRadius];
}

+(NSString*)limit{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%i", k8CouponsAPIParamsLimit];
}

+(NSString*)baseUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", k8CouponsAPIBaseUrl];
}

+(NSString*)endpointUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", k8CouponsAPIEndpointUrl];
}

+(NSString*)methodEndpointUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@%@", k8CouponsAPIEndpointUrl, k8CouponsAPIMethodName];
}

+(NSString*)fullUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // method, key, lat, lon, radius, limit
    return [[NSString alloc] initWithFormat:k8CouponsAPIFullUrl,
            [Photopon8CouponsModel method],
            [Photopon8CouponsModel key],
            [Photopon8CouponsModel lat],
            [Photopon8CouponsModel lon],
            [Photopon8CouponsModel radius],
            [Photopon8CouponsModel limit]];
}

+(NSDictionary*)params{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [Photopon8CouponsModel key], k8CouponsAPIParamsKeyNameKey,
            [Photopon8CouponsModel lat], k8CouponsAPIParamsLatitudeNameKey,
            [Photopon8CouponsModel lon], k8CouponsAPIParamsLongitudeNameKey,
            [Photopon8CouponsModel radius], k8CouponsAPIParamsRadiusNameKey,
            [Photopon8CouponsModel limit], k8CouponsAPIParamsLimitNameKey, nil];
}



@end
