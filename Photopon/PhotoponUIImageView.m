//
//  PhotoponUIImageView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PhotoponUIImageView.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponUIImageView

@synthesize highlightView;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.highlightView.backgroundColor = [UIColor clearColor];
        self.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
        self.highlightView.layer.borderWidth = 1.0f;
        [self addSubview:self.highlightView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.highlightView.backgroundColor = [UIColor clearColor];
        self.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
        self.highlightView.layer.borderWidth = 1.0f;
        [self addSubview:self.highlightView];
    }
    return self;
}

- (void)layoutSubviews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.highlightView.frame = CGRectMake(1.0f, 1.0f, self.frame.size.width-2, self.frame.size.height-2);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
