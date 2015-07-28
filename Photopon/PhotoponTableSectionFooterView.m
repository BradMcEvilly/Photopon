//
//  PhotoponTableSectionFooterView.m
//  Photopon
//
//  Created by Brad McEvilly on 4/15/13.
//
//

#import "PhotoponTableSectionFooterView.h"

@implementation PhotoponTableSectionFooterView

@synthesize footerTitle;

- (id)initWithFrame:(CGRect)frame {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ((self = [super initWithFrame:frame])) {
        
        // create frame with padding
        CGRect labelFrame = CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 16);
        
        UILabel *headerText = [[UILabel alloc] initWithFrame:labelFrame];
        [headerText setNumberOfLines:0];
        [headerText setFont:[UIFont boldSystemFontOfSize:14.0]];
        
        [self addSubview:headerText];
        
        //[headerText release];
        
    }
    return self;
}

- (void)setHeaderTitle:(NSString *)title {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[title retain];
    //[footerTitle release];
    
    UILabel *label = [[self subviews] objectAtIndex:0];
    
    [label setText:title];
    [label sizeToFit];
    
    CGRect viewFrame = [self frame];
    CGRect labelFrame = [label frame];
    
    viewFrame.size.height = labelFrame.size.height + 16;
    [self setFrame:viewFrame];
    
    [self setNeedsLayout];
    
    footerTitle = title;
}

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[footerTitle release];
    
    //[super dealloc];
}

@end
