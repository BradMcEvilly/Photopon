//
//  PhotoponCommentModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponCommentModel.h"
#import "PhotoponBaseModel.h"
#import "PhotoponUserModel.h"
#import "PhotoponConstants.h"
#import "PhotoponCommentModel.h"

@implementation PhotoponCommentModel

+ (PhotoponCommentModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }
    
    PhotoponCommentModel* pModel = [[PhotoponCommentModel alloc] init];
    
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponCommentClassName forKey:kPhotoponEntityNameKey];
    [pModel.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
    
    return pModel;
    
    /*
     PhotoponMediaModel* pModel = [[[self class] alloc] init];
     pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
     [pModel.dictionary setObject:kPhotoponClassName forKey:kPhotoponEntityNameKey];
     return pModel;
     */
    
    
    
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSDictionary* modelDict in dicts) {
        [models addObject:[PhotoponCommentModel modelWithDictionary:modelDict]];
    }
    return models;
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesIdentifierKey];
}
-(NSString*)content{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesContentKey];
}
-(NSString*)activityID{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesActivityIDKey];
}
-(NSString*)mediaID{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesMediaIDKey];
}

-(PhotoponUserModel*)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUserModel modelWithDictionary:(NSDictionary*)[self.dictionary objectForKey:kPhotoponCommentAttributesUserKey]];
}

-(NSString*)locationIdentifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesLocationIdentifierKey];
}

-(NSString*)locationLatitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesLocationLatitudeKey];
}

-(NSString*)locationLongitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCommentAttributesLocationLongitudeKey];
}
-(NSDate*)createdTime{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSDate*)[self.dictionary objectForKey:kPhotoponCommentAttributesCreatedTimeKey];
}

@end
