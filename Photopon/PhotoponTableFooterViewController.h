//
//  PhotoponTableFooterViewController.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponTableFooterViewController : UIViewController
{
    IBOutlet UIImageView *imageViewWhite;
    IBOutlet UIImageView *imageViewGray;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic,strong) IBOutlet UIImageView *imageViewWhite;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewGray;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;

@end
