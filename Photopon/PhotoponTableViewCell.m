// 
//  PhotoponTableViewCell.m
//  Photopon
//
//  Created by Bradford McEvilly on 5/31/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponTableViewCell.h"
#import "PhotoponUIImageView.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponTableViewCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView = [[PhotoponUIImageView alloc] init];
        //[self.imageView setImageWithURLRequest:nil placeholderImage:nil success:nil failure:nil];
        [self.contentView addSubview:[self imageView]];
    }
    
    return self;
}


@end

