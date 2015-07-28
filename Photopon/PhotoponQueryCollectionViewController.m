//
//  PhotoponQueryCollectionViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/12/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponQueryCollectionViewController.h"
#import "PhotoponTableViewCell.h"
#import "PhotoponModelManager.h"
#import "PhotoponMediaModel.h"
#import "PhotoponApplicationKey.h"
#import "PhotoponModel.h"
#import "PhotoponAppDelegate.h"
#import "MBProgressHUD.h"
#import "PhotoponInfoView.h"
#import "PhotoponNestedDetailViewController.h"
#import <unistd.h>
#import "PhotoponCollectionViewCell.h"

// Macros
//#define DKSynthesize(x) @synthesize x = x##_;


@interface PhotoponQueryCollectionViewController () <MBProgressHUDDelegate>{
    
}

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSUInteger currentOffset;
@property (nonatomic, strong, readwrite) NSMutableArray *objects;
@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchOverlay;
@property (nonatomic, assign) BOOL searchTextChanged;
@property (nonatomic, strong) NSMutableArray * orSkip;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *noResultsView;

- (void)configureNoResultsView;

@end

@interface PhotoponQueryCollectionNextPageCell : PhotoponCollectionViewCell
@property (nonatomic, strong) UIActivityIndicatorView *activityAccessoryView;
@end


@implementation PhotoponQueryCollectionViewController{
    PhotoponModelManager *_pmm;
    NSString *_methodName;
    UIView *noResultsView;
}

//@synthesize pmm;
@synthesize HUD;
@synthesize photoponBackgroundImageNameString;
@synthesize photoponBackgroundImageView;
@synthesize photoponBackgroundImage;
@synthesize rootObject;
@synthesize noResultsView;
@synthesize methodParams;
@synthesize emptyTableImageName;
@synthesize hasMore;
@synthesize currentOffset;
@synthesize objects;
@synthesize searchBar;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithCollectionViewLayout:layout];// initWithEntityName:kPhotoponMediaClassName];
    if (self) {
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 10;
        self.currentOffset = 0;
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.methodParams setObject:[[NSString alloc] initWithString: kPhotoponMediaClassName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:uidString forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"media_models"] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       2");
        
        // Search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.delegate = (id)self;
        self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       3");
        
        // Search overlay
        self.searchOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self.searchOverlay addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponModelIdentifierKey];
}

-(NSString*)methodName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodNameKey];
}

-(NSString*)entityName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponEntityNameKey];
}

-(NSString*)methodNameSearchText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodSearchTextKey];
}

-(NSString*)methodReturnedModelsKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodReturnedModelsKey];
}

-(NSString*) className{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.methodParams) {
        return [self.methodParams objectForKey:kPhotoponEntityNameKey];
    }else{
        return self.entityName;
    }
}

-(void) setClassName:(NSString *)className_{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.methodParams setObject:className_ forKey:kPhotoponEntityNameKey];
}

-(NSString*) keyToDisplay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.displayedTitleKey;
}

-(void) setKeyToDisplay:(NSString *)keyToDisplay_{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.displayedTitleKey = keyToDisplay_;
}
/*
 - (id)initWithStyle:(UITableViewStyle)otherStyle{
 return [self initWithStyle:otherStyle];
 }
 */

-(void)initTitleLabelWithText:(NSString*)title{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor grayColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(title, @"");
    [label sizeToFit];
    
}

- (void)loadObjects{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[self reloadInBackground];
}

- (void)loadNextPage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
    [self appendNextPageWithFinishCallback:^(NSError *error){
        
    }];
}

