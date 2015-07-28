//
//  PhotoponBaseUIViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponBaseUIViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIImageView *photoponBackgroundImageView;
    UIImage *photoponBackgroundImage;
    NSString *photoponBackgroundImageNameString;
}

@property(nonatomic, strong) IBOutlet UIImageView *photoponBackgroundImageView;
@property(nonatomic, strong) UIImage *photoponBackgroundImage;
@property(nonatomic, strong) NSString *photoponBackgroundImageNameString;

-(void) showToolTipImageName:(NSString*)imageName;



@end
