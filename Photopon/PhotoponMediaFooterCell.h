//
//  PhotoponMediaFooterCell.h
//  Photopon
//
//  Created by Brad McEvilly on 8/2/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponMediaFooterInfoView;

@interface PhotoponMediaFooterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet PhotoponMediaFooterInfoView *photoponMediaFooterInfoView;

+ (PhotoponMediaFooterCell *)photoponMediaFooterCell;

@end
