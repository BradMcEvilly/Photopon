//
//  UITableViewSwitchCell.m
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "UITableViewSwitchCell.h"

@implementation UITableViewSwitchCell
@synthesize textLabel, cellSwitch, viewForBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	self.viewForBackground = nil;
    self.textLabel = nil;
    self.cellSwitch = nil;
}


@end
