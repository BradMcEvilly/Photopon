//
//  PAPConstants.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/25/12.
//

#import <Foundation/Foundation.h>
//#import "PhotoponModel.h"
//#import "PhotoponUserModel.h"

@class PhotoponModel;
@class PhotoponMediaModel;
@class PhotoponCouponModel;
@class PhotoponActivityModel;
@class PhotoponPlaceModel;
@class PhotoponUserModel;

typedef enum {
    PhotoponLogInFieldsFacebook = 1 << 3,
} PhotoponLogInFields;

typedef enum {
    kPhotoponCachePolicyIgnoreCache = 0,
    kPhotoponCachePolicyCacheOnly,
    kPhotoponCachePolicyNetworkOnly,
    kPhotoponCachePolicyCacheElseNetwork,
    kPhotoponCachePolicyNetworkElseCache,
    kPhotoponCachePolicyCacheThenNetwork
} PhotoponCachePolicy;

extern NSInteger const kPhotoponErrorObjectNotFound;
extern NSInteger const kPhotoponErrorCacheMiss;

typedef void (^PhotoponBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^PhotoponIntegerResultBlock)(int number, NSError *error);
typedef void (^PhotoponArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^PhotoponModelResultBlock)(PhotoponModel *photoponModel, NSError *error);
typedef void (^PhotoponMediaModelResultBlock)(PhotoponMediaModel *photoponMediaModel, NSError *error);
typedef void (^PhotoponCouponModelResultBlock)(PhotoponCouponModel *photoponCouponModel, NSError *error);
typedef void (^PhotoponPlaceModelResultBlock)(PhotoponPlaceModel *photoponPlaceModel, NSError *error);
typedef void (^PhotoponActivityModelResultBlock)(PhotoponActivityModel *photoponActivityModel, NSError *error);
typedef void (^PhotoponSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^PhotoponUserModelResultBlock)(PhotoponUserModel *photoponUserModel, NSError *error);
typedef void (^PhotoponDataResultBlock)(NSData *data, NSError *error);
typedef void (^PhotoponDataStreamResultBlock)(NSInputStream *stream, NSError *error);
typedef void (^PhotoponStringResultBlock)(NSString *string, NSError *error);
typedef void (^PhotoponIdResultBlock)(id object, NSError *error);
typedef void (^PhotoponProgressBlock)(int percentDone);



/*
typedef void (^PhotoponBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^PhotoponIntegerResultBlock)(int number, NSError *error);
typedef void (^PhotoponArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^PhotoponModelResultBlock)(PhotoponModel *object, NSError *error);
typedef void (^PhotoponSetResultBlock)(NSSet *channels, NSError *error);
//typedef void (^PhotoponUserModelResultBlock)(PhotoponUserModel *user, NSError *error);
typedef void (^PhotoponDataResultBlock)(NSData *data, NSError *error);
typedef void (^PhotoponDataStreamResultBlock)(NSInputStream *stream, NSError *error);
typedef void (^PhotoponProgressBlock)(int percentDone);
*/

//  API Method Param keys

//  8Coupons API Method Param Name keys
extern NSString *const k8CouponsAPIParamsKeyNameKey;
extern NSString *const k8CouponsAPIParamsRadiusNameKey;
extern NSString *const k8CouponsAPIParamsLimitNameKey;
extern NSString *const k8CouponsAPIParamsLatitudeNameKey;
extern NSString *const k8CouponsAPIParamsLongitudeNameKey;

//  8Coupons API Response Info - General
extern NSString *const k8CouponsAPIReturnDataDateFormat;
extern NSString *const k8CouponsAPIReturnDataExpirationDateFormat;

//  8Coupons API Response Data Keys
extern NSString *const k8CouponsAPIReturnDataAffiliateKey;
extern NSString *const k8CouponsAPIReturnDataNameKey;
extern NSString *const k8CouponsAPIReturnDataAddressKey;
extern NSString *const k8CouponsAPIReturnDataAddress2Key;
extern NSString *const k8CouponsAPIReturnDataStoreIDKey;
extern NSString *const k8CouponsAPIReturnDataChainIDKey;
extern NSString *const k8CouponsAPIReturnDataTotalDealsInThisStoreKey;
extern NSString *const k8CouponsAPIReturnDataHomepageKey;
extern NSString *const k8CouponsAPIReturnDataPhoneKey;
extern NSString *const k8CouponsAPIReturnDataStateKey;
extern NSString *const k8CouponsAPIReturnDataCityKey;
extern NSString *const k8CouponsAPIReturnDataZIPKey;
extern NSString *const k8CouponsAPIReturnDataURLKey;
extern NSString *const k8CouponsAPIReturnDataStoreURLKey;
extern NSString *const k8CouponsAPIReturnDataDealSourceKey;
extern NSString *const k8CouponsAPIReturnDataUserKey;
extern NSString *const k8CouponsAPIReturnDataUserIDKey;
extern NSString *const k8CouponsAPIReturnDataIDKey;
extern NSString *const k8CouponsAPIReturnDataDealTitleKey;
extern NSString *const k8CouponsAPIReturnDataDisclaimerKey;
extern NSString *const k8CouponsAPIReturnDataDealInfoKey;
extern NSString *const k8CouponsAPIReturnDataExpirationDateKey;
extern NSString *const k8CouponsAPIReturnDataPostDateKey;
extern NSString *const k8CouponsAPIReturnDataShowImageKey;
extern NSString *const k8CouponsAPIReturnDataShowImageStandardBigKey;
extern NSString *const k8CouponsAPIReturnDataShowImageStandardSmallKey;
extern NSString *const k8CouponsAPIReturnDataShowLogoKey;
extern NSString *const k8CouponsAPIReturnDataUpKey;
extern NSString *const k8CouponsAPIReturnDataDownKey;
extern NSString *const k8CouponsAPIReturnDataDealTypeIDKey;
extern NSString *const k8CouponsAPIReturnDataCategoryIDKey;
extern NSString *const k8CouponsAPIReturnDataSubCategoryIDKey;
extern NSString *const k8CouponsAPIReturnDataLatitudeKey;
extern NSString *const k8CouponsAPIReturnDataLongitudeKey;
extern NSString *const k8CouponsAPIReturnDataDistanceKey;
extern NSString *const k8CouponsAPIReturnDataDealOriginalPriceKey;
extern NSString *const k8CouponsAPIReturnDataDealPriceKey;
extern NSString *const k8CouponsAPIReturnDataDealSavingsKey;
extern NSString *const k8CouponsAPIReturnDataDealDiscountPercentKey;

