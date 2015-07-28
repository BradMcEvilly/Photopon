//
//  UITableViewTextFieldCell.m
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "UITableViewTextFieldCell.h"


@implementation UITableViewTextFieldCell
@synthesize textField;

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.textField = nil;
    //[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:self.bounds];
        self.textField.adjustsFontSizeToFitWidth = YES;
        self.textField.textColor = [UIColor blackColor];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.textAlignment = UITextAlignmentLeft;
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.textField.enabled = YES;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self addSubview:self.textField];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    CGRect frame;

    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17]];
    labelSize.width = ceil(labelSize.width/5) * 5; // Round to upper 5

    if (IS_IPAD) {
        frame = CGRectMake(labelSize.width + 50,
                           self.textLabel.frame.origin.y,
                           self.frame.size.width - labelSize.width,
                           self.textLabel.frame.size.height);
    } else {
        frame = CGRectMake(labelSize.width + 30,
                           self.textLabel.frame.origin.y,
                           self.frame.size.width - labelSize.width - 50,
                           self.textLabel.frame.size.height);
    }
    self.textField.frame = frame;
}

@end
