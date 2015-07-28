//
//  PhotoponSettingsButtonItem.m
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponSettingsButtonItem.h"

@implementation PhotoponSettingsButtonItem
#pragma mark - Initialization

- (id)initWithTarget:(id)target action:(SEL)action {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self = [super initWithCustomView:settingsButton];
    if (self) {
        //[settingsButton setBackgroundImage:[UIImage imageNamed:@"PhotoponNavBarSettings.png"] forState:UIControlStateNormal];
        [settingsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setFrame:CGRectMake(0.0f, 0.0f, 39.0f, 30.0f)];
        [settingsButton setImage:[UIImage imageNamed:@"PhotoponNavBarSettings.png"] forState:UIControlStateNormal];
        [settingsButton setImage:[UIImage imageNamed:@"PhotoponNavBarSettings.png"] forState:UIControlStateHighlighted];
    }
    
    
    return self;
}
@end