//API Method Param keys
extern NSString *const kPhotoponCurrentOffsetKey;
extern NSString *const kPhotoponObjectsPerPageKey;
extern NSString *const kPhotoponMethodParamsKey;
extern NSString *const kPhotoponMethodNameKey;
extern NSString *const kPhotoponMethodFilterKey;
extern NSString *const kPhotoponMethodNameSearchKey;
extern NSString *const kPhotoponMethodSearchTextKey;
extern NSString *const kPhotoponMethodSearchScopeKey;
extern NSString *const kPhotoponMethodReturnedModelsKey;

extern NSString *const kPhotoponAPIReturnedCommentModelsKey;
extern NSString *const kPhotoponAPIReturnedMediaModelsKey;
extern NSString *const kPhotoponAPIReturnedCouponModelsKey;
extern NSString *const kPhotoponAPIReturnedHashTagModelsKey;
extern NSString *const kPhotoponAPIReturnedActivityModelsKey;
extern NSString *const kPhotoponAPIReturnedUserModelsKey;
extern NSString *const kPhotoponAPIReturnedModelsKey;

//Search scope keys
extern NSString *const kPhotoponSearchScopePeople;
extern NSString *const kPhotoponSearchScopePlaces;
extern NSString *const kPhotoponSearchScopeCoupons;
extern NSString *const kPhotoponSearchScopeHashtags;

//Search result keys
extern NSString *const kPhotoponSearchResultItemTitleKey;
extern NSString *const kPhotoponSearchResultItemIdentifier;
extern NSString *const kPhotoponSearchResultItemImageUrlStringKey;

//  Null Field String Comparison
extern NSString *const kPhotoponNullFieldString;
extern NSString *const kPhotoponNullDBDateFieldString;

// @"Y-m-d H:i:s HH:mm:ss Z"
extern NSString *const kPhotoponDateTextFormat;
extern NSString *const kPhotoponDateFormat;

//Class keys
extern NSString *const kPhotoponClassName;
extern NSString *const kPhotoponUserClassName;
extern NSString *const kPhotoponMediaClassName;
extern NSString *const kPhotoponCommentClassName;
extern NSString *const kPhotoponCouponClassName;
extern NSString *const kPhotopon8CouponsClassName;
extern NSString *const kPhotoponMerchantsClassName;
extern NSString *const kPhotoponPlaceClassName;
extern NSString *const kPhotoponActivityClassName;
extern NSString *const kPhotoponTagClassName;
extern NSString *const kPhotoponHashtagClassName;
extern NSString *const kPhotoponMentionClassName;

//  Photopon Merchants API Method Names
extern NSString *const kPhotoponMerchantsAPIMethodGetCoupons;
extern NSString *const kPhotoponMerchantsAPIMethodGetGifts;
// For Photopon 3.0
extern NSString *const kPhotoponMerchantsAPIMethodGetBrands;
extern NSString *const kPhotoponMerchantsAPIMethodSendCoupon;
extern NSString *const kPhotoponMerchantsAPIMethodSendGift;


