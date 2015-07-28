//
//  PhotoponAttributedHighlightTextCell.m
//  Photopon
//
//  Created by Brad McEvilly on 8/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponAttributedHighlightTextCell.h"

@interface PhotoponAttributedHighlightTextCell ()
@property (strong, nonatomic) IBOutlet AMAttributedHighlightLabel *contentLabel;
@end

@implementation PhotoponAttributedHighlightTextCell

@synthesize contentLabel;

#pragma mark - NSObject

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma - AMAttributedHighlightLabel Delegate methods

- (void)selectedMention:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];

}

- (void)selectedHashtag:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];
    
}

- (void)selectedLink:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];
    
}

@end
