//
//  PhotoponMediaDetailHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaDetailHeaderView.h"
#import "PhotoponProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"

#define baseHorizontalOffset 6.0f
#define baseWidth 309.0f

#define horiBorderSpacing 6.0f
#define horiMediumSpacing 8.0f

#define vertBorderSpacing 6.0f
#define vertSmallSpacing 2.0f


#define nameHeaderX baseHorizontalOffset
#define nameHeaderY 0.0f
#define nameHeaderWidth baseWidth
#define nameHeaderHeight 46.0f

#define avatarImageX horiBorderSpacing
#define avatarImageY vertBorderSpacing
#define avatarImageDim 35.0f

#define nameLabelX avatarImageX+avatarImageDim+horiMediumSpacing
#define nameLabelY avatarImageY+vertSmallSpacing
#define nameLabelMaxWidth 309.0f - (horiBorderSpacing+avatarImageDim+horiMediumSpacing+horiBorderSpacing)

#define timeLabelX nameLabelX
#define timeLabelMaxWidth nameLabelMaxWidth

#define mainImageX baseHorizontalOffset
#define mainImageY nameHeaderHeight
#define mainImageWidth baseWidth
#define mainImageHeight 309.0f

#define likeBarX baseHorizontalOffset
#define likeBarY nameHeaderHeight + mainImageHeight
#define likeBarWidth baseWidth
#define likeBarHeight 43.0f

#define likeButtonX 9.0f
#define likeButtonY 7.0f
#define likeButtonDim 28.0f

#define likeProfileXBase 46.0f
#define likeProfileXSpace 3.0f
#define likeProfileY 6.0f
#define likeProfileDim 30.0f

#define viewTotalHeight likeBarY+likeBarHeight
#define numLikePics 7.0f

@interface PhotoponMediaDetailHeaderView ()

// View components
@property (nonatomic, strong) UIView *nameHeaderView;
@property (nonatomic, strong) PhotoponImageView *photoImageView;
@property (nonatomic, strong) UIView *likeBarView;
@property (nonatomic, strong) NSMutableArray *currentLikeAvatars;

// Redeclare for edit
@property (nonatomic, strong, readwrite) PhotoponUserModel *photographer;

// Private methods
- (void)createView;

@end


static TTTTimeIntervalFormatter *timeFormatter;

@implementation PhotoponMediaDetailHeaderView


@synthesize photo;
@synthesize photographer;
@synthesize likeUsers;
@synthesize nameHeaderView;
@synthesize photoImageView;
//@synthesize likeBarView;
@synthesize likeButton;
@synthesize delegate;
//@synthesize currentLikeAvatars;

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame photo:(PhotoponMediaModel*)aPhoto {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.photo = aPhoto;
        self.photographer = [self.photo objectForKey:kPhotoponMediaAttributesUserKey];
        self.likeUsers = nil;
        
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame photo:(PhotoponMediaModel*)aPhoto photographer:(PhotoponUserModel*)aPhotographer likeUsers:(NSArray*)theLikeUsers {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.photo = aPhoto;
        self.photographer = aPhotographer;
        self.likeUsers = theLikeUsers;
        
        self.backgroundColor = [UIColor clearColor];
        
        if (self.photo && self.photographer && self.likeUsers) {
            [self createView];
        }
        
    }
    return self;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    [PhotoponUtility drawSideDropShadowForRect:self.nameHeaderView.frame inContext:UIGraphicsGetCurrentContext()];
    [PhotoponUtility drawSideDropShadowForRect:self.photoImageView.frame inContext:UIGraphicsGetCurrentContext()];
    [PhotoponUtility drawSideDropShadowForRect:self.likeBarView.frame inContext:UIGraphicsGetCurrentContext()];
}


#pragma mark - PAPPhotoDetailsHeaderView

+ (CGRect)rectForView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeight);
}

- (void)setPhoto:(PhotoponMediaModel *)aPhoto {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    photo = aPhoto;
    
    if (self.photo && self.photographer && self.likeUsers) {
        [self createView];
        [self setNeedsDisplay];
    }
}