//  Photopon API Method Names
extern NSString *const kPhotoponAPIMethodVerifyConnection;
extern NSString *const kPhotoponAPIMethodPostFeedback;
extern NSString *const kPhotoponAPIMethodCheckEmailExists;
extern NSString *const kPhotoponAPIMethodGetProfileInfo;
extern NSString *const kPhotoponAPIMethodUploadProfilePhoto;
extern NSString *const kPhotoponAPIMethodSearchPeople;
extern NSString *const kPhotoponAPIMethodSearchPlaces;
extern NSString *const kPhotoponAPIMethodSearchCoupons;
extern NSString *const kPhotoponAPIMethodSearchHashtags;
extern NSString *const kPhotoponAPIMethodSyncFBUser;
extern NSString *const kPhotoponAPIMethodSyncIGUser;
extern NSString *const kPhotoponAPIMethodSyncTUser;
extern NSString *const kPhotoponAPIMethodRegisterNewUser;
extern NSString *const kPhotoponAPIMethodGetNotifications;
extern NSString *const kPhotoponAPIMethodFacebookLogin;
extern NSString *const kPhotoponAPIMethodUploadPhotoponMediaFile;
extern NSString *const kPhotoponAPIMethodUploadPhotoponMediaMeta;
extern NSString *const kPhotoponAPIMethodUploadPhotopon;
extern NSString *const kPhotoponAPIMethodGetMyGallery;
extern NSString *const kPhotoponAPIMethodGetMyRedeemedGallery;
extern NSString *const kPhotoponAPIMethodGetOptions;
extern NSString *const kPhotoponAPIMethodUpdateExternalBlogPostStatus;
extern NSString *const kPhotoponAPIMethodDeleteExternalBlogPostStatus;
extern NSString *const kPhotoponAPIMethodUpdateProfileStatus;
extern NSString *const kPhotoponAPIMethodUpdateProfileInfo;
extern NSString *const kPhotoponAPIMethodGetTrendingHashTags;
extern NSString *const kPhotoponAPIMethodGetMyFeed;
extern NSString *const kPhotoponAPIMethodGetNearbyPhotopons;
extern NSString *const kPhotoponAPIMethodGetGlobalPopularPhotopons;
extern NSString *const kPhotoponAPIMethodGetGlobalRecentPhotopons;
extern NSString *const kPhotoponAPIMethodNewPostActivity;
extern NSString *const kPhotoponAPIMethodPostLike;
extern NSString *const kPhotoponAPIMethodPostUnlike;
extern NSString *const kPhotoponAPIMethodPostSnip;
extern NSString *const kPhotoponAPIMethodPostUnsnip;
extern NSString *const kPhotoponAPIMethodPostComment;
extern NSString *const kPhotoponAPIMethodPostFollow;
extern NSString *const kPhotoponAPIMethodPostUnfollow;
extern NSString *const kPhotoponAPIMethodGetComments;
extern NSString *const kPhotoponAPIMethodGetSnips;
extern NSString *const kPhotoponAPIMethodGetLikes;
extern NSString *const kPhotoponAPIMethodGetViews;
extern NSString *const kPhotoponAPIMethodGetFollowers;
extern NSString *const kPhotoponAPIMethodGetFollowing;
extern NSString *const kPhotoponAPIMethodGetActivity;
extern NSString *const kPhotoponAPIMethodGetPhotopons;
extern NSString *const kPhotoponAPIMethodGetMyFollowers;
extern NSString *const kPhotoponAPIMethodGetMyFollowing;
extern NSString *const kPhotoponAPIMethodWPUploadFile;
extern NSString *const kPhotoponAPIMethodWPNewPost;

typedef enum {
	PhotoponHomeTabBarItemIndex = 0,
    PhotoponExploreTabBarItemIndex = 1,
	PhotoponEmptyTabBarItemIndex = 2,
	PhotoponActivityTabBarItemIndex = 3,
    PhotoponProfileTabBarItemIndex = 4
} PhotoponTabBarControllerViewControllerIndex;


// Define an array of Facebook Ids for accounts to auto-follow on signup
#define kPhotoponAutoFollowAccountFacebookIds @[ ]


#pragma mark - NSUserDefaults
extern NSString *const kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kPhotoponUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs
extern NSString *const kPhotoponLaunchURLHostTakePicture;


#pragma mark - NSNotification


extern NSString *const PhotoponNotificationPhotoponNewPhotoponOffersViewControllerDidFindNoCoupons;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidShowShareApp;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidHideShareApp;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponPickerControllerDidChangeSourceType;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidOpenShutter;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidCloseShutter;
extern NSString *const PhotoponNotificationPhotoponNavigationViewControllerDidTakeScreenShot;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerShouldChangeViewMode;
extern NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidChangeViewMode;
extern NSString *const PhotoponNotificationDidCropImage;
extern NSString *const PhotoponNotificationDidEditCaption;
extern NSString *const PhotoponNotificationDidReceiveLocalOffers;
extern NSString *const PhotoponAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const PhotoponAppDelegateApplicationDidAttemptLogInNotification;
extern NSString *const PhotoponAppDelegateApplicationDidCompleteLogInNotification;
extern NSString *const PhotoponAppDelegateApplicationDidLogInPhotoponUserNotification;
extern NSString *const PhotoponAppDelegateApplicationDidLogInFacebookUserNotification;
extern NSString *const PhotoponNotificationFacebookLoginFailed;
extern NSString *const PhotoponNotificationFacebookLoginSuccess;
extern NSString *const PhotoponNotificationFacebookLoginProcess;
extern NSString *const PhotoponNotificationFacebookSessionStateChanged;
extern NSString *const PhotoponUtilityUserFollowingChangedNotification;
extern NSString *const PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const PhotoponUtilityUserSnippedUnsnippedPhotoCallbackFinishedNotification;
extern NSString *const PhotoponUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const PhotoponTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const PhotoponTabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const PhotoponPhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const PhotoponPhotoDetailsViewControllerUserSnippedUnsnippedPhotoNotification;
extern NSString *const PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification;

#pragma mark - User Info Keys
extern NSString *const PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey;
extern NSString *const kPhotoponEditPhotoViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kPhotoponInstallationUserKey;


#pragma mark - PhotoponModel Activity Class
// Class key
extern NSString *const kPhotoponActivityClassKey;

// Date
extern NSString *const kPhotoponLastSyncDate;

#pragma mark - Base Entity Attribute Keys

// Base/Standard/Generic keys
extern NSString *const kPhotoponModelIdentifierKey;
extern NSString *const kPhotoponCurrentUserKey;
extern NSString *const kPhotoponEntityIdentifierKey; // created by entity name & model ID: NAME_ID
extern NSString *const kPhotoponEntityNameKey;
extern NSString *const kPhotoponCreatedTimeKey;

#pragma mark - Cached Current User
// Field keys
extern NSString *const kPhotoponCurrentUserAttributesUsernameKey;
extern NSString *const kPhotoponCurrentUserAttributesPasswordKey;
extern NSString *const kPhotoponCurrentUserAttributesPhotoponAppSecretKey;
extern NSString *const kPhotoponCurrentUserAttributesPhotoponAppKeyKey;