- (void)showEmptyTableWithImageName:(NSString*)imageName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // this should be overridden but if it's not then show a generic empty message view
    if (!imageName) {
        // set default image
        imageName = [[NSString alloc] initWithFormat:@"%@", @"PhotoponEmptyTable.png" ];
    }
    
    NSLog(@"Table is empty");
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.collectionView.bounds];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setBackgroundView:imageView];
    //self.collectionView.separatorStyle = UICollect;
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoponCollectionViewCell"];
    
    [self.collectionView registerClass:[PhotoponCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoponCollectionViewCell"];
    
    
    //UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //[myLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //[self.collectionView setCollectionViewLayout:myLayout];
    
    
    
    [self initHUD];
    
    [self configureNoResultsView];
    
    if (IS_IPAD) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite-768.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.textField setBackground:textFieldImage];
    
    [self.collectionView reloadData];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    
    if(self.pullToRefreshEnabled){
        if (self.refreshHeaderView == nil) {
            Photopon_EGORefreshTableHeaderView *egoView = [[Photopon_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.bounds.size.height, self.view.frame.size.width, self.collectionView.bounds.size.height)];
            egoView.delegate = self;
            [self.collectionView addSubview:egoView];
            self.refreshHeaderView = egoView;
        }
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
    
    [self reloadInBackground];
    
    
    
    NSLog(@"Total number of rows = %d ", [self.objects count]);
    
    if (rootObject) {
        
        UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateNormal];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateHighlighted];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateSelected];
        [signOutButton setFrame:CGRectMake( 0.0f, 0.0f, 39.0f, 30.0f)];
        [signOutButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     
     if ([self.objects count] == 0)
     {
     [self configureNoResultsView];
     //[self showEmptyTableWithImageName:@"PhotoponEmptyTable@2x.png"];
     
     }
     else
     {
     [self.tableView setBackgroundView:nil];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
     [self.tableView setBackgroundColor:[UIColor clearColor]];
     }
     //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
     */
    
}

- (void)viewDidUnload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidUnload];
    self.refreshHeaderView = nil;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // 1
    
    /*
     [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
     if(results && [results count] > 0) {
     // 2
     if(![self.searches containsObject:searchTerm]) {
     NSLog(@"Found %d photos matching %@", [results count],searchTerm);
     [self.searches insertObject:searchTerm atIndex:0];
     self.searchResults[searchTerm] = results; }
     // 3
     dispatch_async(dispatch_get_main_queue(), ^{
     // Placeholder: reload collectionview data
     });
     } else { // 1
     NSLog(@"Error searching Flickr: %@", error.localizedDescription);
     } }];
     */
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.objects.count + (self.hasMore ? 1 : 0);
    
    //NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
    
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 2;//self.objects.count;
    
    //return [self.searches count];
}

// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/




#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *searchTerm = self.searches[indexPath.section];
    
    //FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.row];
    // 2
    //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    //retval.height += 35; retval.width += 35; return retval;
}

// 3
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoponCollectionViewCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    cell.imageView = self.searchResults[searchTerm]
    [indexPath.row];
    return cell;
    
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(NSDictionary *)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self collectionViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return [self collectionViewNextPageCell:collectionView indexPath:indexPath];
    }
    
    UICollectionViewCell *cell = [self newCellForIndexPath:indexPath];
    
    /*
    if (IS_IPAD || self.collectionView.isEditing) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }*/
    
    
    
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    
    return cell;
}

- (void) backButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UICollectionViewCell *)newCellForIndexPath:(NSIndexPath*)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    //NSString *cellIdentifier = [NSString stringWithFormat:@"_PCollection_%@_Cell", [self.methodParams objectForKey:kPhotoponEntityNameKey]];
    NSString *cellIdentifier = [NSString stringWithFormat:@"PhotoponCollectionViewCell"];
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    return cell;
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView
 cellForRowAtIndexPath:(NSIndexPath *)indexPath
 object:(PhotoponModel *)object{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
 return [self tableViewNextPageCell:tableView];
 }
 
 
 static NSString *identifier = @"PhotoponModelTableCell";
 PhotoponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
 if (cell == nil) {
 cell = [[PhotoponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 }
 
 if (self.displayedTitleKey.length > 0) {
 cell.textLabel.text = [object objectForKey:self.displayedTitleKey];
 }
 if (self.displayedImageKey.length > 0) {
 cell.imageView.image = [UIImage imageWithData:[object objectForKey:self.displayedImageKey]];
 }
 
 
 
 return cell;
 }
 */
- (PhotoponMediaModel *)objectAtIndexPath:(NSIndexPath *)indexPath{
	return [PhotoponMediaModel modelWithDictionary:[self.objects objectAtIndex:indexPath.row]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if ([self collectionViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return [self collectionViewNextPageCell:collectionView indexPath:indexPath];
    }
	else{
        return [self collectionView:collectionView cellForNextPageAtIndexPath:indexPath];
	}
}

-(PhotoponModelManager*)pmm{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    if (_pmm) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (_pmm) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        return _pmm;
    }
    if (self.rootObject) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.rootObject) {          TRUE TRUE TRUE", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        _pmm = [[PhotoponModelManager alloc] init];
    }else{
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.rootObject) {          FALSE FALSE FALSE", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        _pmm = [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] pmm];
    }
    return _pmm;
}

- (void)objectsWillLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    
    //if (self.objects==0)
    //[self configureNoResultsView];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
    [noResultsView removeFromSuperview];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return self.isLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return [self lastSyncDate];
}

