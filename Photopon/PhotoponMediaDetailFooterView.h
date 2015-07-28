//
//  PhotoponMediaDetailFooterView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponUITextField;

@interface PhotoponMediaDetailFooterView : UIView

@property (nonatomic, strong) PhotoponUITextField *commentField;
@property (nonatomic) BOOL hideDropShadow;

+ (CGRect)rectForView;

@end