#pragma mark - Cached HashTag Attributes
//
extern NSString *const kPhotoponHashTagAttributesContentKey;

#pragma mark - PhotoponUserModel Attributes
// Field keys
extern NSString *const kPhotoponUserAttributesCurrentUserKey;
extern NSString *const kPhotoponUserAttributesIdentifierKey;
extern NSString *const kPhotoponUserAttributesUsernameKey;
extern NSString *const kPhotoponUserAttributesFullNameKey;
extern NSString *const kPhotoponUserAttributesFirstNameKey;
extern NSString *const kPhotoponUserAttributesLastNameKey;
extern NSString *const kPhotoponUserAttributesEmailKey;
extern NSString *const kPhotoponUserAttributesBioKey;
extern NSString *const kPhotoponUserAttributesWebsiteKey;
extern NSString *const kPhotoponUserAttributesProfilePictureUrlKey;
extern NSString *const kPhotoponUserAttributesProfileCoverPictureUrlKey;
extern NSString *const kPhotoponUserAttributesFollowedByCountKey;
extern NSString *const kPhotoponUserAttributesFollowersCountKey;
extern NSString *const kPhotoponUserAttributesRedeemCountKey;
extern NSString *const kPhotoponUserAttributesMediaCountKey;
extern NSString *const kPhotoponUserAttributesScoreKey;
extern NSString *const kPhotoponUserAttributesDidFollowKey;
extern NSString *const kPhotoponUserAttributesMediaCountStringKey;
extern NSString *const kPhotoponUserAttributesFollowersCountStringKey;
extern NSString *const kPhotoponUserAttributesFollowedByCountStringKey;
extern NSString *const kPhotoponUserAttributesRedeemCountStringKey;
extern NSString *const kPhotoponUserAttributesScoreStringKey;
extern NSString *const kPhotoponUserAttributesDidFollowStringKey;
extern NSString *const kPhotoponUserAttributesFacebookFriendsKey;
extern NSString *const kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey;

extern NSString *const kPhotoponUserAttributesFacebookIDKey;
extern NSString *const kPhotoponUserAttributesFacebookAccessTokenKey;
extern NSString *const kPhotoponUserAttributesInstagramIDKey;
extern NSString *const kPhotoponUserAttributesTwitterIDKey;

#pragma mark - Media Class
// Class key
extern NSString *const kPhotoponMediaClassKey;

// Field keys
extern NSString *const kPhotoponMediaPictureKey;
extern NSString *const kPhotoponMediaThumbnailKey;
extern NSString *const kPhotoponMediaUserKey;
extern NSString *const kPhotoponMediaOpenGraphIDKey;

#pragma mark - Cached Media Attributes

/* ************************************************************ */
/* New Photopon Draft keys                                      */
/* ************************************************************ */
/*      NOTE:   Used to interface with NSUserDefaults (in the   //
 *              case of a crash or lost network connection      //
 *              during new Photopon composition                 */
/* ************************************************************ */
extern NSString *const kPhotoponMediaAttributesNewPhotoponLocalImageFileNameKey;
extern NSString *const kPhotoponMediaAttributesNewPhotoponLocalImageFilePathKey;
extern NSString *const kPhotoponMediaAttributesNewPhotoponMediaKey;
extern NSString *const kPhotoponMediaAttributesNewPhotoponCouponKey;
extern NSString *const kPhotoponMediaAttributesNewPhotoponPlaceKey;

// comment attributes keys
extern NSString *const kPhotoponCommentAttributesIdentifierKey;
extern NSString *const kPhotoponCommentAttributesContentKey;
extern NSString *const kPhotoponCommentAttributesActivityIDKey;
extern NSString *const kPhotoponCommentAttributesMediaIDKey;
extern NSString *const kPhotoponCommentAttributesUserKey;
extern NSString *const kPhotoponCommentAttributesLocationIdentifierKey;
extern NSString *const kPhotoponCommentAttributesLocationLatitudeKey;
extern NSString *const kPhotoponCommentAttributesLocationLongitudeKey;
extern NSString *const kPhotoponCommentAttributesCreatedTimeKey;
extern NSString *const kPhotoponCommentAttributesIsEditingKey;

// activity attributes keys
extern NSString *const kPhotoponActivityAttributesIdentifierKey;
extern NSString *const kPhotoponActivityAttributesTypeKey;
extern NSString *const kPhotoponActivityAttributesTitleKey;
extern NSString *const kPhotoponActivityAttributesMediaIdentifierKey;
extern NSString *const kPhotoponActivityAttributesUserIdentifierKey;
extern NSString *const kPhotoponActivityAttributesThumbnailURLKey;

// Activity attributes keys
extern NSString *const kPhotoponActivityAttributesFromUserKey;
extern NSString *const kPhotoponActivityAttributesToUserKey;
extern NSString *const kPhotoponActivityAttributesContentKey;
extern NSString *const kPhotoponActivityAttributesPhotoKey;

// Activity attributes values
extern NSString *const kPhotoponActivityAttributesTypeLike;
extern NSString *const kPhotoponActivityAttributesTypeFollow;
extern NSString *const kPhotoponActivityAttributesTypeComment;
extern NSString *const kPhotoponActivityAttributesTypeJoined;




