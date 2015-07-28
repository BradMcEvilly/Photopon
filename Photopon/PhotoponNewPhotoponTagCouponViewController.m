//
//  PhotoponNewPhotoponTagCouponViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponTagCouponViewController.h"
#import "PhotoponMediaModel.h"
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponCouponModel.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponNewPhotoponShareViewController.h"
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponOfferOverlayView.h"
#import "PhotoponOfferPageViewController.h"
#import "PhotoponCouponModel.h"

@interface PhotoponNewPhotoponTagCouponViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate>

@property(nonatomic,copy) PhotoponTagCouponCompletionBlock completionBlock;

@end

@implementation PhotoponNewPhotoponTagCouponViewController{
    UIImage* _photoponImage;
    /*
    IBOutlet FireUIPagedScrollView * photoponPagesScrollView;
    IBOutlet FireUIPagedScrollView * photoponActivityPagesScrollView;
    IBOutlet UIView *photoponPagesContainerView;
    IBOutlet UIPageControl *photoponPageControl;
    IBOutlet UIPageControl *photoponActivityPageControl;
     */
}

@synthesize imageView;
@synthesize photoponToolBarLabel;
@synthesize photoponBtnNext;
@synthesize photoponBtnRetake;
//@synthesize photoponBtnTagCoupon;
@synthesize photoponToolBarView;
//@synthesize offerOverlay;
@synthesize photoponImage;

@synthesize photoponBtnPlace;
@synthesize photoponBtnRefresh;

@synthesize photoponPagesContainerView;
@synthesize photoponPagesScrollView;
//@synthesize photoponActivityPagesScrollView;
//@synthesize photoponPageControl;
//@synthesize photoponActivityPageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString*)entityName
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil entityName:entityName];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        //self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 16;
        
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        
        
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.paginationEnabled = YES;
        
            @synchronized(self) {
                //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
                NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
                if (!currentUserID || !currentUserID.length>0) {
                    currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
                }
                [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
                [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
            }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
    }
    return self;
}

- (id)initWithCompletionBlock:(PhotoponTagCouponCompletionBlock)completionBlock
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //self = [super init];
    
    self = [self initWithNibName:@"PhotoponNewPhotoponTagCouponViewController" bundle:nil entityName:kPhotoponCouponClassName];
    
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}
/*
- (void)updateCroppedImageViewWithImage:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponImage = (UIImage*)sender;
    
    [self.imageView setImage:self.photoponImage];
    [self.imageView setNeedsDisplay];
}

- (void)didCropImage:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateCroppedImageViewWithImage:) withObject:[[PhotoponMediaModel newPhotoponDraft] croppedImage] waitUntilDone:NO];
	} else {
		[self updateCroppedImageViewWithImage:[[PhotoponMediaModel newPhotoponDraft] croppedImage]];
	}
}
*/
- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Disable by default to ensure coupon selection to help improve usability
    
    
    
    [self.photoponBtnNext setEnabled:NO];
    
    
    //[self.imageView setImage:[UIImage imageNamed:@"PhotoponPlaceholderProfileCover.png"]];
    
    
    //PhotoponOffersTableViewController *photoponOffersTableViewController = [[PhotoponOffersTableViewController alloc] initWithEntityName:kPhotoponCouponClassName];
    
    NSLog(@"|||||||         viewDidLoad checkpoint 1             |||||||||||||||||||");
    
    //photoponOffersTableViewController.delegate = self;
    
    NSLog(@"|||||||         viewDidLoad checkpoint 1             |||||||||||||||||||");
    
    //[self presentViewController:photoponOffersTableViewController animated:YES completion:nil];
    
    
    
    /*
    // check if we already chose our coupon based on coupon ID (this must always be set and is currently the 3rd-party
    // ID for NEW PHOTOPON DRAFTS ONLY!! Otherwise, it's the coupon id assigned by photopon coupon database
    
    NSMutableDictionary *couponDict = [[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey] mutableCopy];
    
    if (couponDict) {
    
        
    //if ([[PhotoponMediaModel newPhotoponDraft].dictionary objectForKey:kPhotoponMediaAttributesCouponKey]) {
        
        //NSMutableDictionary *couponDict = [[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey] mutableCopy];
        
        // if already set, enable next btn
        [self.photoponBtnNext setEnabled:YES];
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[PhotoponMediaModel messageForNewPhotoponDraftCancel]
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", @"")
                                          otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];
    [alert show];
    
     */
    
        
    //});
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"----------->        buttonIndex == %i", buttonIndex);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (buttonIndex) {
        case 0:
        // cancel clear draft action
        {
         
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            switch case 0", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
            break;
        case 1:
        // clear draft
        {
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            switch case 1", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [PhotoponMediaModel clearNewPhotoponDraft];
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (buttonIndex == 1) {
     NSURLCredential *credential;
     
     if ([_challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
     credential = [NSURLCredential credentialForTrust:_challenge.protectionSpace.serverTrust];
     } else {
     NSString *username, *password;
     if ([self respondsToSelector:@selector(setAlertViewStyle:)]) {
     username = [[self textFieldAtIndex:0] text];
     password = [[self textFieldAtIndex:1] text];
     } else {
     username = usernameField.text;
     password = passwordField.text;
     }
     credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistencePermanent];
     }
     
     [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:[_challenge protectionSpace]];
     [[_challenge sender] useCredential:credential forAuthenticationChallenge:_challenge];
     } else {
     [[_challenge sender] cancelAuthenticationChallenge:_challenge];
     }
     [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
     */
}

- (IBAction)photoponBtnRefreshHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self reloadInBackground];
}

- (IBAction)photoponBtnPlaceHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (IBAction)photoponBtnRetakeHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerShouldChangeViewMode object:nil userInfo:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

/*
- (IBAction)photoponBtnTagCouponHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponNewPhotoponShareViewController *
    
    // present offers table
    
    PhotoponOffersTableViewController *photoponOffersTableViewController = [[PhotoponOffersTableViewController alloc] initWithEntityName:kPhotoponCouponClassName];
    
    NSLog(@"|||||||         photoponBtnTagCouponHandler checkpoint 1             |||||||||||||||||||");
    
    photoponOffersTableViewController.delegate = self;
    
    NSLog(@"|||||||         photoponBtnTagCouponHandler checkpoint 1             |||||||||||||||||||");
    
    [self presentViewController:photoponOffersTableViewController animated:YES completion:nil];
    
    NSLog(@"|||||||         photoponBtnTagCouponHandler checkpoint 1             |||||||||||||||||||");
    
    //[self.navigationController pushViewController:photoponOffersTableViewController animated:YES];
    
    
    
 
 
}
*/


/*
- (void)didSnapPhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self showHUDWithStatusText:@"Processing"];
    
    [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---------->         [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){          BEGIN BLOCK, BEGIN BLOCK, BEGIN BLOCK");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"")
                                                                message:[error description]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
            [alertView show];
        }
        
        [self hideHud];
        self.completionBlock(coupon);
    }];
}*/

- (IBAction)photoponBtnNextHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self showHUDWithStatusText:@"Preparing next step"];
    
    [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---------->         [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){          BEGIN BLOCK, BEGIN BLOCK, BEGIN BLOCK");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (error) {
            
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
            
            /*
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"")
                                                                message:[error description]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
            [alertView show];
             */
        }
        
        //[self hideHud];
        self.completionBlock(coupon);
    }];
}

