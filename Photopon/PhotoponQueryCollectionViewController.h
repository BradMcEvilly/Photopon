//
//  PhotoponQueryCollectionViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/12/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photopon_EGORefreshTableHeaderView.h"
#import "PhotoponModelManager.h"
#import "MBProgressHUD.h"

@interface PhotoponQueryCollectionViewController : UICollectionViewController <UITextFieldDelegate, Photopon_EGORefreshTableHeaderDelegate,UIScrollViewDelegate, MBProgressHUDDelegate, UITableViewDelegate>
{
    
    UIImageView *photoponBackgroundImageView;
    UIImage *photoponBackgroundImage;
    NSString *photoponBackgroundImageNameString;
    
	long long expectedLength;
	long long currentLength;
    
}

@property(nonatomic, strong) UIImageView *photoponBackgroundImageView;
@property(nonatomic, strong) UIImage *photoponBackgroundImage;
@property(nonatomic, strong) NSString *photoponBackgroundImageNameString;

@property (nonatomic, strong) Photopon_EGORefreshTableHeaderView * refreshHeaderView;
@property (readonly) NSString *className;
@property (nonatomic, assign) BOOL pullToRefreshEnabled;
@property (nonatomic, assign) BOOL paginationEnabled;
@property (nonatomic,strong) NSString *keyToDisplay;
@property (nonatomic,strong) NSString *emptyTableImageName;
@property (readonly) PhotoponModelManager* pmm;

@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;

- (id)initWithStyle:(UITableViewStyle)otherStyle;
- (NSObject *)queryForCollection;
- (id)entityForTable;
//- (PhotoponM)modelForTable
- (void)loadObjects;
- (void)loadNextPage;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponModel *)object;
- (PhotoponMediaModel *)objectAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath;
- (void)objectsWillLoad;
- (void)objectsDidLoad:(NSError *)error;



- (void) showHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status;

- (void) hideHud;

- (void) hideHudAfterDelay:(float)delay;

-(void) showToolTipImageName:(NSString*)imageName;

//DKQueryTableViewController implementation with PFQuery and PFTableViewCell
//
//  DKQueryTableViewController.h
//  DataKit
//
//  Created by Erik Aigner on 05.03.12.
//  Copyright (c) 2012 chocomoko.com. All rights reserved.
//

/** @name Initializing Entity Tables */

/**
 Initializes a new query table for the specified entity
 @param entityName The entity name displayed in the table
 @return The initialized query table
 */
- (id)initWithEntityName:(NSString *)entityName;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

/**
 Initializes a new query table for the specified entity
 @param style The table view style
 @param entityName The entity name displayed in the table
 @return The initialized query table
 */
- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)entityName methodName:(NSString*)methodName;

/**
 Initializes a new query table for the specified entity
 @param style The table view style
 @param entityName The entity name displayed in the table
 @return The initialized query table
 */
- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)entityName;

/**
 Initializes a new query table for the specified entity
 @param style The table view style
 @param rootObject The root dictionary displayed in the table
 @return The initialized query table
 */

- (id)initWithRootObject:(NSDictionary*)_rootObject;

-(void)initTitleLabelWithText:(NSString*)title;

/** @name Configuration */

/**
 The api method name used for the table
 */
@property (readonly) NSString *identifier;

/**
 The entity name used for the table
 */
@property (readonly) NSString *entityName;

/**
 The api method name used for the table
 */
@property (readonly) NSString *methodName;

/**
 The api method name used for the table
 */
@property (readonly) NSString *methodNameSearchText;

/**
 The api method name used for the table
 */
@property (readonly) NSString *methodReturnedModelsKey;

/**
 The root data object for the table (only if table is a detail view controller being pushed)
 */
@property (nonatomic, copy) NSDictionary *rootObject;

/**
 The api method parameters required for the table
 */
@property (nonatomic, strong) NSMutableDictionary *methodParams;

/**
 The entity key to use for the cell title text
 */
@property (nonatomic, copy) NSString *displayedTitleKey;

/**
 The entity key to use for the cell image data
 */
@property (nonatomic, copy) NSString *displayedImageKey;

/**
 The number of objects displayed per page
 */
@property (nonatomic, assign) NSUInteger objectsPerPage;

/**
 If the table view is currently fetching a page
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 The currently loaded objects
 
 Objects can be either of type <PhotoponModel> or NSDictionary
 */
@property (nonatomic, strong, readonly) NSMutableArray *objects;

/**
 The search bar
 
 Use this property to configure it.
 */
@property (nonatomic, strong, readonly) UISearchBar *searchBar;

/** @name Reloading */

/**
 Reloads the table in the background
 */
- (void)reloadInBackground;

/**
 Reloads the table in the background
 @param block The block that is called when the reload finished.
 */
- (void)reloadInBackgroundWithBlock:(void (^)(NSError *error))block;

/**
 Give subclasses a chance to do custom post processing on the table objects on a different queue.
 */
- (void)postProcessResults;

/** @name Methods to Override */

/**
 Determines if table shows a search bar in the header view
 
 The search bar is updated on each reload, so this property can change any time.
 @return `YES` if the table should display a search bar in the header, `NO` otherwise.
 */
- (BOOL)hasSearchBar;

/**
 Specify a custom query by overriding this method
 
 @return The query to use for the tables objects
 */
//- (PFQuery *)tableQuery;

/**
 Returns a method name for the entered search text
 
 @param text The api method name
 @return The api search method
 */
- (NSString *)tableMethodForSearchText:(NSString *)text;

/**
 Returns a method name for the entered search text
 
 @param text The api method name
 @return The api search method
 */
- (NSMutableArray *)paramsForCollection;

/**
 Specify a map reduce operation for the query by overriding this method
 
 Make sure the map reduce returns an array of NSDictionaries so the query table can interprete the results as entities. You can do so by setting an appropriate result processor block on the map reduce. If <tableQuery> returns `nil` this method won't be called.
 @return The map reduce to use to display the table objects
 */
//- (DKMapReduce *)tableQueryMapReduce;

/**
 Determines if the cell at the index path is a next-page cell
 @param indexPath The cell index path to check.
 @return NO if the cell represents a <DKEntity>, YES if it is the next-page cell.
 */
- (BOOL)collectionViewCellIsNextPageCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns the cell for the given index path
 @param tableView The calling table view
 @param indexPath The index path for the cell
 @return The initialized or dequeued table cell
 */
- (UICollectionView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns the cell used as the next-page cell
 @param tableView The calling table view
 @return The initialized or dequeued next-page cell
 */
//- (UITableViewCell *)tableViewNextPageCell:(UITableView *)tableView;

/**
 Called when a table row is selected
 @param tableView The calling table view
 @param indexPath The index path of the selected row
 @param object The selected object. Can be of type <DKEntity> or NSDictionary.
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;


- (void)handleReloadInBackgroundTimeout:(NSTimer*)aTimer;

- (void) backButtonHandler:(id)sender;

@end