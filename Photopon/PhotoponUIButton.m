//
//  PhotoponFeedItemThumbView.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/1/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "PhotoponUIButton.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponImageView.h"


//#import "UIImageView+AFNetworking.h"
//#import "UIView+Bounce.h"
//#import "UIView+Pop.h"


@implementation PhotoponUIButton{
    id <PhotoponUIButtonDelegate> _delegate;
    NSDictionary *_dataObject;
    UIImageView *_imageView;
}

@synthesize delegate;
@synthesize progressNumber;
@synthesize tagNumber;

@synthesize imageView;

- (void)dealloc 
{
    
}

-(void)awakeFromNib{
    
    //[self addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self setClipsToBounds:YES];
    
    // If the thumbnail needs to be scaled, it should mantain its aspect
    // ratio.
    
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
}

/*
-(id)init{
    
    if (self = [super init]) {
        
        [self addTarget:self
                 action:@selector(didTouch:)
       forControlEvents:UIControlEventTouchUpInside];
        
        [self setClipsToBounds:YES];
        
        // If the thumbnail needs to be scaled, it should mantain its aspect
        // ratio.
        
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    
    }
    return self;
}
* /
-(void)awakeFromNib{
    
    [self addTarget:self
             action:@selector(didTouch:)
   forControlEvents:UIControlEventTouchUpInside];
    
    [self setClipsToBounds:YES];
    
    // If the thumbnail needs to be scaled, it should mantain its aspect
    // ratio.
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    
}
* /
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
		[self commonInitialization];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
		[self commonInitialization];
    
    return self;
}

- (void)commonInitialization
{
	_easingFunction = ElasticEaseInOut;
	_gridBounds = CGRectMake(-1.3, -0.4, 3.6, 1.8);
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addTarget:self
                 action:@selector(didTouch:)
       forControlEvents:UIControlEventTouchUpInside];
        
        [self setClipsToBounds:YES];
        
        // If the thumbnail needs to be scaled, it should mantain its aspect
        // ratio.
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    }
    return self;
}*/

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self = [super initWithFrame:frame]) {
        /*
        [self addTarget:self
                 action:@selector(didTouch:)
       forControlEvents:UIControlEventTouchUpInside];
        
        [self setClipsToBounds:YES];
        
         */
        // If the thumbnail needs to be scaled, it should mantain its aspect
        // ratio.
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    }
    return self;
}


//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
//    self per
//}

/*
- (id) didTouch:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self bounce:0.99f];
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate validateDeviceConnection]) {
        [self handleTouchUpInside:sender];
    }
    
}

-(float)progress{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.progressNumber floatValue];
}

-(void)setProgress:(float)progress{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (progress && (progress > [self.progressNumber intValue])) {
        self.progressNumber = [NSNumber numberWithFloat:progress];
    }
    [self.imageView setNeedsLayout];
}

-(void)setDataObject:(NSDictionary *)dataObject{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (dataObject) {
        _dataObject = [NSDictionary dictionaryWithDictionary:dataObject];
    }
    
    [self.imageView setNeedsLayout];
}

-(NSDictionary*)dataObject{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return _dataObject;
}

- (void)handleTouchUpInside:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.delegate) {
        return;
    }
    [self.delegate performSelector:@selector(buttonViewDidTouchUpInside:) withObject:self];
}

/ *
- (void)tableView:(UITableView *)tableView buttonView:(PhotoponUIButton *)button handleTouchUpInside:(id)sender{
    
}*/

- (void)setPhotoponButtonImage:(UIImage *)newImage 
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setImage:newImage forState:UIControlStateNormal];
}

- (void)setPhotoponButtonBackgroundImage:(UIImage *)backgroundImage
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (PhotoponUIType)childTagValue
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (PhotoponUIType)[[self photoponUITypeNumber] intValue];
}

- (PhotoponUIType)photoponUIType {
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (PhotoponUIType)[[self photoponUITypeNumber] intValue];
}

- (void)setPhotoponUIType:(PhotoponUIType)photoponUIType {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setPhotoponUITypeNumber:[NSNumber numberWithInt:photoponUIType]];
}


@end