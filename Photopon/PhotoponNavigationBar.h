//
//  PhotoponNavigationBar.h
//  Photopon
//
//  Created by Bradford McEvilly on 4/28/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

@interface PhotoponNavigationBar : UINavigationBar
{
    UIImageView *navigationBarBackgroundImage;
    CGFloat backButtonCapWidth;
    IBOutlet UINavigationController* navigationController;
}

@property (nonatomic, retain) UIImageView *navigationBarBackgroundImage;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

-(void) setBackgroundWith:(UIImage*)backgroundImage;
-(void) clearBackground;
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;

@end