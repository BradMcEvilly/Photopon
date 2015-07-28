//
//  PhotoponMediaFullCell.m
//  Photopon
//
//  Created by Brad McEvilly on 8/4/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFullCell.h"
#import "PhotoponOfferOverlayView.h"
#import "PhotoponMediaCaptionCell.h"
#import "PhotoponMediaCell.h"
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponUtility.h"
#import "PhotoponMediaModel.h"
#import "PhotoponConstants.h"

@interface PhotoponMediaFullCell ()

@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *offerOverlay;

@end

@implementation PhotoponMediaFullCell

@synthesize photoponMainView;
@synthesize photoponMediaFooterInfoView;
@synthesize photoponMediaHeaderInfoView;
@synthesize photoponMediaCaptionCell;
@synthesize photoponMediaCell;
@synthesize photoponOfferOverlayView;
//@synthesize photoponMediaModel;
@synthesize backgroundPanelHeader;
@synthesize backgroundPanelFooter;
//@synthesize delegate;
@synthesize photoponBtnMediaOverlay;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponMediaCell.imageView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponMediaCell.imageView.alpha = 0.0;
    [UIView commitAnimations];
    
}

+ (PhotoponMediaFullCell *)photoponMediaFullCell:(id <PhotoponMediaFullCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate, PhotoponMediaCaptionCellDelegate>)delegate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaFullCell" owner:nil options:nil];
    PhotoponMediaFullCell *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (void)setUpWithDelegate:(id <PhotoponMediaFullCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate, PhotoponMediaCaptionCellDelegate>)aDelegate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.delegate = aDelegate;
    
    self.photoponMediaHeaderInfoView.delegate = self.delegate;
    
    //self.photoponMediaCaptionCell.delegate = self.delegate;
    
    //[self.photoponMainView removeFromSuperview];
    
    //[self.contentView setBackgroundColor:[UIColor clearColor]];
    
    //[self.contentView addSubview:self.photoponMainView];
    
    
}

- (PhotoponMediaModel *)photoponMediaModel {
    return photoponMediaModel;
}

