//
//  PhotoponLoadMoreCell.h
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponLoadMoreCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *separatorImageTop;
@property (nonatomic, strong) UIImageView *separatorImageBottom;
@property (nonatomic, strong) UIImageView *loadMoreImageView;

@property (nonatomic, assign) BOOL hideSeparatorTop;
@property (nonatomic, assign) BOOL hideSeparatorBottom;

@property (nonatomic) CGFloat cellInsetWidth;

@end