- (void)setLikeUsers:(NSMutableArray *)anArray {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    likeUsers = [anArray sortedArrayUsingComparator:^NSComparisonResult(PhotoponUserModel *liker1, PhotoponUserModel *liker2) {
        NSString *displayName1 = [liker1 objectForKey:kPhotoponUserAttributesFullNameKey];
        NSString *displayName2 = [liker2 objectForKey:kPhotoponUserAttributesFullNameKey];
        
        if ([[liker1 objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
            return NSOrderedAscending;
        } else if ([[liker2 objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
            return NSOrderedDescending;
        }
        
        return [displayName1 compare:displayName2 options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    }];;
    
    for (PhotoponProfileImageView *image in _currentLikeAvatars) {
        [image removeFromSuperview];
    }
    
    [likeButton setTitle:[NSString stringWithFormat:@"%d", self.likeUsers.count] forState:UIControlStateNormal];
    
    self.currentLikeAvatars = [[NSMutableArray alloc] initWithCapacity:likeUsers.count];
    int i;
    int numOfPics = numLikePics > self.likeUsers.count ? self.likeUsers.count : numLikePics;
    
    for (i = 0; i < numOfPics; i++) {
        PhotoponProfileImageView *profilePic = [[PhotoponProfileImageView alloc] init];
        [profilePic setFrame:CGRectMake(likeProfileXBase + i * (likeProfileXSpace + likeProfileDim), likeProfileY, likeProfileDim, likeProfileDim)];
        [profilePic.profileButton addTarget:self action:@selector(didTapLikerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        profilePic.profileButton.tag = i;
        [profilePic setFile:[[self.likeUsers objectAtIndex:i] objectForKey:kPhotoponUserAttributesFullNameKey]];
        [_likeBarView addSubview:profilePic];
        [_currentLikeAvatars addObject:profilePic];
    }
    [self setNeedsDisplay];
}

- (void)setLikeButtonState:(BOOL)selected {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (selected) {
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( -1.0f, 0.0f, 0.0f, 0.0f)];
        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    } else {
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f)];
        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
    }
    [likeButton setSelected:selected];
}

- (void)reloadLikeBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.likeUsers = [[PhotoponCache sharedCache] likersForPhoto:self.photo];
    [self setLikeButtonState:[[PhotoponCache sharedCache] isPhotoLikedByCurrentUser:self.photo]];
    [likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - ()

- (void)createView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*  Create middle section of the header view; the image
     */
    
    /*
    self.photoImageView = [[PhotoponImageView alloc] initWithFrame:CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight)];
    self.photoImageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
    self.photoImageView.backgroundColor = [UIColor blackColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    */
    
    PhotoponFile *imageFile = [self.photo objectForKey:kPhotoponMediaAttributesUserKey];
    
    if (imageFile) {
        //self.photoImageView.file = imageFile;
        //[self.photoImageView loadInBackground];
    }
    
    [self addSubview:self.photoImageView];
    
    /*
     Create top of header view with name and avatar
     */
    self.nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(nameHeaderX, nameHeaderY, nameHeaderWidth, nameHeaderHeight)];
    self.nameHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]];
    [self addSubview:self.nameHeaderView];
    
    CALayer *layer = self.nameHeaderView.layer;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.masksToBounds = NO;
    layer.shadowRadius = 1.0f;
    layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, self.nameHeaderView.frame.size.height - 4.0f, self.nameHeaderView.frame.size.width, 4.0f)].CGPath;
    
    
    
    /*
    // Load data for header
    [self.photographer fetchIfNeededInBackgroundWithBlock:^(PhotoponMediaModel *object, NSError *error) {
        // Create avatar view
        PhotoponProfileImageView *avatarImageView = [[PhotoponProfileImageView alloc] initWithFrame:CGRectMake(avatarImageX, avatarImageY, avatarImageDim, avatarImageDim)];
        [avatarImageView setFile:[self.photographer objectForKey:kPhotoponUserAttributesProfilePictureUrlKey]];
        [avatarImageView setBackgroundColor:[UIColor clearColor]];
        [avatarImageView setOpaque:NO];
        [avatarImageView.profileButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //[avatarImageView load:^(UIImage *image, NSError *error) {}];
        [nameHeaderView addSubview:avatarImageView];
        
        // Create name label
        NSString *nameString = [self.photographer objectForKey:kPAPUserDisplayNameKey];
        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameHeaderView addSubview:userButton];
        [userButton setBackgroundColor:[UIColor clearColor]];
        [[userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [userButton setTitle:nameString forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [[userButton titleLabel] setLineBreakMode:UILineBreakModeTailTruncation];
        [[userButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // we resize the button to fit the user's name to avoid having a huge touch area
        CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
        CGFloat constrainWidth = self.nameHeaderView.bounds.size.width - (avatarImageView.bounds.origin.x + avatarImageView.bounds.size.width);
        CGSize constrainSize = CGSizeMake(constrainWidth, self.nameHeaderView.bounds.size.height - userButtonPoint.y*2.0f);
        CGSize userButtonSize = [userButton.titleLabel.text sizeWithFont:userButton.titleLabel.font constrainedToSize:constrainSize lineBreakMode:UILineBreakModeTailTruncation];
        CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
        [userButton setFrame:userButtonFrame];
        
        // Create time label
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.photo createdAt]];
        CGSize timeLabelSize = [timeString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(nameLabelMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, nameLabelY+userButtonSize.height, timeLabelSize.width, timeLabelSize.height)];
        [timeLabel setText:timeString];
        [timeLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [timeLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [timeLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameHeaderView addSubview:timeLabel];
        
        [self setNeedsDisplay];
    }];
     */
    
    /*
     Create bottom section fo the header view; the likes
     */
    _likeBarView = [[UIView alloc] initWithFrame:CGRectMake(likeBarX, likeBarY, likeBarWidth, likeBarHeight)];
    [_likeBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
    [self addSubview:_likeBarView];
    
    // Create the heart-shaped like button
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setFrame:CGRectMake(likeButtonX, likeButtonY, likeButtonDim, likeButtonDim)];
    [likeButton setBackgroundColor:[UIColor clearColor]];
    [likeButton setTitleColor:[UIColor colorWithRed:0.369f green:0.271f blue:0.176f alpha:1.0f] forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [likeButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
    [likeButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
    [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [[likeButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
    [[likeButton titleLabel] setMinimumFontSize:11.0f];
    [[likeButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [likeButton setAdjustsImageWhenDisabled:NO];
    [likeButton setAdjustsImageWhenHighlighted:NO];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBarView addSubview:likeButton];
    
    [self reloadLikeBar];
    
    UIImageView *separator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)]];
    [separator setFrame:CGRectMake(0.0f, _likeBarView.frame.size.height - 2.0f, _likeBarView.frame.size.width, 2.0f)];
    [_likeBarView addSubview:separator];
    
}

- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    BOOL liked = !button.selected;
    [button removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setLikeButtonState:liked];
    
    NSArray *originalLikeUsersArray = [NSArray arrayWithArray:self.likeUsers];
    NSMutableSet *newLikeUsersSet = [NSMutableSet setWithCapacity:[self.likeUsers count]];
    
    for (PhotoponUserModel *likeUser in self.likeUsers) {
        // add all current likeUsers BUT currentUser
        if (![[likeUser objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
            [newLikeUsersSet addObject:likeUser];
        }
    }
    
    if (liked) {
        [[PhotoponCache sharedCache] incrementLikerCountForPhoto:self.photo];
        [newLikeUsersSet addObject:[PhotoponUserModel currentUser]];
    } else {
        [[PhotoponCache sharedCache] decrementLikerCountForPhoto:self.photo];
    }
    
    [[PhotoponCache sharedCache] setPhotoIsLikedByCurrentUser:self.photo liked:liked];
    
    [self setLikeUsers:[newLikeUsersSet allObjects]];
    
    if (liked) {
        [PhotoponUtility likePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self setLikeUsers:originalLikeUsersArray];
                [self setLikeButtonState:NO];
            }
        }];
    } else {
        [PhotoponUtility unlikePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self setLikeUsers:originalLikeUsersArray];
                [self setLikeButtonState:YES];
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:self.photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:liked] forKey:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
}

- (void)didTapLikerButtonAction:(UIButton *)button {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponUserModel *user = [self.likeUsers objectAtIndex:button.tag];
    if (delegate && [delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate photoDetailsHeaderView:self didTapUserButton:button user:user];
    }
}

- (void)didTapUserNameButtonAction:(UIButton *)button {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (delegate && [delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate photoDetailsHeaderView:self didTapUserButton:button user:self.photographer];
    }    
}

@end