// media attributes keys
extern NSString *const kPhotoponMediaAttributesIdentifierKey;
extern NSString *const kPhotoponMediaAttributesCoordinateKey;
extern NSString *const kPhotoponMediaAttributesValueTitleKey;
extern NSString *const kPhotoponMediaAttributesCostKey;
extern NSString *const kPhotoponMediaAttributesMonetaryValueKey;
extern NSString *const kPhotoponMediaAttributesSocialValueKey;
extern NSString *const kPhotoponMediaAttributesCaptionKey;
extern NSString *const kPhotoponMediaAttributesLinkURLKey;
extern NSString *const kPhotoponMediaAttributesLikeCountKey;
extern NSString *const kPhotoponMediaAttributesLikersKey;
extern NSString *const kPhotoponMediaAttributesCommentCountKey;
extern NSString *const kPhotoponMediaAttributesCommentersKey;
extern NSString *const kPhotoponMediaAttributesSnipCountKey;
extern NSString *const kPhotoponMediaAttributesSnippersKey;
extern NSString *const kPhotoponMediaAttributesUserKey;
extern NSString *const kPhotoponMediaAttributesCouponKey;
extern NSString *const kPhotoponMediaAttributesThumbURLKey;
extern NSString *const kPhotoponMediaAttributesImageMidURLKey;
extern NSString *const kPhotoponMediaAttributesImageLargeURLKey;
extern NSString *const kPhotoponMediaAttributesLocationIdentifierKey;
extern NSString *const kPhotoponMediaAttributesLocationLatitudeKey;
extern NSString *const kPhotoponMediaAttributesLocationLongitudeKey;
extern NSString *const kPhotoponMediaAttributesCreatedTimeKey;
extern NSString *const kPhotoponMediaAttributesUsersKey;
extern NSString *const kPhotoponMediaAttributesTagsKey;
extern NSString *const kPhotoponMediaAttributesDidLikeKey;
extern NSString *const kPhotoponMediaAttributesDidSnipKey;
extern NSString *const kPhotoponMediaAttributesDidLikeBoolKey;
extern NSString *const kPhotoponMediaAttributesDidSnipBoolKey;

#pragma mark - Cached Coupon Attributes
// keys
extern NSString *const kPhotoponCouponAttributesIdentifierKey;
extern NSString *const kPhotoponCouponAttributesDetailsKey;
extern NSString *const kPhotoponCouponAttributesTermsKey;
extern NSString *const kPhotoponCouponAttributesInstructionsKey;
extern NSString *const kPhotoponCouponAttributesStartKey;
extern NSString *const kPhotoponCouponAttributesStartStringKey;
extern NSString *const kPhotoponCouponAttributesExpirationKey;
extern NSString *const kPhotoponCouponAttributesExpirationStringKey;
extern NSString *const kPhotoponCouponAttributesExpirationTextStringKey;
extern NSString *const kPhotoponCouponAttributesPlaceKey;
extern NSString *const kPhotoponCouponAttributesCouponTypeKey;
extern NSString *const kPhotoponCouponAttributesCouponURLKey;
extern NSString *const kPhotoponCouponAttributesValueKey;

#pragma mark - Cached Place Attributes

// meta keys
extern NSString *const kPhotoponPlaceAttributesMetaOfferSourceURLKey;
extern NSString *const kPhotoponPlaceAttributesMetaOfferSourceImageURLKey;
extern NSString *const kPhotoponPlaceAttributesMetaOfferSourceNameKey;
// keys
extern NSString *const kPhotoponPlaceAttributesIdentifierKey;
extern NSString *const kPhotoponPlaceAttributesPublicIDKey;
extern NSString *const kPhotoponPlaceAttributesNameKey;
extern NSString *const kPhotoponPlaceAttributesAddressFullKey;
extern NSString *const kPhotoponPlaceAttributesStreetKey;
extern NSString *const kPhotoponPlaceAttributesCityKey;
extern NSString *const kPhotoponPlaceAttributesStateKey;
extern NSString *const kPhotoponPlaceAttributesZipKey;
extern NSString *const kPhotoponPlaceAttributesPhoneKey;
extern NSString *const kPhotoponPlaceAttributesCategoryKey;
extern NSString *const kPhotoponPlaceAttributesImageURLKey;
extern NSString *const kPhotoponPlaceAttributesBioKey;
extern NSString *const kPhotoponPlaceAttributesLocationIdentifierKey;
extern NSString *const kPhotoponPlaceAttributesLocationLatitudeKey;
extern NSString *const kPhotoponPlaceAttributesLocationLongitudeKey;
extern NSString *const kPhotoponPlaceAttributesRatingKey;
extern NSString *const kPhotoponPlaceAttributesURLKey;

#pragma mark - Cached Tag Attributes
// keys
extern NSString *const kPhotoponTagAttributesIdentifierKey;
extern NSString *const kPhotoponTagAttributesTaggedObjectTitleKey;
extern NSString *const kPhotoponTagAttributesTaggedObjectIdentifierKey;
extern NSString *const kPhotoponTagAttributesTaggedObjectClassNameKey;
extern NSString *const kPhotoponTagAttributesAddedTimeKey;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kPhotoponUserAttributesPhotoCountKey;
extern NSString *const kPhotoponUserAttributesIsFollowedByCurrentUserKey;

extern NSString *const kPhotoponHasBeenFetchedKey;

#pragma mark - PhotoponPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kPhotoponPushPayloadPayloadTypeKey;
extern NSString *const kPhotoponPushPayloadPayloadTypeActivityKey;

extern NSString *const kPhotoponPushPayloadActivityTypeKey;
extern NSString *const kPhotoponPushPayloadActivityLikeKey;
extern NSString *const kPhotoponPushPayloadActivityCommentKey;
extern NSString *const kPhotoponPushPayloadActivityFollowKey;

