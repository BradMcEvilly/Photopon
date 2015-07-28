//
//  PhotoponNewPhotoponShareViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoponQueryTableViewController.h"
#import "PhotoponNewPhotoponShareHeaderView.h"

@class PhotoponMediaModel;

typedef void (^PhotoponShareCompletionBlock)(PhotoponMediaModel *photoponMediaModel);

@interface PhotoponNewPhotoponShareViewController : PhotoponQueryTableViewController <PhotoponNewPhotoponShareHeaderViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate>{
    
    PhotoponMediaModel *photoponMediaModel;
    
    
    
    
}

@property (nonatomic, strong) IBOutlet UIImage *photoImageView;
//@property (nonatomic, strong) IBOutlet UITextField *titleTextField;

//@property (nonatomic, strong) IBOutlet UITextView *contentTextView;

@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;

@property (nonatomic, strong) UIImage *photoponImage;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *photoponToolBarLabel;
@property (nonatomic, strong) IBOutlet UIView *photoponToolBarView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetake;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnTagCoupon;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnNext;

@property (nonatomic, strong) IBOutlet NSArray *captions;

@property (nonatomic, strong) PhotoponNewPhotoponShareHeaderView *photoponNewPhotoponShareHeaderView;

/**
 @param completionBlock Called when a coupon has been tagged or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithCompletionBlock:(PhotoponShareCompletionBlock)completionBlock;

- (IBAction)photoponBtnRetakeHandler:(id)sender;
- (IBAction)photoponBtnTagCouponHandler:(id)sender;
- (IBAction)photoponBtnNextHandler:(id)sender;

@end