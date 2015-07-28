//
//  PhotoponTagModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponTagModel.h"

@implementation PhotoponTagModel

+ (PhotoponTagModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }
    
    PhotoponTagModel* pModel = [[PhotoponTagModel alloc] init];
    
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponTagClassName forKey:kPhotoponEntityNameKey];
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
        [models addObject:[PhotoponTagModel modelWithDictionary:modelDict]];
    }
    return models;
}

-(NSString*)identifier{
    return (NSString*)[self.dictionary objectForKey:kPhotoponTagAttributesIdentifierKey];
}

-(NSString*)taggedObjectTitle{
    return (NSString*)[self.dictionary objectForKey:kPhotoponTagAttributesTaggedObjectTitleKey];
}

-(NSString*)taggedObjectID{
    return (NSString*)[self.dictionary objectForKey:kPhotoponTagAttributesTaggedObjectIdentifierKey];
}

-(NSString*)taggedObjectClassName{
    return (NSString*)[self.dictionary objectForKey:kPhotoponTagAttributesTaggedObjectClassNameKey];
}

-(NSDate*)addedTime{
    return [self.dictionary objectForKey:kPhotoponTagAttributesAddedTimeKey];
}


@end