extern NSString *const kPhotoponPushPayloadFromUserObjectIdKey;
extern NSString *const kPhotoponPushPayloadToUserObjectIdKey;
extern NSString *const kPhotoponPushPayloadPhotoObjectIdKey;

// Blog archive file name
#define BLOG_ARCHIVE_NAME       Photopon_Posts

// control dimensions
#define kStdButtonWidth         106.0
#define kStdButtonHeight        40.0

#define kTextFieldHeight        20.0
#define kTextFieldFontSize      18.0

// DEVICE FILE NAMES
#define kPhotoponDeviceSuffixIPad           @"-iPad"
#define kPhotoponDeviceSuffixIPadMini       @"-iPadMini"
#define kPhotoponDeviceSuffixIPhoneTall     @"-tall"

// FONTS
#define kPhotoponFontFamilyBrand            @"Comfortaa"
#define kPhotoponFontRegularBrand           @"Comfortaa"
#define kPhotoponFontLightBrand             @"Comfortaa Light"
#define kPhotoponFontBoldBrand              @"Comfortaa Bold"


#define kPhotoponFontFamilyOffer            @"Josefin Sans"
#define kPhotoponFontRegularOffer           @"Josefin Sans"
#define kPhotoponFontLightOffer             @"Josefin Sans Light"
#define kPhotoponFontBoldOffer              @"Josefin Sans Bold"
#define kPhotoponFontThinOffer              @"Josefin Sans Thin"

#define kPhotoponFontFamilyOfferCaption     @"Lemon"
#define kPhotoponFontRegularOfferCaption    @"Lemon Regular"

#define kTextFieldFont                  @"Arial"
#define kTextViewPlaceholder            @"Tap here to begin writing."
#define kAppStoreID                     545200032
#define kAppStoreURL                    @"http://itunes.apple.com/us/app/photopon/id545200032?mt=8"
#define kAppShareURL                    @"http://photopon.com/"
#define kAppShareMessage                @"Amazing new app Photopon! Get it from %@"
#define kAppReviewMessage               @"Would you mind taking a moment to review us? PLEASE :) \n\n It won't take more than a minute. Just click \"Rate Us\" below and Please Review Photopon."


// photopon placeholders
#define kPhotoponPlaceholderSearchField             @"Search members or hashtags"
#define kPhotoponPlaceholderSearchScopeField        @"Search for a %@"
#define kPhotoponPlaceholderCommentField            @"Add a comment..."

// guest username
#define kPhotoponGuestUsername  @"PhotoponGuestUsername"

// base paths
#define kPhotoponURLBase        @"http://photopon.com/core"
#define kPhotoponContentBase    @"http://photopon.com/core/wp-content"

// legal paths
#define kPhotoponLegalURLTerms      @"http://photopon.com/tos.html"
#define kPhotoponLegalURLPrivacy    @"http://photopon.com/privacy.html"

// https
#define kNotificationAuthURL	@"http://photopon.com/core/wp-content/plugins/buddypress-xmlrpc-receiver/bp-xmlrpc.php"

// https
#define kMobileReaderFakeLoaderURL		@"http://en.photopon.com/reader/mobile/v2/loader"
// https
#define kMobileReaderURL		@"http://en.photopon.com/reader/mobile/v2/?chrome=no"
// https
#define kMobileReaderFPURL		@"http://en.photopon.com/reader/mobile/v2/freshly-pressed"
// https
#define kMobileReaderDetailURL  @"http://en.photopon.com/core/wp-admin/admin-ajax.php?action=pcom_load_mobile&template=details&v=2"
// https
#define kMobileReaderTopicsURL  @"http://en.photopon.com/reader/mobile/v2/?template=topics"
#define kHybridTokenSetting     @"PhotoponWebAppHybridAuthToken"
#define kAuthorizedHybridHost   @"http://photopon.com/core"

// https
#define kStatsEndpointURL		@"http://stats.photopon.com/api/1.0/"
#define kWPcomXMLRPCUrl         @"http://photopon.com/core/wp-content/plugins/buddypress-xmlrpc-receiver/bp-xmlrpc.php"

#define kDisabledTextColor      [UIColor grayColor]

#define kLabelHeight            20.0
#define kLabelWidth             90.0
#define kLabelFont              @"Arial"

#define kProgressIndicatorSize  40.0
#define kToolbarHeight          40.0
#define kSegmentedControlHeight 40.0

// table view cell
#define kCellLeftOffset         4.0
#define kCellTopOffset          12.0
#define kCellRightOffset        32.0
#define kCellFieldSpacer        14.0
#define kCellWidth              300.0
#define kCellHeight             44.0
#define kSectionHeaderHight     25.0

#define REFRESH_BUTTON_HEIGHT   50

#define PICKER_VIEW_BACKGROUND_COLOR        [UIColor colorWithRed:43.0 / 255.0 green:47.0 / 255.0 blue:51.0 / 145.0 alpha:1.0]

#define PHOTOPON_BLUE_COLOR                 [UIColor colorWithRed:13.0 / 255.0 green:74.0 / 255.0 blue:162.0 / 255.0 alpha:1.0]

#define TEXT_FIELD_PLACEHOLDER_TEXT_COLOR           [UIColor colorWithRed:179.0 / 255.0 green:179.0 / 255.0 blue:179.0 / 255.0 alpha:1.0]
#define TEXT_FIELD_TEXT_COLOR                       [UIColor blackColor]

