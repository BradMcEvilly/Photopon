//
//  PhotoponUploadHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUploadHeaderView.h"
#import "PhotoponMediaModel.h"

@implementation PhotoponUploadHeaderView{
	//float _progress;
}

@synthesize photoponMediaPhoto;
@synthesize photoponMediaPhotoUploadStatus;
@synthesize photoponMediaPhotoUploadStatusText;
@synthesize remoteStatusNumber;
@synthesize photoponMediaPhotoUploadProgress;
@synthesize photoponMediaModel;
@synthesize photoponBtnRetryUpload;
@synthesize photoponBtnCancelUpload;
@synthesize progress;
//@synthesize delegate;

@synthesize photoponFile;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (float)progress {
	return _progress;
}

- (void)setProgress:(float)progress {
	_progress = progress;
    if (self.photoponMediaPhotoUploadProgress.hidden) {
        [self.photoponMediaPhotoUploadProgress setHidden:NO];
    }
    self.photoponMediaPhotoUploadProgressString = [NSString stringWithFormat:@"%f", self.progress];
    self.photoponMediaPhotoUploadProgress.text = self.photoponMediaPhotoUploadProgressString;
	[self setNeedsDisplay];
}
*/

+(PhotoponUploadHeaderView*)initPhotoponUploadHeaderView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponUploadHeaderView" owner:nil options:nil];
    PhotoponUploadHeaderView *view = [arr objectAtIndex:0];
    
    [PhotoponMediaModel newPhotoponDraft].photoponMediaImageFile.photoponUploadHeaderView = view;
    
    [view.photoponMediaPhoto setImage:[[PhotoponMediaModel newPhotoponDraft] thumbNailImage]];
    
    view.photoponMediaPhotoUploadStatusText = nil;
    view.progress = 0;
    
    [view setupDefaultNeedsDisplay:NO];
    
    /*
    //view.photoponMediaModel = [PhotoponMediaModel newPhotoponDraft];
    view.remoteStatusNumber = [[NSNumber alloc] initWithUnsignedInteger:MediaModelRemoteStatusLocal];
    
    view.photoponMediaPhotoUploadStatusString = [[NSString alloc] initWithFormat:@"%i", view.remoteStatus];
    view.photoponMediaPhotoUploadProgressString = [[NSString alloc] initWithFormat:@"%@", @"0"];
    
    view.photoponMediaPhotoUploadStatus.text = view.photoponMediaPhotoUploadStatusString;
    view.photoponMediaPhotoUploadProgress.text = view.photoponMediaPhotoUploadProgressString;
    */
    return view;
    
}

- (void)setupDefaultNeedsDisplay:(BOOL)needsDisplay {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponMediaModel = [PhotoponMediaModel newPhotoponDraft];
    self.remoteStatusNumber = [[NSNumber alloc] initWithInt:MediaModelRemoteStatusLocal];
    
    self.photoponMediaPhotoUploadStatusText = [[NSString alloc] initWithFormat:@"%@", @"Pending"];
    self.photoponMediaPhotoUploadStatus.text = self.photoponMediaPhotoUploadStatusText;
    
    [self.photoponBtnRetryUpload setHidden:YES];
    
    [self registerForKVO];
    
    if (needsDisplay)
        [self setNeedsDisplay];
}

- (MediaModelRemoteStatus)remoteStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (MediaModelRemoteStatus)[[self remoteStatusNumber] intValue];
}

- (void)setRemoteStatus:(MediaModelRemoteStatus)aStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setRemoteStatusNumber:[NSNumber numberWithInt:aStatus]];
    
    if (aStatus == MediaModelRemoteStatusFailed) {
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(configureFailedView) withObject:nil waitUntilDone:NO];
        } else {
            [self configureFailedView];
        }
    }
    
    /*
    if (aStatus == MediaModelRemoteStatusPushing) {
        self.photoponMediaPhotoUploadStatusText = [NSString stringWithFormat:@"%@ 0%", [PhotoponMediaModel titleForRemoteStatus:self.remoteStatusNumber]];
    }
    if (aStatus == MediaModelRemoteStatusFailed) {
        [self unregisterFromKVO];
        [self.photoponBtnRetryUpload setHidden:NO];
        [self registerForKVO];
    }
    
    self.photoponMediaPhotoUploadStatusText = [NSString stringWithFormat:@"%@", [PhotoponMediaModel titleForRemoteStatus:self.remoteStatusNumber]];
    
    //[self setNeedsDisplay];
    */
    
}

- (void)configureFailedView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self unregisterFromKVO];
    [self.photoponBtnRetryUpload setHidden:NO];
    
    //self.photoponMediaPhotoUploadStatusText = @"Failed";
    
    [self setNeedsDisplay];
    
    //[self registerForKVO];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - KVO

- (void)registerForKVO {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"return");
    
    //return;
    
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

	return [NSArray arrayWithObjects: @"photoponMediaPhotoUploadStatusText", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    
    
    
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([keyPath isEqualToString:@"photoponMediaPhotoUploadStatusText"]) {
		photoponMediaPhotoUploadStatus.text = self.photoponMediaPhotoUploadStatusText;
	} else if ([keyPath isEqualToString:@"progress"]) {
        self.photoponMediaPhotoUploadStatus.text = [NSString stringWithFormat:@"Uploading %3.0f %@", self.progress, @"%"];
	}
    
	//[self setNeedsLayout];
	[self setNeedsDisplay];
}

#pragma mark - Action Handlers

-(IBAction)photoponBtnRetryUploadHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponUploadHeaderView:didTapRetryUploadButton:media:)]) {
        [self.delegate photoponUploadHeaderView:self didTapRetryUploadButton:(UIButton*)sender media:self.photoponMediaModel];
    }
}

-(IBAction)photoponBtnCancelUploadHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponUploadHeaderView:didTapCancelUploadButton:media:)]) {
        [self.delegate photoponUploadHeaderView:self didTapCancelUploadButton:(UIButton*)sender media:self.photoponMediaModel];
    }
}

@end
