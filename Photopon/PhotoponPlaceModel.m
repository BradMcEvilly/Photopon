//
//  PhotoponPlaceModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponPlaceModel.h"
#import "NSString+Helpers.h"
//#import "NSDictionary+SafeExpectations.h"


@implementation PhotoponPlaceModel

@synthesize dictionary;

static PhotoponPlaceModel* newDraftPlace = nil;

+ (PhotoponPlaceModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }* /
    
    if(![dict isKindOfClass:[NSDictionary class]])
        return nil;
    */
    
    
    
    PhotoponPlaceModel* pModel = [[PhotoponPlaceModel alloc] init];
    
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponPlaceClassName forKey:kPhotoponEntityNameKey];
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
        [models addObject:[PhotoponPlaceModel modelWithDictionary:modelDict]];
    }
    return models;
}

-(NSString*)identifier{
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesIdentifierKey];
}

-(NSString*)publicID{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesPublicIDKey];
}

-(NSString*)name{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesNameKey];
}

-(NSString*)addressFull{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesAddressFullKey];
}

-(NSString*)street{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesStreetKey];
}

-(NSString*)city{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesCityKey];
}

-(NSString*)state{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesStateKey];
}

-(NSString*)zip{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesZipKey];
}

-(NSString*)phone{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesPhoneKey];
}

-(NSString*)category{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesCategoryKey];
}

-(NSString*)imageUrl{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesImageURLKey];
}

-(NSString*)offerSourceImageURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *strBio = [[NSString alloc]initWithFormat:@"%@", self.bio];
    
    NSLog(@"------->        strBio BEFORE = %@", strBio);
    
    if (strBio.length > 0) {
        
        NSString *testStrBioParse = [strBio stringFromTagNamed:kPhotoponPlaceAttributesMetaOfferSourceImageURLKey];
        
        NSLog(@"------->        strBio AFTER = %@", testStrBioParse);
        
        return testStrBioParse; //[strBio stringFromTagNamed:kPhotoponPlaceAttributesMetaOfferSourceImageURLKey];
    }
    
    return self.bio;
}

-(NSString*)bio{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesBioKey];
}

-(NSString*)locationIdentifier{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesLocationIdentifierKey];
}

-(NSString*)locationLatitude{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesLocationLatitudeKey];
}

-(NSString*)locationLongitude{
    return (NSString*)[self.dictionary objectForKey:kPhotoponPlaceAttributesLocationLongitudeKey];
}

-(NSNumber*)rating{
    return [self.dictionary objectForKey:kPhotoponPlaceAttributesRatingKey];
 }

- (void) cachePlaceAttributes{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"cachePlaceAttributes 1");
    // make sure we have a dictionary and and image or something already went wrong
    if (!self.dictionary) {
        NSLog(@"cachePlaceAttributes 2");
        return;
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray *arr = ; // set value
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dictionary];
    [defaults setObject:data forKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
    
    [defaults synchronize];
    
    
    
    
    /*
    
    NSLog(@"cachePlaceAttributes 3");
    
    [[EGOCache globalCache] setObject:self.dictionary forKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
    
    NSLog(@"cachePlaceAttributes 4");
    
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)self.dictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
    
    NSLog(@"cachePlaceAttributes 5");
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"cachePlaceAttributes 6");
    */
}

+ (void)setNewPhotoponDraftPlace:(PhotoponPlaceModel *)place{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"setNewPhotoponDraftPlace 1");
    
    newDraftPlace = place;
    
    NSLog(@"setNewPhotoponDraftPlace 2");
    
    [newDraftPlace cachePlaceAttributes];
    
    NSLog(@"setNewPhotoponDraftPlace 3");
    
}

/**
 Creates an empty local post associated with blog
 */
+ (PhotoponPlaceModel *)newPhotoponDraftPlace{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraftPlace != nil)
        return newDraftPlace;
    
    newDraftPlace = nil;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
    NSMutableDictionary *newPhotoponDraftPlace = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    //NSMutableDictionary *newPhotoponDraftPlace = [(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponPlaceKey] mutableCopy];
    
    if(newPhotoponDraftPlace){
        // see if we have an image filepath
        
        NSString *newPhotoponDraftPlaceName = (NSString*)[newPhotoponDraftPlace objectForKey:kPhotoponPlaceAttributesNameKey];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            newPhotoponDraftPlaceName = %@", self, NSStringFromSelector(_cmd), newPhotoponDraftPlaceName);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        newDraftPlace = [PhotoponPlaceModel modelWithDictionary:newPhotoponDraftPlace];
        
    }else{
        
        //NSMutableDictionary *newPhotoponDraftCoupon = [(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey] mutableCopy];
        
        //if (newPhotoponDraftCoupon)
            //newDraftPlace = (PhotoponPlaceModel*)[newPhotoponDraftCoupon objectForKey:kPhotoponCouponAttributesPlaceKey];
    }
    
    return newDraftPlace;
    
}

+ (void)clearNewPhotoponDraftPlace{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraftPlace){
        newDraftPlace = nil;
        
        [[EGOCache globalCache] removeCacheForKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

@end