#define TABLE_VIEW_BACKGROUND_COLOR         [UIColor colorWithRed:237.0 / 255.0 green:243.0 / 255.0 blue:247.0 / 255.0 alpha:1.0]
#define TABLE_VIEW_CELL_OFF_BACKGROUND_COLOR    [UIColor colorWithRed:237.0 / 255.0 green:243.0 / 255.0 blue:247.0 / 255.0 alpha:1.0]
#define TABLE_VIEW_CELL_ON_BACKGROUND_COLOR    [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]
#define TABLE_VIEW_CELL_OFF_TEXT_COLOR      [UIColor colorWithRed:59.0 / 255.0 green:64.0 / 255.0 blue:69.0 / 255.0 alpha:1.0]
#define TABLE_VIEW_CELL_ON_TEXT_COLOR      [UIColor colorWithRed:128.0 / 255.0 green:137.0 / 255.0 blue:69.0 / 145.0 alpha:1.0]

#define BAR_BUTTON_ITEM_OFF_TEXT_COLOR      [UIColor colorWithRed:159.0 / 255.0 green:169.0 / 255.0 blue:178.0 / 255.0 alpha:1.0]
#define BAR_BUTTON_ITEM_ON_TEXT_COLOR      [UIColor colorWithRed:59.0 / 255.0 green:64.0 / 255.0 blue:69.0 / 255.0 alpha:1.0]

#define SEGMENTED_CONTROL_OFF_TEXT_COLOR    [UIColor colorWithRed:159.0 / 255.0 green:169.0 / 255.0 blue:178.0 / 255.0 alpha:1.0]
#define SEGMENTED_CONTROL_ON_TEXT_COLOR    [UIColor colorWithRed:0.0 / 255.0 green:49.0 / 255.0 blue:92.0 / 255.0 alpha:1.0]
#define PENDING_COMMENT_TABLE_VIEW_CELL_BACKGROUND_COLOR     [UIColor colorWithRed:1.0 green:1.0 blue:215.0 / 255.0 alpha:1.0]
#define PENDING_COMMENT_TABLE_VIEW_CELL_BORDER_COLOR     [UIColor colorWithRed:226.0 / 255.0 green:215.0 / 255.0 blue:58.0 / 255.0 alpha:1.0]
#define LOAD_MORE_DATA_TEXT_COLOR [UIColor colorWithRed:35.0 / 255.0 green:112.0 / 255.0 blue:216.0 / 255.0 alpha:1.0]
#define WRONG_FIELD_COLOR [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]
#define GOOD_FIELD_COLOR [UIColor blackColor]

//R: 35, G: 112, B: 216 | #2370D8 | ΔX: 1378, ΔY: 29 | img

#ifdef DEBUGMODE
#define WPLog(...) NSLog(__VA_ARGS__)
#else
#define WPLog(__unused ...) //NSLog
#endif
#define CGRectToString(rect) [NSString stringWithFormat:@"%f,%f:%fx%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]
#define CGPointToString(point) [NSString stringWithFormat:@"%f,%f", point.x, point.y]

// Instagram stuff
#define kInstagramAppID                   @"80d6a189f8d04baf95cc83792f0a70dd"
#define kInstagramAppSecret               @"ca8614aee3624d08ba06da2c3266a68d"
#define kInstagramAppRedirectURI          @"ig80d6a189f8d04baf95cc83792f0a70dd://authorize"

// facebook stuff
#define kFacebookAppID                      @"315234305202948"
#define kFacebookLoginNotificationName      @"FacebookLogin"
#define kFacebookNoLoginNotificationName    @"FacebookNoLogin"
#define kFacebookAccessTokenKey             @"FBAccessTokenKey"
#define kFacebookExpirationDateKey          @"FBExpirationDateKey"
#define kFacebookProfileImageName           @"FacebookProfilePicture.jpg"

// fb graph
#define kFacebookGraphBasePath          @"https://graph.facebook.com/%@/"

// end fb stuff

#define kAccessedAddressBookPreference   @"AddressBookAccessGranted"


// https
#define kPhotoponComXMLRPCUrl               @"http://photopon.com/core/wp-content/plugins/buddypress-xmlrpc-receiver/bp-xmlrpc.php"

/* Photopon Merchants API                             method, key, lat, lon, radius, limit
#define kPhotoponMerchantsAPIBaseUrl                 @"http://api.8coupons.com/"
#define kPhotoponMerchantsAPIEndpointUrl             @"http://api.8coupons.com/v1/"
#define kPhotoponMerchantsAPIFullUrl                 @"http://api.8coupons.com/v1/%@?key=%@&lat=%@&lon=%@&mileradius=%@&limit=%@"
//
#define k8CouponsAPIParamsAPIKey            @"02fbfdcae460b422ba93ca0de753e2ac566a290f92e6a03bd8eb3b5c5beb6fbcec933468b156b3b6050939c1cb7ea653"
#define k8CouponsAPIMethodName              @"getdeals"
#define k8CouponsAPIParamsMileRadius        4
#define k8CouponsAPIParamsLimit             40
*/

// 8Coupons API                             method, key, lat, lon, radius, limit
#define k8CouponsAPIBaseUrl                 @"http://api.8coupons.com/"
#define k8CouponsAPIEndpointUrl             @"http://api.8coupons.com/v1/"
#define k8CouponsAPIFullUrl                 @"http://api.8coupons.com/v1/%@?key=%@&lat=%@&lon=%@&mileradius=%@&limit=%@"
//
#define k8CouponsAPIParamsAPIKey            @"02fbfdcae460b422ba93ca0de753e2ac566a290f92e6a03bd8eb3b5c5beb6fbcec933468b156b3b6050939c1cb7ea653"
#define k8CouponsAPIMethodName              @"getdeals"
#define k8CouponsAPIParamsMileRadius        4
#define k8CouponsAPIParamsLimit             40

