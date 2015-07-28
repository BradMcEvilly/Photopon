//
//  UITableViewSwitchCell.h
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewSwitchCell : UITableViewCell {
}

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UISwitch *cellSwitch;
@property (nonatomic, retain) IBOutlet UIView *viewForBackground;

@end
