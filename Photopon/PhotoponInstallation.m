//
//  PhotoponInstallation.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponInstallation.h"

@implementation PhotoponInstallation

static PhotoponInstallation* current = nil;

+(PhotoponInstallation *)currentInstallation{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(!current){
        current = [[self alloc]init];
        //current = [[self alloc] initWithName:kInstallationClassName];
    }
    return current;
}

@end
