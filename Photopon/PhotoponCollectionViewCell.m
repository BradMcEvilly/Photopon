//
//  PhotoponCollectionViewCell.m
//  Photopon
//
//  Created by Brad McEvilly on 7/12/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponCollectionViewCell.h"
#import "PhotoponUIImageView.h"

@implementation PhotoponCollectionViewCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[PhotoponUIImageView alloc] init];
        //[self.imageView setImageWithURLRequest:nil placeholderImage:nil success:nil failure:nil];
        [self.contentView addSubview:[self imageView]];
    
    }
    return self;
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