//  PhotoponQueryTableViewController implementation (modified)
//
//  PhotoponQueryTableViewController.m
//  PhotoponModelManager
//

- (id)init{
    
    self = [self initWithEntityName:kPhotoponMediaClassName];
    if (self) {
        
    }
    return self;
}

- (id)initWithRootObject:(NSDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithStyle:nil rootObject:_rootObject];
    if (self) {
        
    }
    return self;
}

- (id)initWithEntityName:(NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithStyle:UITableViewStylePlain entityName:entityName];
    if (self) {
        
    }
    return self;
}

/**
 Initializes a new query table for the specified entity
 @param style The table view style
 @param rootObject The root dictionary displayed in the table
 @return The initialized query table
 */

- (id)initWithStyle:(UICollectionViewLayout*)layout rootObject:(NSDictionary *)_rootObject{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    self = [self initWithFrame:[[UIScreen mainScreen] applicationFrame] collectionViewLayout:layout];
    if (self) {
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       1");
        
        self.rootObject = _rootObject;
        
        self.objectsPerPage = 10;
        self.currentOffset = 0;
        
        self.methodParams = [[NSMutableDictionary alloc] init];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponEntityNameKey] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:@"media_models" forKey:kPhotoponMethodReturnedModelsKey];
        
        
        
        self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
        
        // Search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.delegate = (id)self;
        self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       3");
        
        // Search overlay
        self.searchOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self.searchOverlay addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    NSLog(@"PhotoponQueryCollectionViewController initWithStyle       4");
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 10;
        self.currentOffset = 0;
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:uidString forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"media_models"] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       2");
        
        // Search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.delegate = (id)self;
        self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
        
        NSLog(@"PhotoponQueryCollectionViewController initWithStyle       3");
        
        // Search overlay
        self.searchOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self.searchOverlay addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSLog(@"PhotoponQueryCollectionViewController initWithStyle       4");
    
    return self;
}

- (void)processQueryResults:(NSArray *)results error:(NSError *)error callback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"query results not processed on main queue");
    
    if (results != nil && ![results isKindOfClass:[NSArray class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:NSLocalizedString(@"Query did not return a result NSArray or nil", nil)];
        return;
    } else if ([results isKindOfClass:[NSArray class]]) {
        for (id object in results) {
            if (!([object isKindOfClass:[PhotoponModel class]] || [object isKindOfClass:[PhotoponUserModel class]] || [object isKindOfClass:[PhotoponMediaModel class]] || [object isKindOfClass:[NSDictionary class]])) {
                [NSException raise:NSInternalInconsistencyException
                            format:NSLocalizedString(@"Query results contained invalid objects", nil)];
                return;
            }
        }
    }
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Results", nil)
     message:[NSString stringWithFormat:@"Count: %i", results.count]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
     [alert show];
    */
    
    if (results.count > 0) {
        // temp fix
		[self.objects addObjectsFromArray:results];
        
        //self.objects = [NSMutableArray arrayWithArray:results];
    }
    
    self.currentOffset += results.count;
    [self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
    self.hasMore = (results.count == self.objectsPerPage);
    self.isLoading = NO;
    self.collectionView.userInteractionEnabled = YES;
    
    if (error != nil) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
    }
    
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf postProcessResults];
        
        dispatch_async(q, ^{
            
            [self objectsWillLoad];
            
			[self.collectionView reloadData];
            
            [self objectsDidLoad:error];
            
            if (callback != NULL) {
                callback(error);
            }
        });
    });
}

