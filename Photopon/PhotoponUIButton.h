//
//  PhotoponFeedItemThumbView.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/1/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"
//#import "PhotoponChild.h"

@class PhotoponImageView;

@protocol PhotoponUIButtonDelegate;

//@interface PhotoponUIButton : UIButton <PhotoponChild>
@interface PhotoponUIButton : UIButton

@property (nonatomic, assign) IBOutlet id <PhotoponUIButtonDelegate> delegate;

@property (nonatomic, strong) PhotoponImageView *imageView;

@property (nonatomic) NSInteger tagIndex;

@property (nonatomic, strong) NSNumber *tagNumber;

@property (nonatomic) float progress;

@property (nonatomic, strong) NSNumber *progressNumber;

@property (nonatomic, unsafe_unretained) NSInteger childIndex;
@property (nonatomic, strong) NSNumber *photoponUITypeNumber;

@property (nonatomic, strong) NSDictionary *dataObject;

//@property (nonatomic) PhotoponUIType photoponUIType;

- (id)initWithFrame:(CGRect)frame;
- (void)setPhotoponButtonImage:(UIImage *)newImage;
- (void)setPhotoponButtonBackgroundImage:(UIImage *)backgroundImage;

- (void)handleTouchUpInside:(id)sender;

//- (PhotoponUIType)childTagValue;
//- (void)childTag:(PhotoponUIType)tag;

@end


@protocol PhotoponUIButtonDelegate <NSObject>

@optional

-(void) buttonViewDidTouchUpInside:(id)sender;

@end