- (void)setUpPageViewControllers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    if (!self.controllers)
        self.controllers = [NSMutableArray new];
    
    if (self.controllers.count>0)
        [self.controllers removeAllObjects];
    */
    
    
    int i;
    int iMax = (self.objects.count >= self.objectsPerPage)?self.objectsPerPage:self.objects.count;
    
    for (i=0; i< iMax; i++){
        
        
        //PhotoponOfferPageViewController *offersPageItem = [[PhotoponOfferPageViewController alloc] initWithCouponModel:[self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
        
        //offersPageItem.pageIndex = i;
        
        //[self.controllers addObject:offersPageItem];
        
        
        
        
        [self.photoponPagesScrollView addPagedViewController:[[PhotoponOfferPageViewController alloc] initWithCouponModel:[self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]]];
    
    
    }
}

- (void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super objectsDidLoad:error];
    [self.photoponBtnNext setEnabled:YES];
    
}

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
                               (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
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

- (Photopon8CouponsModel*)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [Photopon8CouponsModel modelWithDictionary:(NSDictionary*)[self dictionaryAtIndexPath:indexPath]];
}

- (PhotoponCouponModel*)processedObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    Photopon8CouponsModel *offer = [self objectAtIndexPath:indexPath];
    
    [offer sanitize];
    
    PhotoponMediaModel *pMediaModel = [PhotoponMediaModel newPhotoponDraft];
    
    [pMediaModel convert8CouponsDictToCoupons:offer.dictionary];
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"------->            pMediaModel.coupon.details = %@", pMediaModel.coupon.details);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [PhotoponMediaModel setNewPhotoponDraft:pMediaModel];
    
    return [[PhotoponMediaModel newPhotoponDraft] coupon];
}

- (void)prepareNextStepInBackgroundWithBlock:(void (^)(NSError *error, PhotoponCouponModel *coupon))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Page Control"
                                                         message:[NSString stringWithFormat:@"currentPage: %i", self.photoponPagesScrollView.currentPage]
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles:nil];
    [alertCheck show];
    */
    
    
    NSError *error;
    PhotoponCouponModel *coupon = [self processedObjectAtIndexPath:[NSIndexPath indexPathForRow:self.photoponPagesScrollView.currentPage inSection:0]];
    
    if (block)
        block(error, coupon);
}

- (void) setUpPhotoponConfig{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
    //self.methodParams = [[NSMutableDictionary alloc] init];
    
    self.objectsPerPage = 16;
    
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
    
    [self.methodParams setObject:[[NSString alloc] initWithString: kPhotoponCouponClassName] forKey:kPhotoponEntityNameKey];
    
    [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
    
    
    
    // redundant - now handled by updateCurrentOffset method
    //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
    
    // set defaults
    [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
    
    self.paginationEnabled = YES;
    
    @synchronized(self) {
        //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
        if (!currentUserID || !currentUserID.length>0) {
            currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
        }
        [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
    }
    
    
    
    
}

/*
- (void)photoponOffersTableViewController:(PhotoponOffersTableViewController *)photoponOffersTableViewController didTapCouponButton:(UIButton *)button offer:(Photopon8CouponsModel *)offer{
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [offer sanitize];
    
    PhotoponMediaModel *pMediaModel = [PhotoponMediaModel newPhotoponDraft];
    
    [pMediaModel convert8CouponsDictToCoupons:offer.dictionary];
    
    //[[PhotoponMediaModel newPhotoponDraft].dictionary setObject:offer forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated:YES completion:^{");
        [self.photoponBtnNext setEnabled:YES];
    }];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"------->            pMediaModel.coupon.details = %@", pMediaModel.coupon.details);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.offerOverlay setDetail:pMediaModel.coupon.details offerValue:pMediaModel.coupon.details];
    
    [self.photoponBtnNext setEnabled:YES];
    
    [PhotoponMediaModel setNewPhotoponDraft:pMediaModel];
}

- (void)photoponOffersTableViewController:(PhotoponOffersTableViewController *)photoponOffersTableViewController didCloseAnimated:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissViewControllerAnimated:animated completion:nil];
}
*/


- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