- (void)appendNextPageWithFinishCallback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    callback = [callback copy];
    
    self.isLoading = YES;
    self.collectionView.userInteractionEnabled = NO;
    
    
    NSString *queryText = self.searchBar.text;
    
    NSArray *params = [[NSArray alloc] initWithArray:[self paramsForCollection]];
    
    NSDictionary *config;
    
    
    
    
    // Form search query for text if possible
    if ([self hasSearchBar] && queryText.length > 0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar] && queryText.length > 0) {       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        // pmm callMethodWithSearchText
        
        //q = [self tableMethodForSearchText];
        config = [[NSDictionary alloc] initWithObjectsAndKeys:
                  self.methodName, kPhotoponMethodSearchTextKey,
                  params, kPhotoponMethodParamsKey, nil];
        
        [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    config = [[NSDictionary alloc] initWithObjectsAndKeys:
              self.methodName, kPhotoponMethodNameKey,
              params, kPhotoponMethodParamsKey, nil];
    
    if([[self entityName] isEqualToString:kPhotoponMediaClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponMediaClassKey){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // IMPORTANT: First we have to check if this timeline table is contained in a detail view controller
        //            If it is, we need to pass the userID to the sync method
        //            Otherwise, we can just call the standard timeline sync method which uses the currentUser
        
        [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            
            // temporarily fake results
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [[NSArray alloc] initWithArray:[self fakeMediaResultsArray]], self.methodReturnedModelsKey,
                                        nil];
            
            
            
            
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    
    /** Otherwise, call next page method based on entityName
     */
    if([PhotoponApplicationKey isPhotoponUserKey:self.entityName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if([PhotoponApplicationKey isPhotoponUserKey:self.entityName]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponGeoPointKey:self.entityName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponGeoPointKey:self.entityName]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
        
        
    }
    else if([PhotoponApplicationKey isPhotoponMediaModelKey:self.entityName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponMediaModelKey:self.entityName]){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }
    else if([PhotoponApplicationKey isPhotoponCommentModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponCommentModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponCouponModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponCouponModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponTagModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponTagModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponActivityModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponActivityModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    
    
    
    /*
     [self.pmm findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
     
     //self.currentOffset =
     [self processQueryResults:results error:error callback:callback];
     
     }];
     */
    
    
    
    //NSAssert(q != nil, @"method cannot be nil");
    
    //self.currentOffset;
    //self.objectsPerPage;
    
    /*
     if (mr != nil) {
     [q performMapReduce:mr inBackgroundWithBlock:^(id result, NSError *error) {
     self.orSkip = q.orSkip;
     [self processQueryResults:result error:error callback:callback];
     }];
     }
     else {
     [q findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
     self.orSkip = q.orSkip;
     [self processQueryResults:results error:error callback:callback];
     }];
     }*/
}

- (NSArray*)fakeMediaResultsArray{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
     @property (readonly) NSString* identifier;
     @property (readonly) PhotoponGeoPointModel * coordinate;
     @property (readonly) NSString* value;
     @property (readonly) NSString *cost;
     
     @property (readonly) NSNumber* monetaryValue;
     @property (readonly) NSNumber* socialValue;
     @property (readonly) NSString* caption;
     @property (readonly) NSString* linkURL;
     @property (readonly) NSUInteger likeCount;
     @property (readonly) NSUInteger commentCount;
     @property (readonly) NSUInteger snipCount;
     @property (readonly) PhotoponUserModel* user;
     @property (readonly) PhotoponCouponModel* coupon;
     
     //@property (readonly) PhotoponPlace* place;
     //@property (readonly) PhotoponCouponModel* coupon;
     //@property (readonly) PhotoponImageModel* image;
     
     @property (readonly) NSString* couponId;
     //@property (nonatomic,strong) PhotoponImageModel* image;
     
     @property (readonly) NSString* thumbURL;
     @property (readonly) NSString* imageMidURL;
     @property (readonly) NSString* imageLargeURL;
     @property (readonly) NSString* locationIdentifier;
     @property (readonly) NSString* locationLatitude;
     @property (readonly) NSString* locationLongitude;
     @property (readonly) NSDate* createdTime;
     @property (readonly) NSDictionary* users;
     @property (readonly) NSDictionary* tags;
     */
    
    NSMutableArray *fakeMediaArr = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<3; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponMediaAttributesIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponMediaAttributesCaptionKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesLikeCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesCommentCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesSnipCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesMonetaryValueKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesSnippersKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesSocialValueKey];
        [dict setObject:[[NSDictionary alloc] init] forKey:kPhotoponMediaAttributesTagsKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesThumbURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesUserKey];
        [dict setObject:[[NSDictionary alloc] init] forKey:kPhotoponMediaAttributesUsersKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesValueTitleKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationLongitudeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationLatitudeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLinkURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLikersKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesImageMidURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesImageLargeURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesDidSnipKey];
        [dict setObject:[[NSNumber alloc] initWithBool:YES] forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesDidLikeKey];
        [dict setObject:[[NSNumber alloc] initWithBool:YES] forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCreatedTimeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCouponKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCostKey];
        //[dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCoordinateKey];
        //[dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCommentersKey];
        
        [fakeMediaArr addObject:dict];
        
    }
    
    //return [NSArray arrayWithArray:fakeMediaArr];
    
    return [PhotoponMediaModel modelsFromDictionaries:fakeMediaArr];
    
}

- (void)reloadInBackground {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![appDelegate validateDeviceConnection]) {
        return;
    }
    
    if (self.currentOffset>0)
        [self showHUDWithStatusText:@"Refreshing"];
    else
        [self showHUDWithStatusText:@"Loading"];
    
    NSDictionary *timerUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"currentUserID", [PhotoponUserModel currentUser].identifier, nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleReloadInBackgroundTimeout:) userInfo:@{@"currentUser":timerUserInfo} repeats:NO];
    
    [noResultsView removeFromSuperview];
    
    [self reloadInBackgroundWithBlock:^(NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self reloadInBackgroundWithBlock:^(NSError *error){ ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [timer invalidate];
        
        [self configureNoResultsView];// removeFromSuperview];
        
        [self hideHud];
        
    }];
    
    
}

- (void)handleReloadInBackgroundTimeout:(NSTimer*)aTimer {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    dispatch_async(q, ^{
        
        [self updateHUDWithStatusText:@"Request timed out" mode:MBProgressHUDModeText];
        
        [self hideHudAfterDelay:1.0];
        
        [self configureNoResultsView];
        
    });
    
}

- (void)reloadInBackgroundWithBlock:(void (^)(NSError *))block {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
	
    // Display search bar if necessary
    if ([self hasSearchBar]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar]) { ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //self.co = self.searchBar;
    } else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar]) { ... }  else { ... ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.searchOverlay removeFromSuperview];
        //self.collectionView.tableHeaderView = nil;
    }
    
    self.hasMore = NO;
    self.currentOffset = 0;
	[self.objects removeAllObjects];
	[self.collectionView reloadData];
    [self appendNextPageWithFinishCallback:block];
    
}