//#define k8CouponsAPIReturn             @"yyyy-MM-dd'T'HH:mm:ss'Z'";

//#define k8CouponsBaseUrl                @"http://api.8coupons.com/v1/getdeals?key=02fbfdcae460b422ba93ca0de753e2ac566a290f92e6a03bd8eb3b5c5beb6fbcec933468b156b3b6050939c1cb7ea653&lat=%@&lon=%@&mileradius=4&limit=40"


//
#define kBlogId                                 @"blogid"
#define kBlogHostName                           @"blog_host_name"
#define kCurrentBlogIndex                       @"CurrentBlogIndex"
#define kResizePhotoSetting                     @"ResizePhotoSetting"
#define kGeolocationSetting						@"GeolocationSetting"
#define kLocationSetting						@"LocationSetting"
#define kSupportsVideoPress						@"SupportsVideoPress"
#define kAsyncPostFlag                          @"async_post"
#define kVersionAlertShown                      @"VersionAlertShown"
#define kResizePhotoSettingHintLabel            @"Resizing will result in faster publishing \n but smaller photos. Resized photos \n will be no larger than 720 x 480."
#define kPasswordHintLabel                      @"Setting a password will require visitors to \n enter the above password to view this \n post and its comments."
#define kLocationOnSetting						@"LocationOnSetting"

#pragma mark Error Messages

#define kNoInternetErrorMessage                 @"No internet connection."
#define kBlogExistsErrorMessage                 @"Blog '%@' already configured on this iPhone."

#define kNewPhotoponDraftCancelMessage          @"Are you sure to cancel publishing (Your photo is still saved in Gallery)?"
#define kNewPhotoponDraftShareSMSTextMessage    @"Your photopon has been copied to the clipboard. you can paste it in Messages.app. Do you want to open iMessage now?"

#define GetUsersSuccessful @"GetUsersSuccessful"
#define GetUsersFailed @"GetUsersFailed"
#define GetMyPhotoponsSuccessful @"GetMyPhotoponsSuccessful"
#define GetMyPhotoponsFailed @"GetMyPhotoponsFailed"
#define PictureObjectUploadedNotificationName @"PictureObjectUploadedNotificationName"
#define VideoSaved @"VideoSavedNotification"
#define VideoUploadChunk @"VideoUploadChunk"
#define DidTapBehindModalView @"DidTapBehindModalView"
#define DidScrollForSnipsActivityTable @"DidScrollForSnipsActivityTable"
#define DidScrollForLikesActivityTable @"DidScrollForLikesActivityTable"
#define ImageUploadSuccessful @"ImageUploadSuccessful"
#define SimulateCameraAction @"SimulateCameraAction"
#define ImageUploadFailed @"ImageUploadFailed"
#define VideoUploadSuccessful @"VideoUploadSuccessful"
#define VideoUploadFailed @"VideoUploadFailed"
#define WPNewCategoryCreatedAndUpdatedInBlogNotificationName @"WPNewCategoryCreatedAndUpdatedInBlog"
#define kXML_RPC_ERROR_OCCURS @"kXML_RPC_ERROR_OCCURS"
#define kURL @"URL"
#define kMETHOD @"METHOD"
#define kMETHODARGS @"METHODARGS"
#define BlavatarLoaded @"BlavatarLoaded"
#define DidChangeStatusBarFrame @"DidChangeStatusBarFrame"
#define ProgressBarRefreshNotification @"ProgressBarRefreshNotification"

#define kPostsDownloadCount @"postsDownloadCount"
//#define kPagesDownloadCount @"pagesDownloadCount"
#define kDraftsBlogIdStr @"localDrafts"
#define kDraftsHostName @"iPhone"

#define kUnsupportedWordpressVersionTag 900
#define kRSDErrorTag 901
#define kCrashAlertTag 902
#define kNoXMLPrefix 903
#define kNotificationNewComment 1001

#define RESOURCE_TYPE_MAIN 0
#define RESOURCE_TYPE_NEARBY 1
#define RESOURCE_TYPE_PROFILE_PHOTOPONS 2
#define RESOURCE_TYPE_PROFILE_REDEEMED 3

#define RESOURCE_TYPE_USER_FOLLOWERS 0
#define RESOURCE_TYPE_USER_FOLLOWING 1
#define RESOURCE_TYPE_PHOTOPON_MEDIA_VIEWS 2
#define RESOURCE_TYPE_PHOTOPON_MEDIA_LIKES 3
#define RESOURCE_TYPE_PHOTOPON_MEDIA_REDEEMS 4
#define RESOURCE_TYPE_PHOTOPON_MEDIA_COMMENTS 5

typedef enum {
	kImage,
	kVideo
} MediaType;

typedef enum {
	kResizeSmall,
	kResizeMedium,
	kResizeLarge,
	kResizeOriginal
} MediaResize;

typedef enum {
	kPortrait,
	kLandscape
} MediaOrientation;

typedef enum {
	kNewPost,
	kEditPost,
	kAutorecoverPost,
	kRefreshPost
} EditPostMode;

typedef enum {
	kNewPage,
	kEditPage,
	kAutorecoverPage,
	kRefreshPage
} EditPageMode;


//Blog Predefined Options
#define image_small_size_w 290
#define image_small_size_h 194
#define image_medium_size_w 300
#define image_medium_size_h 200
#define image_large_size_w 960
#define image_large_size_h 640


#define kSettingsMuteSoundsKey @"settings_mute_sounds"
#define kApnsDeviceTokenPrefKey  @"apnsDeviceToken"


