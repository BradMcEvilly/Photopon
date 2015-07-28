//
//  PhotoponNavigationBar.m
//  Photopon
//
//  Created by Bradford McEvilly on 4/28/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponNavigationBar.h"

#define MAX_BACK_BUTTON_WIDTH 160.0

@implementation PhotoponNavigationBar
@synthesize navigationBarBackgroundImage, navigationController;

// If we have a custom background image, then draw it, othwerwise call super and draw the standard nav bar
- (void)drawRect:(CGRect)rect
{
    
    if (navigationBarBackgroundImage)
        [navigationBarBackgroundImage.image drawInRect:rect];
    else
        [super drawRect:rect];
}

// Save the background image and call setNeedsDisplay to force a redraw
-(void) setBackgroundWith:(UIImage*)backgroundImage
{
    self.navigationBarBackgroundImage = [[UIImageView alloc] initWithFrame:self.frame];
    navigationBarBackgroundImage.image = backgroundImage;
    [self setNeedsDisplay];
}

// clear the background image and call setNeedsDisplay to force a redraw
-(void) clearBackground
{
    self.navigationBarBackgroundImage = nil;
    [self setNeedsDisplay];
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth
{
    // store the cap width for use later when we set the text
    backButtonCapWidth = capWidth;
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:self.topItem.title onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// Set the text on the custom back button
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton
{
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}

- (void)dealloc
{

}

@end