- (void)reloadInBackgroundIfSearchTextChanged {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.searchTextChanged) {
        self.searchTextChanged = NO;
        [self reloadInBackground];
    }
}

- (void)postProcessResults {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self objectsDidLoad:nil];
}

- (NSObject *)tableQueryMapReduce {
    return nil;
}

- (BOOL)hasSearchBar {
    return NO;
}

- (void)loadNextPageWithNextPageCell:(PhotoponQueryCollectionNextPageCell *)cell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
    [cell.activityAccessoryView startAnimating];
    [cell setNeedsLayout];
    
    [self appendNextPageWithFinishCallback:^(NSError *error){
        
        [cell.activityAccessoryView stopAnimating];
        [cell setNeedsLayout];
        
    }];
    
}

#pragma mark UITableViewDelegate & Related

- (BOOL)collectionViewCellIsNextPageCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (self.hasMore && (indexPath.row == self.objects.count));
}

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    id object = [self objectAtIndexPath:indexPath];
    return [self collectionView:collectionView cellForItemAtIndexPath:indexPath object:object];
}
*/

- (PhotoponCollectionViewCell *)collectionViewNextPageCell:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *identifier = @"PhotoponQueryCollectionNextPageCell";
    PhotoponQueryCollectionNextPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PhotoponQueryCollectionNextPageCell alloc] init];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //cell. .text = [NSString stringWithFormat:NSLocalizedString(@"%i more ...", nil), self.objectsPerPage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
     PhotoponQueryTableNextPageCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
     [self loadNextPageWithNextPageCell:cell];
     }
     else {
     [self tableView:tableView didSelectRowAtIndexPath:indexPath object:[self.objects objectAtIndex:indexPath.row]];
     }
     */
    [self tableView:tableView didSelectRowAtIndexPath:indexPath object:[self.objects objectAtIndex:indexPath.row]];
}
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(PhotoponUITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
 
 if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
 PhotoponQueryTableNextPageCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
 [self loadNextPageWithNextPageCell:cell];
 }
 
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    // stub
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponNestedDetailViewController *photoponNestedDetailViewController = [[PhotoponNestedDetailViewController alloc] initWithNibName:@"PhotoponNestedDetailViewController" bundle:nil];
    
    PhotoponNestedDetailViewController *photoponNestedDetailViewController = [[PhotoponNestedDetailViewController alloc] initWithRootObject:(NSDictionary*)object];
    //[self.navigationController pushViewController:photoponNestedDetailViewController animated:YES];
    [self.navigationController pushPhotoponViewController:photoponNestedDetailViewController];
}

