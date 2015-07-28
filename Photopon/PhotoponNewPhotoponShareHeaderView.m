//
//  PhotoponNewPhotoponShareHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponShareHeaderView.h"
#import "PhotoponNewPhotoponShareViewController.h"

@implementation PhotoponNewPhotoponShareHeaderView

@synthesize photoponOfferValue;
@synthesize photoponBtnCaptions;
@synthesize photoponBtnFacebook;
@synthesize photoponBtnHashtag;
@synthesize photoponBtnMention;
@synthesize photoponBtnStatus;
@synthesize photoponBtnTwitter;
@synthesize contentTextView;

@synthesize photoponContent;
@synthesize photoponContentHeader;
@synthesize photoponToolBar;
@synthesize photoponTextViewPlaceHolderField;

//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+ (PhotoponNewPhotoponShareHeaderView *)initPhotoponNewPhotoponShareHeaderView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponNewPhotoponShareHeaderView" owner:nil options:nil];
    PhotoponNewPhotoponShareHeaderView *view = [arr objectAtIndex:0];
    
    //[PhotoponMediaModel newPhotoponDraft].photoponUploadHeaderView = view;
    
    [view.photoponMediaThumbnail setImage:[[PhotoponMediaModel newPhotoponDraft] thumbNailImage]];
    
    return view;
}

-(void)configureViewWithRefresh:(BOOL)refresh{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(!self.delegate)
        return;
    
    self.contentTextView.delegate = self.delegate;
    
    if (refresh)
        [self setNeedsDisplay];
}
                                                                                         
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (IBAction)photoponBtnProfileImageHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (IBAction)photoponBtnFacebookHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapFacebookButton:media:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapFacebookButton:sender media:nil];
    }
    
}

- (IBAction)photoponBtnTwitterHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapTwitterButton:media:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapTwitterButton:sender media:nil];
    }
}

- (IBAction)photoponBtnStatusHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapStatusButton:media:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapStatusButton:sender media:nil];
    }
}


- (IBAction)photoponBtnCaptionsHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapCaptionsButton:captions:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapCaptionsButton:sender captions:nil];
    }
}

- (IBAction)photoponBtnHashtagHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapHashTagButton:media:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapHashTagButton:sender media:nil];
    }
}

- (IBAction)photoponBtnMentionHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponNewPhotoponShareHeaderView:didTapMentionButton:media:)]) {
        [self.delegate photoponNewPhotoponShareHeaderView:self didTapMentionButton:sender media:nil];
    }
}

#pragma mark - TextField delegate

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    /*
    if (textField == textViewPlaceHolderField) {
        return NO;
    }
     * /
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //currentEditingTextField = textField;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    /*currentEditingTextField = nil;
#ifdef DEBUG
	if ([textField.text isEqualToString:@"#%#"]) {
		[NSException raise:@"FakeCrash" format:@"Nothing to worry about, textField == #%#"];
	}
#endif
    
    _hasChangesToAutosave = YES;
    [self autosaveContent];
    [self autosaveRemote];
    [self refreshButtons];
     * /
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    /*
    if (textField == titleTextField) {
        self.apost.postTitle = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.navigationItem.title = [self editorTitle];
        
    } else if (textField == tagsTextField)
        self.post.tags = [tagsTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    _hasChangesToAutosave = YES;
    [self refreshButtons];
    return YES;
     * /
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    
    /*
    currentEditingTextField = nil;
    [textField resignFirstResponder];
    return YES;
     * /
    
    return YES;
    
}
*/

@end
