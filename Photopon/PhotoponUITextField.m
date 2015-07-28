//
//  PhotoponUITextField.m
//  Photopon
//
//  Created by Brad McEvilly on 8/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUITextField.h"

@implementation PhotoponUITextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
	return CGRectInset(bounds, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return CGRectInset(bounds, 5, 0);
}

- (void)drawRect:(CGRect)rect
{
    UIImage *textFieldBackground = [[UIImage imageNamed:@"PhotoponTextField.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 15.0, 5.0)];
    [textFieldBackground drawInRect:[self bounds]];
}

@end
