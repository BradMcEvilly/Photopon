//
//  PhotoponExploreViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponQueryTableViewController.h"

@interface PhotoponExploreViewController : PhotoponQueryTableViewController <UITableViewDelegate, UITableViewDataSource>











- (NSMutableArray*) featuredUsersArray;

@end
