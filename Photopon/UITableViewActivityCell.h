//
//  UITableViewActivityCell.h
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewActivityCell : UITableViewCell {
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UILabel *textLabel;
	IBOutlet UIView *viewForBackground;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIView *viewForBackground;

@end