#pragma mark UISearchBarDelegate & Overlay

- (void)dismissOverlay:(UIButton *)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [sender removeFromSuperview];
    [self.searchBar resignFirstResponder];
    [self reloadInBackgroundIfSearchTextChanged];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.searchOverlay removeFromSuperview];
    [self.searchBar resignFirstResponder];
    [self reloadInBackgroundIfSearchTextChanged];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGRect bounds = self.collectionView.bounds;
    CGRect barBounds = self.searchBar.bounds;
    CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
                                     CGRectGetMaxY(barBounds),
                                     CGRectGetWidth(barBounds),
                                     CGRectGetHeight(bounds) - CGRectGetHeight(barBounds));
    
    self.searchOverlay.frame = overlayFrame;
    
    [self.collectionView addSubview:self.searchOverlay];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.searchTextChanged = YES;
}

- (void)configureNoResultsView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![self isViewLoaded]) return;
    
    [self.noResultsView removeFromSuperview];
    
    if (self.objects && [self.objects count] == 0 && !self.isLoading) {
        // Show no results view.
        
        NSString *ttl = NSLocalizedString(@"No %@ yet", @"A string format. The '%@' will be replaced by the relevant type of object, posts, pages or comments.");
        ttl = [NSString stringWithFormat:ttl, [[self entityName] lowercaseString]];
        
        NSString *msg = @"";
        //if ([self userCanCreateEntity]) {
        msg = NSLocalizedString(@"Why not create one?", @"A call to action to create a post or page.");
        //}
        
        self.noResultsView = [PhotoponInfoView PhotoponInfoViewWithTitle:ttl
                                                                 message:msg
                                                            cancelButton:nil];
        
        [self.collectionView addSubview:self.noResultsView];
    }
    
}

#pragma mark - HUD methods

- (void) initHUD {
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.collectionView];
	[self.collectionView addSubview:HUD];
	HUD.delegate = self;
    HUD.labelText = @"Logging In";
	//HUD.minSize = CGSizeMake(140.f, 115.f);
}

- (void) showHUD {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD show:YES];
}