- (void)setPhotoponMediaModel:(PhotoponMediaModel *)value {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    photoponMediaModel = value;
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    
    //NSString *title = [[photoponMediaModel valueForKey:@"postTitle"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Set name button properties and avatar image
    
    [self.photoponMediaCell setDetail:photoponMediaModel.coupon.details offerValue:photoponMediaModel.value personalMessage:photoponMediaModel.caption];
    
    [self.photoponMediaCell setPlaceName:photoponMediaModel.coupon.place.name placeDistance:@"0.1 mi" offerSourceImageURL:photoponMediaModel.coupon.place.offerSourceImageURL];
    
    if (photoponMediaModel.user.fullname){
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:photoponMediaModel.user.fullname forState:UIControlStateNormal];
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:photoponMediaModel.user.fullname forState:UIControlStateHighlighted];
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:photoponMediaModel.user.fullname forState:UIControlStateSelected];
    }else{
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", photoponMediaModel.user.firstName, photoponMediaModel.user.lastName] forState:UIControlStateNormal];
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", photoponMediaModel.user.lastName, photoponMediaModel.user.lastName] forState:UIControlStateHighlighted];
        [self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", photoponMediaModel.user.lastName, photoponMediaModel.user.lastName] forState:UIControlStateSelected];
    }
    
    NSLog(@"========================");
    NSLog(@"    Expiration Str      ");
    NSLog(@"    photoponMediaModel.coupon.expirationString = %@", photoponMediaModel.coupon.expirationString);
    NSLog(@"    photoponMediaModel.coupon.place.offerSourceImageURL = %@", photoponMediaModel.coupon.place.offerSourceImageURL);
    NSLog(@"========================");
    
    if (photoponMediaModel.coupon.expirationString)
        self.photoponMediaHeaderInfoView.photoponExpirationDate.text = photoponMediaModel.coupon.expirationString;
    
    
    
    
    // If user is set after the contentText, we reset the content to include padding
    /*
    if (self.photoponMediaCaptionCell.contentLabel.text) {
        [self.photoponMediaCaptionCell setContentText:self.photoponMediaCaptionCell.contentLabel.text];
    }
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //[NSString stringWithFormat:@"%@ %@" weakObject]
    
    NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", kPhotoponContentBase, photoponMediaModel.user.profilePictureUrl]];
    
    UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
    
    //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       photoponMediaModel.user.profilePictureUrl = %@", photoponMediaModel.user.profilePictureUrl);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       photoponMediaModel.user.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, photoponMediaModel.user.profilePictureUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    __weak __typeof(&*photoponMediaModel)weakPhotoponMediaModel = photoponMediaModel;
    
    [self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest SUCCESS SUCCESS SUCCESS ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //[weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson setImage:image forState:UIControlStateNormal];
        
        //UIImage* img = image;
        
        
        
        
        //UIImage* smallImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
        
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        
            [weakSelf.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImage:image];
        
        //});
        
        //[weakCell fadeInView];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 80.0f) mediaModel:object];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
        
        //});
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest FAILURE FAILURE FAILURE ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }];
    
    
    //[cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    /*
    if (photoponMediaModel.caption)
        [self.photoponMediaCaptionCell setUpWithText:photoponMediaModel.caption];
    else
        [self.photoponMediaCaptionCell setUpWithText:@""];
    */
    
    /*
    if (photoponMediaModel.caption)
        [self.photoponMediaCaptionCell setUpWithText:photoponMediaModel.caption];
    else
        [self.photoponMediaCaptionCell setUpWithText:@""];
    */
    //});
    
    @try {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            photoponMediaModel.value = %@", photoponMediaModel.value);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@", photoponMediaModel.value] offerValue:[[NSString alloc] initWithFormat:@"%@", photoponMediaModel.coupon.details] personalMessage:[[NSString alloc] initWithFormat:@"%@", photoponMediaModel.caption]];
        
        [self.photoponMediaCell setPlaceName:photoponMediaModel.coupon.place.name placeDistance:@"0.1 mi" offerSourceImageURL:photoponMediaModel.coupon.place.offerSourceImageURL];
        
        
    }
    @catch (NSException *exception) {
        
        [self.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@", @"$0"] offerValue:[[NSString alloc] initWithFormat:@"%@", @"poor connection"] personalMessage:[[NSString alloc] initWithFormat:@"%@", @"poor connection"]];
        
    }
    @finally {
        // silence is golden
        
    }
    
    @try {
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            photoponMediaModel.value = %@", photoponMediaModel.value);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.photoponMediaCell setPlaceName:photoponMediaModel.coupon.place.name placeDistance:@"0.1 mi" offerSourceImageURL:photoponMediaModel.coupon.place.offerSourceImageURL];
        
    }
    @catch (NSException *exception) {
        
        [self.photoponMediaCell setPlaceName:photoponMediaModel.coupon.place.name placeDistance:@"0.1 mi" offerSourceImageURL:photoponMediaModel.coupon.place.offerSourceImageURL];
        
    }
    @finally {
        // silence is golden
        
    }
    
    if (photoponMediaModel.linkURL) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---->       object.linkURL = %@", photoponMediaModel.linkURL);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSURL *linkURL = [[NSURL alloc] initWithString:photoponMediaModel.linkURL];
        
        
        UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
        
        //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
        
        /*
         self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL:linkURL]];
         
         [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         // success
         
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL SUCCESS = %@", object.linkURL);
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         
         
         
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         // failed
         
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL FAIL = %@", object.linkURL);
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         
         }];
         */
        
        if ([PhotoponUtility doesHaveCachedTimelineImage:photoponMediaModel.entityKey]) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            UIImage *timelineImg = [PhotoponUtility timelineImageFromImageCacheKey:photoponMediaModel.entityKey];
            [self.photoponMediaCell.imageView setImage:timelineImg];
            
        }else{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]  }else{  ");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self.photoponMediaCell.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
                
                [weakSelf.photoponMediaCell.imageView setImage:image];
                [weakSelf fadeInView];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    [PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 0.8f) mediaModel:weakPhotoponMediaModel];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
                    
                });
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                
            }];
        }
        
        
        //[cell.photoponMediaCell.imageView setImageWithURL:linkURL placeholderImage:placeHolderImg];
        
        
        
        //cell.photoponMediaCell.imageView = testImgView;
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setSelected:selected animated:animated];
    
    
    
    // Configure the view for the selected state
}

