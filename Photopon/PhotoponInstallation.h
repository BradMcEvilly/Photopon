//
//  PhotoponInstallation.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel.h"

@interface PhotoponInstallation : PhotoponModel
    +(PhotoponInstallation *)currentInstallation;
@end
