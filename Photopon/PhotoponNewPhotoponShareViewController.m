//
//  PhotoponNewPhotoponShareViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponShareViewController.h"
#import "UIViewController+PhotoponTitleLabel.h"
#import "PhotoponNewPhotoponShareHeaderView.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponTabBarController.h"

@interface PhotoponNewPhotoponShareViewController ()

@property(nonatomic,copy) PhotoponShareCompletionBlock completionBlock;

@end

@implementation PhotoponNewPhotoponShareViewController

@synthesize captions;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithCompletionBlock:(PhotoponShareCompletionBlock)completionBlock{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self = [self initWithNibName:@"PhotoponNewPhotoponShareViewController" bundle:nil];
    
    
    
    self = [self initWithRootObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"0", kPhotoponModelIdentifierKey,
                                     kPhotoponUserClassName, kPhotoponEntityNameKey,nil]];
    
    
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
        
        
        /*
         NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
         
         if (currentUserID && currentUserID.length>0) {
         [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
         }*/
        
        
        
        [self.methodParams setObject:[_rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        [self.methodParams setObject:@"models" forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:@"bp.searchHashtags" forKey:kPhotoponMethodNameKey];
        
        
        //self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        //self.outstandingSectionFooterQueries = [NSMutableDictionary dictionary];
        
        // The className to query on
        
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
        
        //self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponUserClassName];
    if (self) {
        
        //self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
        @synchronized(self) {
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
            }
            [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
            [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        }
        
        // set api method vars
        [self.methodParams setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedMediaModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIMethodGetFollowers] forKey:kPhotoponMethodNameKey];
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
        
        //self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (photoponMediaModel==nil) {
        photoponMediaModel = [PhotoponMediaModel newPhotoponDraft];
    }
    
    [self initTitleLabelWithText:[[NSString alloc] initWithFormat:@"%@", @"New Photopon"]];
    
    self.photoponNewPhotoponShareHeaderView = [PhotoponNewPhotoponShareHeaderView initPhotoponNewPhotoponShareHeaderView];
    self.photoponNewPhotoponShareHeaderView.delegate = self;
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"------->            photoponMediaModel.value = %@", photoponMediaModel.coupon.details);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShareHeaderView configureViewWithRefresh:NO];
    
    self.photoponNewPhotoponShareHeaderView.photoponOfferValue.text = photoponMediaModel.coupon.details;
    
    self.tableView.tableHeaderView = self.photoponNewPhotoponShareHeaderView;
    
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateSelected];
    [backButton setFrame:CGRectMake( 0.0f, 0.0f, 64.0f, 30.0f)];
    [backButton addTarget:self action:@selector(photoponBackButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnShare.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnShare.png"] forState:UIControlStateHighlighted];
    [shareButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnShare.png"] forState:UIControlStateSelected];
    [shareButton setFrame:CGRectMake( 0.0f, 0.0f, 64.0f, 30.0f)];
    [shareButton addTarget:self action:@selector(photoponShareButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    
    
    //[signOutButton setTitle:@"Back" forState:UIControlStateNormal];
    //[signOutButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    //[[signOutButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
    //[signOutButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"] forState:UIControlStateHighlighted];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    /*
    startingFrame = self.view.frame;
    if (self.photo == nil) {
        [self showPicker];
    } else {
        self.photoImageView.image = self.photo;
     
    }
     */
}

// override to prevent from displaying over post text
- (void)configureNoResultsView{
    // do nothing
}

-(void) photoponBackButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)screenshotUtil{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
    NSData *imageData = UIImageJPEGRepresentation([self.photoponNewCompositionSnapshotViewController.view screenshot], 1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    NSString *photoponPhotoFilename = [[[NSString alloc] initWithFormat:@"%@-share.jpg", self.filebase] retain];
    
    NSString *path = [[self.appDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:photoponPhotoFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:imageData attributes:nil];
    
    // attatch email image
    NSData *myData = [NSData dataWithContentsOfFile:path];
    */
}

- (void)textViewDidChange:(UITextView *)aTextView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponNewPhotoponShareHeaderView.contentTextView.text && self.photoponNewPhotoponShareHeaderView.contentTextView.text.length>0)
        [self.photoponNewPhotoponShareHeaderView.photoponTextViewPlaceHolderField setHidden:YES];
    else
        [self.photoponNewPhotoponShareHeaderView.photoponTextViewPlaceHolderField setHidden:NO];
    
    
    //_hasChangesToAutosave = YES;
    //[self autosaveContent];
    
    //[self refreshButtons];
    
    
    //[textViewPlaceHolderField removeFromSuperview];
    
    /*
     NSError *error = nil;
     NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
     NSArray *hashtagMatches = [hashtagRegex matchesInString:aTextView.text options:0 range:NSMakeRange(0, aTextView.text.length)];
     for (NSTextCheckingResult *hashtagMatch in hashtagMatches) {
     NSRange hashtagWordRange = [hashtagMatch rangeAtIndex:1];
     NSString* hashtagWord = [aTextView.text substringWithRange:hashtagWordRange];
     
     [self configureNewSearchWithText:hashtagWord searchScope:kPhotoponSearchScopeHashtags];
     
     NSLog(@"Found tag %@", hashtagWord);
     }
     
     return;
     
     NSRegularExpression *peopleRegex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
     NSArray *peopleMatches = [peopleRegex matchesInString:aTextView.text options:0 range:NSMakeRange(0, aTextView.text.length)];
     for (NSTextCheckingResult *peopleMatch in peopleMatches) {
     NSRange peopleWordRange = [peopleMatch rangeAtIndex:1];
     NSString* peopleWord = [aTextView.text substringWithRange:peopleWordRange];
     
     [self configureNewSearchWithText:peopleWord searchScope:kPhotoponSearchScopeHashtags];
     
     NSLog(@"Found tag %@", peopleWord);
     }*/
}

- (void)photoponShareButtonHandler:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (photoponMediaModel==nil) {
        photoponMediaModel = appDelegate.tabBarController.photoponNewMediaDraft; //[PhotoponMediaModel newPhotoponDraft];
    }
    
    [photoponMediaModel.dictionary setObject:self.photoponNewPhotoponShareHeaderView.contentTextView.text forKey:kPhotoponMediaAttributesCaptionKey];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->            self.photoponNewPhotoponShareHeaderView.contentTextView.text = %@", self.photoponNewPhotoponShareHeaderView.contentTextView.text);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"photoponShareButtonHandler 1");
    
    [PhotoponMediaModel setNewPhotoponDraft:photoponMediaModel];
    
    NSLog(@"photoponShareButtonHandler 2");
    
    self.completionBlock(nil);
    
    NSLog(@"photoponShareButtonHandler 3");
    
    /*
    photoponMediaModel.dictionary setObject:self. forKey:<#(id<NSCopying>)#>
    
    
    
    if (!appDelegate.validateDeviceConnection){
     
     
     
        [media setRemoteStatus:MediaRemoteStatusFailed];
        [post save];
        [self dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Quick Photo Failed", @"")
                                                            message:NSLocalizedString(@"The Internet connection appears to be offline. The post has been saved as a local draft, you can publish it later.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else{
        appDelegate.isUploadingPost = YES;
    }
    
    
    / *
    Blog *blog = self.blogSelector.activeBlog;
    Media *media = nil;
    if (post == nil) {
        post = [Post newDraftForBlog:blog];
    } else {
        post.blog = blog;
        media = [post.media anyObject];
        [media setBlog:blog];
    }
    post.postTitle = titleTextField.text;
    post.content = contentTextView.text;
    if (self.isCameraPlus) {
        post.specialType = @"QuickPhotoCameraPlus";
    } else {
        post.specialType = @"QuickPhoto";
    }
    post.postFormat = @"image";
    
     
    if( appDelegate.connectionAvailable == YES ) {
        [[NSNotificationCenter defaultCenter] addObserver:post selector:@selector(mediaDidUploadSuccessfully:) name:ImageUploadSuccessful object:media];
        [[NSNotificationCenter defaultCenter] addObserver:post selector:@selector(mediaUploadFailed:) name:ImageUploadFailed object:media];
        
        appDelegate.isUploadingPost = YES;
     
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [media uploadWithSuccess:nil failure:nil];
            [post save];
        });
        
     
        [self dismiss];
        [sidebarViewController uploadQuickPhoto:post];
    } else {
        [media setRemoteStatus:MediaRemoteStatusFailed];
        [post save];
        [self dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Quick Photo Failed", @"")
                                                            message:NSLocalizedString(@"The Internet connection appears to be offline. The post has been saved as a local draft, you can publish it later.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
     */
}

- (void)dismiss {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (void)cancel {
    self.photo = nil;
    if (post != nil) {
        [post deletePostWithSuccess:nil failure:nil];
    }
    [self dismiss];
}
*/

- (NSMutableArray *)paramsForTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    /*NSArray *params =  [NSArray arrayWithObjects:
     self.identifier,
     (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
     nil];
     */
    
    
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]],
                               nil];
    
    
    
    
    /*
     
     NSArray *paramsArrExtra = [NSArray arrayWithObjects:[NSString stringWithString:(NSString*)[self.photoponFeedItemsTableViewController.photoponModelDictionary objectForKey:@"identifier"]], [NSNumber numberWithInt:num], nil];
     
     */
    
    
    /* temp fix until brian uploads updated php server file
     NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
     self.identifier,
     [[NSNumber alloc] initWithInt:
     [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
     [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
     nil];
     */
    
    return params;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PhotoponNewPhotoponShareHeaderView delegate

/*!
 Sent to the delegate when the facebook button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapFacebookButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShareHeaderView.photoponBtnFacebook setSelected:((self.photoponNewPhotoponShareHeaderView.photoponBtnFacebook.isSelected)?NO:YES)];
    
    
    
}

/*!
 Sent to the delegate when the twitter button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapTwitterButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShareHeaderView.photoponBtnTwitter setSelected:((self.photoponNewPhotoponShareHeaderView.photoponBtnTwitter.isSelected)?NO:YES)];
    
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapStatusButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShareHeaderView.photoponBtnStatus setSelected:((self.photoponNewPhotoponShareHeaderView.photoponBtnStatus.isSelected)?NO:YES)];
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapHashTagButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapMentionButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapBackButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didResignWithMedia:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapPublishButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*!
 Sent to the delegate when the show example captions button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapCaptionsButton:(UIButton *)button captions:(NSArray *)captions{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}





@end
