//
//  PhotoponMediaDetailFooterView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaDetailFooterView.h"
#import "PhotoponUtility.h"
#import "PhotoponUITextField.h"

@interface PhotoponMediaDetailFooterView ()
@property (nonatomic, strong) UIView *mainView;
@end

@implementation PhotoponMediaDetailFooterView

@synthesize commentField;
@synthesize mainView;
@synthesize hideDropShadow;

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake( 6.0f, 0.0f, 309.0f, 51.0f)];
        mainView.backgroundColor = [UIColor whiteColor];// colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]];
        [self addSubview:mainView];
        
        UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponIconAddComment.png"]];
        messageIcon.frame = CGRectMake( 9.0f, 17.0f, 19.0f, 17.0f);
        [mainView addSubview:messageIcon];
        
        //UIImageView *commentBox = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"PhotoponBackgroundTextfieldComment.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f)]];
        //commentBox.frame = CGRectMake(35.0f, 8.0f, 237.0f, 35.0f);
        //[mainView addSubview:commentBox];
        
        commentField = [[PhotoponUITextField alloc] initWithFrame:CGRectMake( 40.0f, 10.0f, 227.0f, 31.0f)];
        commentField.font = [UIFont systemFontOfSize:14.0f];
        commentField.placeholder = kPhotoponPlaceholderCommentField;
        
        commentField.returnKeyType = UIReturnKeySend;
        commentField.textColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [commentField setValue:TEXT_FIELD_PLACEHOLDER_TEXT_COLOR forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [mainView addSubview:commentField];
    }
    return self;
}


#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    
    if (!hideDropShadow) {
        [PhotoponUtility drawSideAndBottomDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - PAPPhotoDetailsFooterView

+ (CGRect)rectForView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 69.0f);
}

@end