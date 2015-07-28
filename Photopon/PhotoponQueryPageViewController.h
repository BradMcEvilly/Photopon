//
//  PhotoponQueryPageViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 8/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Photopon_EGORefreshTableHeaderView.h"
#import "PhotoponModelManager.h"
#import "MBProgressHUD.h"
#import "ASMediaFocusManager.h"
#import "FireUIPagedScrollView.h"

@class StyledPageControl;

@interface PhotoponQueryPageViewController :  UIViewController <MBProgressHUDDelegate, ASMediasFocusDelegate>
{
    UIImageView *photoponBackgroundImageView;
    UIImage *photoponBackgroundImage;
    NSString *photoponBackgroundImageNameString;
    
	long long expectedLength;
	long long currentLength;
}

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

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

@property (nonatomic, strong) NSDate* lastSync;

//@property

@property (nonatomic, strong) IBOutlet FireUIPagedScrollView * photoponPagesScrollView;

@property (nonatomic, strong) IBOutlet FireUIPagedScrollView * photoponActivityPagesScrollView;

@property(nonatomic,strong) IBOutlet UIView *photoponPagesContainerView;

//@property (nonatomic, strong) IBOutlet UIView *photoponToolTipOverlay;

@property (nonatomic, strong) IBOutlet StyledPageControl *photoponPageControl;

@property (nonatomic, strong) IBOutlet StyledPageControl *photoponActivityPageControl;

- (id)initWithStyle:(UITableViewStyle)otherStyle;
- (NSObject *)queryForTable;
- (id)entityForTable;
//- (PhotoponM)modelForTable
- (void)loadObjects;
- (void)loadNextPage;
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(id)object;
- (NSDictionary*)dictionaryAtIndexPath:(NSIndexPath *)indexPath;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath;
- (void)objectsWillLoad;
- (void)objectsDidLoad:(NSError *)error;



- (void) showHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode;

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString*)entityName;

/**
 Initializes a new query table for the specified entity
 @param entityName The entity name displayed in the table
 @return The initialized query table
 */
- (id)initWithEntityName:(NSString *)entityName;

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
@property (nonatomic, strong) NSMutableArray *objects;

/**
 The currently loaded view controllers
 
 Objects can be either of type <PhotoponModel> or NSDictionary
 */
@property (nonatomic, strong) NSMutableArray *controllers;

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
 */
- (NSMutableArray *)paramsForTable;

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
- (BOOL)tableViewCellIsNextPageCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns the cell for the given index path
 @param tableView The calling table view
 @param indexPath The index path for the cell
 @return The initialized or dequeued table cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;


- (void)handleReloadInBackgroundTimeout;

- (void) backButtonHandler:(id)sender;

- (UITableViewCell *)newCellWithObject:(id)object;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;


@end