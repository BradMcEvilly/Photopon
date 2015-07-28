//
//  PhotoponUITableViewCell.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/16/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//


#import "PhotoponUITableViewCell.h"
/*#import "PhotoponFeedItemTableViewCellController.h"
//#import "PhotoponMoreTableViewCellController.h"
#import "PhotoponCommentsTableViewCellController.h"
#import "PhotoponCouponsTableViewCellController.h"
#import "PhotoponAlertsTableViewCellController.h"
#import "PhotoponUsersTableViewCellController.h"
#import "PhotoponGlobalFeedTableViewCellController.m"
#import "PhotoponGlobalFeedPopularTableViewCellController.h"
#import "PhotoponFeedItemActivityTableViewCellController.h"

#import "PhotoponFeedItemsEmptyTableViewCellController.h"
*/
@implementation PhotoponUITableViewCell
/*
@synthesize photoponCommentsTableViewCellController = photoponCommentsTableViewCellController_;
@synthesize photoponMoreTableViewCellController = photoponMoreTableViewCellController_;
@synthesize photoponFeedItemTableViewCellController = photoponFeedItemTableViewCellController_;
@synthesize photoponCouponsTableViewCellController = photoponCouponsTableViewCellController_;
@synthesize photoponAlertsTableViewCellController = photoponAlertsTableViewCellController_;
@synthesize photoponUsersTableViewCellController = photoponUsersTableViewCellController_;
@synthesize photoponFeedItemActivityTableViewCellController = photoponFeedItemActivityTableViewCellController_;

@synthesize photoponGlobalFeedPopularTableViewCellController = photoponGlobalFeedPopularTableViewCellController_;

@synthesize globalFeedPopularTableViewController;

@synthesize supressDeleteButton;

@synthesize photoponFeedItemsEmptyTableViewCellController = photoponFeedItemsEmptyTableViewCellController_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.frame = photoponFeedItemCellFrame;
        //self.contentView.frame = photoponFeedItemCellFrame;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Recursively go up the view hierarchy to find our tableView
-(UITableView*)getTableView:(UIView*)theView
{
    if (!theView.superview)
        return nil;
    
    if ([theView.superview isKindOfClass:[UITableView class]])
        return (UITableView*)theView.superview;
    
    return [self getTableView:theView.superview];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // We suppress the Delete button by explicitly not calling
    // super's implementation
    if (supressDeleteButton)
    {
        // Reset the editing state of the table back to NO
        UITableView* tableView = [self getTableView:self];
        tableView.editing = NO;
    }
    else
        [super setEditing:editing animated:animated];
}

-(void)dealloc
{
    
}*/

@end
