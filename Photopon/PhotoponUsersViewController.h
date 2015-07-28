//
//  PhotoponUsersViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/12/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponQueryTableViewController.h"
#import "PhotoponUsersTableViewCell.h"


@interface PhotoponUsersViewController : PhotoponQueryTableViewController <PhotoponUsersTableViewCellDelegate>

- (void)shouldPresentAccountViewForUser:(PhotoponUserModel *)user;

@end
