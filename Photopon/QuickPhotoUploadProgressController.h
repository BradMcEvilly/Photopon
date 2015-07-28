//
//  QuickPhotoUploadProgressController.h
//  Photopon
//
//  Created by Bradford McEvilly on 5/16/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickPhotoUploadProgressController : UIViewController {
    
    IBOutlet UILabel *label;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *photoponProgressBar;
    
    CGFloat prog;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIView *photoponProgressBar;
@property (nonatomic) CGFloat prog;


@end
