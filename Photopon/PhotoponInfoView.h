//
//  PhotoponInfoView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/6/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponInfoView : UIView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

+ (PhotoponInfoView *)PhotoponInfoViewWithTitle:(NSString *)titleText message:(NSString *)messageText cancelButton:(NSString *)cancelText;

- (IBAction)handleCancelButtonTapped:(id)sender;
- (void)setTitle:(NSString *)titleText message:(NSString *)messageText cancelButton:(NSString *)cancelText;
- (void)showInView:(UIView *)view;

@end
