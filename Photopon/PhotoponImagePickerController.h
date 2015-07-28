//
//  PhotoponImagePickerController.h
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class PhotoponUIImagePickerController;
@class PhotoponNewPhotoponPickerController;

@interface PhotoponImagePickerController : UINavigationController<MBProgressHUDDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate, UINavigationBarDelegate>

//@property(nonatomic,strong) PhotoponUIImagePickerController *mediaUI;

//@property(nonatomic,strong) PhotoponNewPhotoponPickerController *photoPickerController;

- (id)initWithDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

@end