- (void)prepareForReuse{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super prepareForReuse];
	
    //change back the things that are different about the "more posts/pages/comments" cell so that reuse
	//does not cause UI strangeness for users
	
    self.photoponMediaCell.imageView.image = [UIImage imageNamed:@"PhotoponPlaceholderMediaPhoto.png"];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
    self.contentView.backgroundColor = TABLE_VIEW_CELL_OFF_BACKGROUND_COLOR;
    self.photoponMediaCell.offerOverlay.photoponOfferValue.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    
    
    [self.photoponMediaFooterInfoView.photoponBtnActionsLike setSelected:NO];
    [self.photoponMediaFooterInfoView.photoponBtnActionsSnip setSelected:NO];
    
    //[self.photoponMediaCell.offerOverlay setDetail:nil offerValue:nil];
    //self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView.image = nil;
    /*
    self.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson.titleLabel.text = @"";
    self.photoponMediaHeaderInfoView.photoponExpirationDate.text = @"";
    self.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson.text = @"";
    */
}

/*
- (void)layoutSubviews {
    [super layoutSubviews];
    / *
    if (self.isEditing)
        self.photoponMediaCaptionCell.hidden = YES;
    else
        self.photoponMediaCaptionCell.hidden = YES;
    * /
    
    
    
    
    CGSize expectedstatusLabelSize = [statusLabel.text sizeWithFont:[UIFont systemFontOfSize:DATE_FONT_SIZE]];
    CGFloat expectedStatusLabelWidth = 0.f;
    if ( IS_IPHONE && UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ) {
        expectedStatusLabelWidth = expectedstatusLabelSize.width > statusLabelMaxWidthPortrait ? statusLabelMaxWidthPortrait : expectedstatusLabelSize.width;
    } else {
        expectedStatusLabelWidth = expectedstatusLabelSize.width > statusLabelMaxWidthLandscape ? statusLabelMaxWidthLandscape : expectedstatusLabelSize.width;
    }
    
    //NSLog(@"width of status label %f", expectedStatusLabelLength);
    
    CGFloat x = self.frame.size.width - expectedStatusLabelWidth - RIGHT_MARGIN;
    if ( IS_IPHONE )
        x = x - 22; //the disclousure size
    
    CGRect rect = CGRectMake(x, nameLabel.frame.origin.y + LABEL_HEIGHT + VERTICAL_OFFSET, expectedStatusLabelWidth, DATE_LABEL_HEIGHT);
    statusLabel.frame = rect;
    
    if ( self.isEditing )
        statusLabel.hidden = YES;
    else
        statusLabel.hidden = NO;
    
    CGFloat dateWidth = self.frame.size.width - LEFT_OFFSET - RIGHT_MARGIN -  ( IS_IPHONE ? expectedStatusLabelWidth + 22 : expectedStatusLabelWidth);  //Max space available for the Date
    rect = CGRectMake(LEFT_OFFSET, nameLabel.frame.origin.y + LABEL_HEIGHT + VERTICAL_OFFSET, dateWidth, DATE_LABEL_HEIGHT);
    dateLabel.frame = rect;
}
*/
/*
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    
    //if (!hideDropShadow) {
    
    [PhotoponUtility drawSideAndTopDropShadowForRect:self.backgroundPanelHeader.frame inContext:UIGraphicsGetCurrentContext()];
    [PhotoponUtility drawSideAndBottomDropShadowForRect:self.backgroundPanelFooter.frame inContext:UIGraphicsGetCurrentContext()];
    
    
    //}
}*/


#pragma mark - Action Handlers

- (IBAction)photoponBtnMediaOverlayHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponMediaFullCell:didTapMediaButton:)]) {
        [self.delegate photoponMediaFullCell:self didTapMediaButton:sender];
    }
    
}

@end
