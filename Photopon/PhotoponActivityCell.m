//
//  PhotoponActivityCell.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponActivityCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "PhotoponProfileImageView.h"
#import "PhotoponActivityViewController.h"
#import "PhotoponActivityModel.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface PhotoponActivityCell ()

/*! Private view components */
@property (nonatomic, strong) PhotoponProfileImageView *activityImageView;
@property (nonatomic, strong) UIButton *activityImageButton;

/*! Flag to remove the right-hand side image if not necessary */
@property (nonatomic) BOOL hasActivityImage;

/*! Private setter for the right-hand side image */
- (void)setActivityImageFile:(PhotoponFile *)image;

/*! Button touch handler for activity image button overlay */
- (void)didTapActivityButton:(id)sender;

/*! Static helper method to calculate the space available for text given images and insets */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

@end

@implementation PhotoponActivityCell



#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        horizontalTextSpace = [PhotoponActivityCell horizontalTextSpaceForInsetWidth:0];
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        // Create subviews and set cell properties
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.hasActivityImage = NO; //No until one is set
        
        self.activityImageView = [[PhotoponProfileImageView alloc] init];
        [self.activityImageView setBackgroundColor:[UIColor clearColor]];
        [self.activityImageView setOpaque:YES];
        [self.mainView addSubview:self.activityImageView];
        
        self.activityImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.activityImageButton setBackgroundColor:[UIColor clearColor]];
        [self.activityImageButton addTarget:self action:@selector(didTapActivityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.activityImageButton];
    }
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    
    // Layout the activity image and show it if it is not nil (no image for the follow activity).
    // Note that the image view is still allocated and ready to be dispalyed since these cells
    // will be reused for all types of activity.
    
    [self.activityImageView setFrame:CGRectMake( (CGFloat)[UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    [self.activityImageButton setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    
    // Add activity image if one was set
    if (self.hasActivityImage) {
        [self.activityImageView setHidden:NO];
        [self.activityImageButton setHidden:NO];
    } else {
        [self.activityImageView setHidden:YES];
        [self.activityImageButton setHidden:YES];
    }
    
    // Change frame of the content text so it doesn't go through the right-hand side picture
    CGSize contentSize = [self.contentLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    [self.contentLabel setFrame:CGRectMake( 46.0f, 10.0f, contentSize.width, contentSize.height)];
    
    // Layout the timestamp label given new vertical
    CGSize timeSize = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:11.0f] forWidth:[UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f lineBreakMode:UILineBreakModeTailTruncation];
    [self.timeLabel setFrame:CGRectMake( 46.0f, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 2.0f, timeSize.width, timeSize.height)];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}


#pragma mark - PAPActivityCell

- (void)setIsNew:(BOOL)isNew {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (isNew) {
        [self.mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundNewActivity.png"]]];
    } else {
        [self.mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
    }
}


- (void)setActivity:(PhotoponActivityModel *)activity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Set the activity property
    _activity = activity;
    if ([[activity objectForKey:kPhotoponActivityAttributesTypeKey] isEqualToString:kPhotoponActivityAttributesTypeFollow] || [[activity objectForKey:kPhotoponActivityAttributesTypeKey] isEqualToString:kPhotoponActivityAttributesTypeJoined]) {
        [self setActivityImageFile:nil];
    } else {
        [self setActivityImageFile:(PhotoponFile*)[[activity.dictionary objectForKey:kPhotoponActivityAttributesPhotoKey] objectForKey:kPhotoponMediaThumbnailKey]];
    }
    
    NSString *activityString = [PhotoponActivityViewController stringForActivityType:(NSString*)[activity objectForKey:kPhotoponActivityAttributesTypeKey]];
    self.user = [activity objectForKey:kPhotoponActivityAttributesFromUserKey];
    
    // Set name button properties and avatar image
    [self.avatarImageView setFile:[self.user objectForKey:kPhotoponUserAttributesProfilePictureUrlKey]];
    
    NSString *nameString = NSLocalizedString(@"Someone", nil);
    if (self.user && [self.user objectForKey:kPhotoponUserAttributesFullNameKey] && [[self.user objectForKey:kPhotoponUserAttributesFullNameKey] length] > 0) {
        nameString = [self.user objectForKey:kPhotoponUserAttributesFullNameKey];
    }
    
    [self.nameButton setTitle:nameString forState:UIControlStateNormal];
    [self.nameButton setTitle:nameString forState:UIControlStateHighlighted];
    
    // If user is set after the contentText, we reset the content to include padding
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] forWidth:nameMaxWidth lineBreakMode:UILineBreakModeTailTruncation];
        NSString *paddedString = [PhotoponBaseTextCell padString:activityString withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:activityString];
    }
    
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[activity createdAt]]];
    
    [self setNeedsDisplay];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setCellInsetWidth:insetWidth];
    horizontalTextSpace = [PhotoponActivityCell horizontalTextSpaceForInsetWidth:insetWidth];
}

// Since we remove the compile-time check for the delegate conforming to the protocol
// in order to allow inheritance, we add run-time checks.
- (id<PAPActivityCellDelegate>)delegate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (id<PAPActivityCellDelegate>)_delegate;
}

- (void)setDelegate:(id<PAPActivityCellDelegate>)delegate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(_delegate != delegate) {
        _delegate = delegate;
    }
}


#pragma mark - ()

+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return ([UIScreen mainScreen].bounds.size.width - (insetWidth * 2.0f)) - 72.0f - 46.0f;
}

+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self heightForCellWithName:name contentString:content cellInsetWidth:0.0f];
}

+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] forWidth:200.0f lineBreakMode:UILineBreakModeTailTruncation];
    NSString *paddedString = [PhotoponBaseTextCell padString:content withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
    CGFloat horizontalTextSpace = [PhotoponActivityCell horizontalTextSpaceForInsetWidth:cellInset];
    
    CGSize contentSize = [paddedString sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat singleLineHeight = [@"Test" sizeWithFont:[UIFont systemFontOfSize:13.0f]].height;
    
    // Calculate the added height necessary for multiline text. Ensure value is not below 0.
    CGFloat multilineHeightAddition = contentSize.height - singleLineHeight;
    
    return 48.0f + fmax(0.0f, multilineHeightAddition);
}

- (void)setActivityImageFile:(PhotoponFile *)imageFile {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (imageFile) {
        [self.activityImageView setFile:imageFile];
        [self setHasActivityImage:YES];
    } else {
        [self setHasActivityImage:NO];
    }
}

- (void)didTapActivityButton:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapActivityButton:)]) {
        [self.delegate cell:self didTapActivityButton:self.activity];
    }    
}

@end