- (void) showHUDWithStatusText:(NSString*)status {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!status || status.length==0) {
        status = @"Loading";
    }
    HUD.labelText = status;
	
    HUD.removeFromSuperViewOnHide = NO;
    
    [self showHUD];
    
}

- (void) showHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (!status || status.length==0) {
        status = @"Loading";
    }
    HUD.mode = mode;
    HUD.labelText = status;
	HUD.removeFromSuperViewOnHide = NO;
    
    [self showHUD];
    
}

-(void) hideHud{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD hide:YES];
}

-(void) hideHudAfterDelay:(float)delay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD hide:YES afterDelay:delay];
}

- (void) updateHUDWithStatusText:(NSString*)status{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //sleep(2);
    
    if ([status isEqualToString:@"Complete"]) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"You're Logged In!";
        [HUD hide:YES afterDelay:1.0];
    }else{
        // Switch to determinate mode
        //HUD.mode = MBProgressHUDModeDeterminate;
        
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = status;
        //sleep(2);
    }
}

- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //sleep(2);
    
    HUD.mode = mode;
    
    if ([status isEqualToString:@"Complete"]) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"You're Logged In!";
        [HUD hide:YES afterDelay:1.0];
    }else{
        // Switch to determinate mode
        //HUD.mode = MBProgressHUDModeDeterminate;
        
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = status;
        //sleep(2);
    }
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}






#define AssertSubclassMethod() NSAssert(false, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))
#define AssertNoBlogSubclassMethod() NSAssert(self.blog, @"You must override %@ in a subclass if there is no blog", NSStringFromSelector(_cmd))

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type"

- (NSMutableArray *)paramsForCollection{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    //NSArray *params = [NSArray arrayWithObjects:self.pmm.currentUser.identifier, [NSNumber numberWithInt:self.currentOffset], nil];
    
    // temp fix until brian uploads updated php server file
    //NSArray *params =  [NSArray arrayWithObjects:self.pmm.currentUser.identifier, [NSNumber numberWithInt:self.currentOffset+self.objectsPerPage], nil];
    
    AssertSubclassMethod();
}

- (NSDate *)lastSyncDate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (void)configureCell:(PhotoponCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object{
    
    
    //AssertSubclassMethod();

}





@end



@implementation PhotoponQueryCollectionNextPageCell
//DKSynthesize(activityAccessoryView)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        UIActivityIndicatorView *accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        accessoryView.hidesWhenStopped = YES;
        
        self.activityAccessoryView = accessoryView;
        
        [self.contentView addSubview:self.activityAccessoryView];
        /*
        selftextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
         */
    }
    return self;
}

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    
    BOOL isAnimating = self.activityAccessoryView.isAnimating;
    
    
    // Center text label
    //UIFont *font = self.textLabel.font;
    //NSString *text = self.textLabel.text;
    
    CGRect bounds = self.bounds;
    /*CGSize textSize = [text sizeWithFont:font
                                forWidth:CGRectGetWidth(bounds)
                           lineBreakMode:UILineBreakModeTailTruncation];
     */
    CGSize spinnerSize = self.activityAccessoryView.frame.size;
    CGFloat padding = 10.0;
    
    
    /*
    CGRect textFrame = CGRectMake((CGRectGetWidth(bounds) - textSize.width - (isAnimating ? spinnerSize.width - padding : 0)) / 2.0,
                                  (CGRectGetHeight(bounds) - textSize.height) / 2.0,
                                  textSize.width,
                                  textSize.height);
    
    self.textLabel.frame = CGRectIntegral(textFrame);
    * /
    
    
    if (isAnimating) {
        / *
        CGRect spinnerFrame = CGRectMake(CGRectGetMaxX(textFrame) + padding,
                                         (CGRectGetHeight(bounds) - spinnerSize.height) / 2.0,
                                         spinnerSize.width,
                                         spinnerSize.height);
        
        self.activityAccessoryView.frame = spinnerFrame;
    }
     */
}

#pragma mark - Subclass methods

- (BOOL)userCanCreateEntity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return NO;
}

@end