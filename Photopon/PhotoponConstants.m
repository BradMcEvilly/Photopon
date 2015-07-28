//
//  PhotoponConstants.m
//  Anypic
//
//  Created by Brad McEvilly on 5/25/12.
//

#import "PhotoponConstants.h"

NSInteger const kPhotoponErrorObjectNotFound = 101;
NSInteger const kPhotoponErrorCacheMiss = 120;

//Search scope keys
NSString *const kPhotoponSearchScopePeople           = @"People";
NSString *const kPhotoponSearchScopePlaces           = @"Places";
NSString *const kPhotoponSearchScopeCoupons          = @"Coupons";
NSString *const kPhotoponSearchScopeHashtags         = @"Hashtags";

//Search result keys
NSString *const kPhotoponSearchResultItemTitleKey            = @"title";
NSString *const kPhotoponSearchResultItemIdentifier          = @"identifier";
NSString *const kPhotoponSearchResultItemImageUrlStringKey   = @"url";

NSString *const kPhotoponNullDBDateFieldString              = @"1970-01-01 00:00:00";
NSString *const kPhotoponNullFieldString                    = @"<null>";

NSString *const kPhotoponDateTextFormat                         = @"MM/dd/yyyy";
NSString *const kPhotoponDateFormat                         = @"Y-m-d H:i:s HH:mm:ss Z";

NSString *const kPhotoponHasBeenFetchedKey          = @"hasBeenFetched";
NSString *const kPhotoponClassName                  = @"PhotoponModel";
NSString *const kPhotoponUserClassName              = @"PhotoponUserModel";
NSString *const kPhotoponMediaClassName             = @"PhotoponMediaModel";
NSString *const kPhotoponCommentClassName           = @"PhotoponCommentModel";
NSString *const kPhotoponCouponClassName            = @"PhotoponCouponModel";
NSString *const kPhotopon8CouponsClassName          = @"Photopon8CouponsModel";
NSString *const kPhotoponMerchantsClassName         = @"PhotoponMerchantsModel";
NSString *const kPhotoponPlaceClassName             = @"PhotoponPlaceModel";
NSString *const kPhotoponActivityClassName          = @"PhotoponActivityModel";
NSString *const kPhotoponTagClassName               = @"PhotoponTagModel";
NSString *const kPhotoponHashtagClassName           = @"PhotoponHashtagModel";
NSString *const kPhotoponMentionClassName           = @"PhotoponMentionModel";

//  Photopon Merchants API Method Names
NSString *const kPhotoponMerchantsAPIMethodGetCoupons                       = @"pm.getCoupons";
NSString *const kPhotoponMerchantsAPIMethodGetGifts                         = @"pm.getGifts";
// For Photopon 3.0
NSString *const kPhotoponMerchantsAPIMethodGetBrands                        = @"pm.getBrands";
NSString *const kPhotoponMerchantsAPIMethodSendCoupon                       = @"pm.sendCoupon";
NSString *const kPhotoponMerchantsAPIMethodSendGift                         = @"pm.sendGift";

//  Photopon API Method Names
NSString *const kPhotoponAPIMethodVerifyConnection                          = @"bp.verifyConnection";
NSString *const kPhotoponAPIMethodPostFeedback                              = @"bp.postFeedback";
NSString *const kPhotoponAPIMethodCheckEmailExists                          = @"bp.checkEmailExists";
NSString *const kPhotoponAPIMethodGetProfileInfo                            = @"bp.getProfileInfo";
NSString *const kPhotoponAPIMethodUploadProfilePhoto                        = @"bp.uploadProfilePhoto";
NSString *const kPhotoponAPIMethodSearchPeople                              = @"bp.searchPeople";
NSString *const kPhotoponAPIMethodSearchPlaces                              = @"bp.searchPlaces";
NSString *const kPhotoponAPIMethodSearchCoupons                             = @"bp.searchCoupons";
NSString *const kPhotoponAPIMethodSearchHashtags                            = @"bp.searchHashtags";
NSString *const kPhotoponAPIMethodSyncFBUser                                = @"bp.syncFBUser";
NSString *const kPhotoponAPIMethodSyncIGUser                                = @"bp.syncIGUser";
NSString *const kPhotoponAPIMethodSyncTUser                                 = @"bp.syncTUser";
NSString *const kPhotoponAPIMethodRegisterNewUser                           = @"bp.registerNewUser";
NSString *const kPhotoponAPIMethodGetNotifications                          = @"bp.getNotifications";
NSString *const kPhotoponAPIMethodFacebookLogin                             = @"bp.facebookLogin";
NSString *const kPhotoponAPIMethodUploadPhotoponMediaFile                   = @"bp.uploadPhotoponMediaFile";
NSString *const kPhotoponAPIMethodUploadPhotoponMediaMeta                   = @"bp.uploadPhotoponMediaMeta";
NSString *const kPhotoponAPIMethodUploadPhotopon                            = @"bp.uploadPhotopon";
NSString *const kPhotoponAPIMethodGetMyGallery                              = @"bp.getMyGallery";
NSString *const kPhotoponAPIMethodGetMyRedeemedGallery                      = @"bp.getMyRedeemedGallery";
NSString *const kPhotoponAPIMethodGetOptions                                = @"bp.getOptions";
NSString *const kPhotoponAPIMethodUpdateExternalBlogPostStatus              = @"bp.updateExternalBlogPostStatus";
NSString *const kPhotoponAPIMethodDeleteExternalBlogPostStatus              = @"bp.deleteExternalBlogPostStatus";
NSString *const kPhotoponAPIMethodUpdateProfileStatus                       = @"bp.updateProfileStatus";
NSString *const kPhotoponAPIMethodUpdateProfileInfo                         = @"bp.updateProfileInfo";
NSString *const kPhotoponAPIMethodGetTrendingHashTags                       = @"bp.getTrendingHashTags";
NSString *const kPhotoponAPIMethodGetMyFeed                                 = @"bp.getMyFeed";
NSString *const kPhotoponAPIMethodGetNearbyPhotopons                        = @"bp.getNearbyPhotopons";
NSString *const kPhotoponAPIMethodGetGlobalPopularPhotopons                 = @"bp.getGlobalPopularPhotopons";
NSString *const kPhotoponAPIMethodGetGlobalRecentPhotopons                  = @"bp.getGlobalRecentPhotopons";
NSString *const kPhotoponAPIMethodNewPostActivity                           = @"bp.newPostActivity";
NSString *const kPhotoponAPIMethodPostLike                                  = @"bp.postLike";
NSString *const kPhotoponAPIMethodPostUnlike                                = @"bp.postUnlike";
NSString *const kPhotoponAPIMethodPostSnip                                  = @"bp.postSnip";
NSString *const kPhotoponAPIMethodPostUnsnip                                = @"bp.postUnsnip";
NSString *const kPhotoponAPIMethodPostComment                               = @"bp.postComment";
NSString *const kPhotoponAPIMethodPostFollow                                = @"bp.postFollow";
NSString *const kPhotoponAPIMethodPostUnfollow                              = @"bp.postUnfollow";
NSString *const kPhotoponAPIMethodGetComments                               = @"bp.getComments";
NSString *const kPhotoponAPIMethodGetSnips                                  = @"bp.getRedeems";
NSString *const kPhotoponAPIMethodGetLikes                                  = @"bp.getLikes";
NSString *const kPhotoponAPIMethodGetViews                                  = @"bp.getViews";
NSString *const kPhotoponAPIMethodGetFollowers                              = @"bp.getFollowers";
NSString *const kPhotoponAPIMethodGetFollowing                              = @"bp.getFollowing";
NSString *const kPhotoponAPIMethodGetActivity                               = @"bp.getActivity";
NSString *const kPhotoponAPIMethodGetPhotopons                              = @"bp.getPhotopons";
NSString *const kPhotoponAPIMethodGetMyFollowers                            = @"bp.getMyFollowers";
NSString *const kPhotoponAPIMethodGetMyFollowing                            = @"bp.getMyFollowing";
NSString *const kPhotoponAPIMethodWPUploadFile                              = @"wp.uploadFile";
NSString *const kPhotoponAPIMethodWPNewPost                                 = @"wp.newPost";

//  Photopon API Method Names


//  8Coupons API Method Param Name keys
NSString *const k8CouponsAPIParamsKeyNameKey             = @"key";
NSString *const k8CouponsAPIParamsLatitudeNameKey        = @"lat";
NSString *const k8CouponsAPIParamsLongitudeNameKey       = @"lon";
NSString *const k8CouponsAPIParamsRadiusNameKey          = @"mileradius";
NSString *const k8CouponsAPIParamsLimitNameKey           = @"limit";

//  8Coupons API Response Info - General
//NSString *const kPhotoponDateFormat                                 = @"Y-m-d H:i:s HH:mm:ss Z";
NSString *const k8CouponsAPIReturnDataDateFormat                    = @"yyyy-MM-dd HH:mm:ss"; //@"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString *const k8CouponsAPIReturnDataExpirationDateFormat          = @"yyyy-MM-dd";

//  8Coupons API Response Data Keys
NSString *const k8CouponsAPIReturnDataAffiliateKey                  = @"affiliate";
NSString *const k8CouponsAPIReturnDataNameKey                       = @"name";
NSString *const k8CouponsAPIReturnDataAddressKey                    = @"address";
NSString *const k8CouponsAPIReturnDataAddress2Key                   = @"address2";
NSString *const k8CouponsAPIReturnDataStoreIDKey                    = @"storeID";
NSString *const k8CouponsAPIReturnDataChainIDKey                    = @"chainID";
NSString *const k8CouponsAPIReturnDataTotalDealsInThisStoreKey      = @"totalDealsInThisStore";
NSString *const k8CouponsAPIReturnDataHomepageKey                   = @"homepage";
NSString *const k8CouponsAPIReturnDataPhoneKey                      = @"phone";
NSString *const k8CouponsAPIReturnDataStateKey                      = @"state";
NSString *const k8CouponsAPIReturnDataCityKey                       = @"city";
NSString *const k8CouponsAPIReturnDataZIPKey                        = @"ZIP";
NSString *const k8CouponsAPIReturnDataURLKey                        = @"URL";
NSString *const k8CouponsAPIReturnDataStoreURLKey                   = @"storeURL";
NSString *const k8CouponsAPIReturnDataDealSourceKey                 = @"dealSource";
NSString *const k8CouponsAPIReturnDataUserKey                       = @"user";
NSString *const k8CouponsAPIReturnDataUserIDKey                     = @"userID";
NSString *const k8CouponsAPIReturnDataIDKey                         = @"ID";
NSString *const k8CouponsAPIReturnDataDealTitleKey                  = @"dealTitle";
NSString *const k8CouponsAPIReturnDataDisclaimerKey                 = @"disclaimer";
NSString *const k8CouponsAPIReturnDataDealInfoKey                   = @"dealinfo";
NSString *const k8CouponsAPIReturnDataExpirationDateKey             = @"expirationDate";
NSString *const k8CouponsAPIReturnDataPostDateKey                   = @"postDate";
NSString *const k8CouponsAPIReturnDataShowImageKey                  = @"showImage";
NSString *const k8CouponsAPIReturnDataShowImageStandardBigKey       = @"showImageStandardBig";
NSString *const k8CouponsAPIReturnDataShowImageStandardSmallKey     = @"showImageStandardSmall";
NSString *const k8CouponsAPIReturnDataShowLogoKey                   = @"showLogo";
NSString *const k8CouponsAPIReturnDataUpKey                         = @"up";
NSString *const k8CouponsAPIReturnDataDownKey                       = @"down";
NSString *const k8CouponsAPIReturnDataDealTypeIDKey                 = @"DealTypeID";
NSString *const k8CouponsAPIReturnDataCategoryIDKey                 = @"categoryID";
NSString *const k8CouponsAPIReturnDataSubCategoryIDKey              = @"subcategoryID";
NSString *const k8CouponsAPIReturnDataLatitudeKey                   = @"lat";
NSString *const k8CouponsAPIReturnDataLongitudeKey                  = @"lon";
NSString *const k8CouponsAPIReturnDataDistanceKey                   = @"distance";
NSString *const k8CouponsAPIReturnDataDealOriginalPriceKey          = @"dealOriginalPrice";
NSString *const k8CouponsAPIReturnDataDealPriceKey                  = @"dealPrice";
NSString *const k8CouponsAPIReturnDataDealSavingsKey                = @"dealSavings";
NSString *const k8CouponsAPIReturnDataDealDiscountPercentKey        = @"dealDiscountPercent";

//API Method Param keys
NSString *const kPhotoponCurrentOffsetKey               = @"CurrentOffset";
NSString *const kPhotoponObjectsPerPageKey              = @"ObjectsPerPage";
NSString *const kPhotoponMethodNameKey                  = @"MethodName";
NSString *const kPhotoponMethodFilterKey                = @"MethodFilter";
NSString *const kPhotoponMethodNameSearchKey            = @"MethodNameSearch";
NSString *const kPhotoponMethodSearchTextKey            = @"MethodNameSearchText";
NSString *const kPhotoponMethodSearchScopeKey           = @"MethodNameSearchScope";
NSString *const kPhotoponMethodParamsKey                = @"MethodParams";
NSString *const kPhotoponMethodReturnedModelsKey        = @"MethodReturnedModels";


NSString *const kPhotoponAPIReturnedCommentModelsKey        = @"comment_models";
NSString *const kPhotoponAPIReturnedMediaModelsKey          = @"media_models";
NSString *const kPhotoponAPIReturnedCouponModelsKey         = @"coupon_models";
NSString *const kPhotoponAPIReturnedHashTagModelsKey        = @"hashtag_models";
NSString *const kPhotoponAPIReturnedActivityModelsKey       = @"activity_models";
NSString *const kPhotoponAPIReturnedUserModelsKey           = @"user_models";
NSString *const kPhotoponAPIReturnedModelsKey               = @"models";


NSString *const kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.Photopon.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kPhotoponUserDefaultsCacheFacebookFriendsKey                     = @"com.Photopon.userDefaults.cache.facebookFriends";

#pragma mark - Launch URLs

NSString *const kPhotoponLaunchURLHostTakePicture = @"camera";

#pragma mark - NSNotification

NSString *const PhotoponNotificationPhotoponNewPhotoponOffersViewControllerDidFindNoCoupons = @"com.Photopon.photoponNewPhotoponOffersViewController.didFindNoCoupons";
NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidShowShareApp = @"com.Photopon.photoponNewPhotoponOverlayViewController.didShowShareApp";
NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidHideShareApp = @"com.Photopon.photoponNewPhotoponOverlayViewController.didHideShareApp";
NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition = @"com.Photopon.photoponNewPhotoponOverlayViewController.didCancelNewPhotoponComposition";
NSString *const PhotoponNotificationPhotoponNewPhotoponPickerControllerDidChangeSourceType      = @"com.Photopon.photoponNewPhotoponPickerController.didChangeSourceType";
NSString *const PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidOpenShutter      = @"com.Photopon.photoponNewPhotoponShutterViewController.didOpenShutter";
NSString *const PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidCloseShutter     = @"com.Photopon.photoponNewPhotoponShutterViewController.didCloseShutter";

NSString *const PhotoponNotificationPhotoponNavigationViewControllerDidTakeScreenShot           = @"com.Photopon.photoponNavigationViewController.didTakeScreenShot";
NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerShouldChangeViewMode    = @"com.Photopon.photoponNewPhotoponOverlayViewController.shouldChangeViewMode";
NSString *const PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidChangeViewMode                         = @"com.Photopon.photoponNewPhotoponOverlayViewController.didChangeViewMode";
NSString *const PhotoponAppDelegateApplicationDidReceiveRemoteNotification           = @"com.Photopon.appDelegate.applicationDidReceiveRemoteNotification";

NSString *const PhotoponNotificationDidEditCaption                                  = @"com.Photopon.photoponNewPhotoponOverlayViewController.didEditCaption";
NSString *const PhotoponNotificationDidCropImage                                    = @"com.Photopon.photoponNewPhotoponOverlayViewController.didCropImage";
NSString *const PhotoponNotificationDidReceiveLocalOffers                    = @"com.Photopon.photoponNewCompositionViewController.didReceiveLocalOffers";
NSString *const PhotoponAppDelegateApplicationDidCompleteLogInNotification            = @"com.Photopon.appDelegate.applicationDidCompleteLogInNotification";
NSString *const PhotoponAppDelegateApplicationDidAttemptLogInNotification            = @"com.Photopon.appDelegate.applicationDidAttemptLogInNotification";
NSString *const PhotoponAppDelegateApplicationDidLogInPhotoponUserNotification       = @"com.Photopon.appDelegate.applicationDidLogInPhotoponUserNotification";
NSString *const PhotoponAppDelegateApplicationDidLogInFacebookUserNotification       = @"com.Photopon.appDelegate.applicationDidLogInFacebookUserNotification";
NSString *const PhotoponNotificationFacebookLoginFailed                              = @"com.Photopon.appDelegate.applicationNotificationFacebookLoginFailed";
NSString *const PhotoponNotificationFacebookLoginSuccess                             = @"com.Photopon.appDelegate.applicationNotificationFacebookLoginSuccess";
NSString *const PhotoponNotificationFacebookLoginProcess                             = @"com.Photopon.appDelegate.applicationNotificationFacebookLoginProcess";
NSString *const PhotoponNotificationFacebookSessionStateChanged              = @"com.Photopon.appDelegate.applicationNotificationFacebookSessionStateChanged";
NSString *const PhotoponUtilityUserFollowingChangedNotification                      = @"com.Photopon.utility.userFollowingChanged";
NSString *const PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.Photopon.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const PhotoponUtilityUserSnippedUnsnippedPhotoCallbackFinishedNotification = @"com.Photopon.utility.userSnippedUnsnippedPhotoCallbackFinished";
NSString *const PhotoponUtilityDidFinishProcessingProfilePictureNotification         = @"com.Photopon.utility.didFinishProcessingProfilePictureNotification";
NSString *const PhotoponTabBarControllerDidFinishEditingPhotoNotification            = @"com.Photopon.tabBarController.didFinishEditingPhoto";
NSString *const PhotoponTabBarControllerDidFinishImageFileUploadNotification         = @"com.Photopon.tabBarController.didFinishImageFileUploadNotification";
NSString *const PhotoponPhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.Photopon.photoDetailsViewController.userDeletedPhoto";
NSString *const PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.Photopon.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const PhotoponPhotoDetailsViewControllerUserSnippedUnsnippedPhotoNotification = @"com.Photopon.photoDetailsViewController.userSnippedUnsnippedPhotoInDetailsViewNotification";
NSString *const PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.Photopon.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kPhotoponEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kPhotoponInstallationUserKey    = @"user";

#pragma mark - Activity Class
// Class key
NSString *const kPhotoponActivityClassKey       = @"Activity";

// Field keys
NSString *const kPhotoponActivityTypeKey        = @"type";
NSString *const kPhotoponActivityFromUserKey    = @"fromUser";
NSString *const kPhotoponActivityToUserKey      = @"toUser";
NSString *const kPhotoponActivityContentKey     = @"content";
NSString *const kPhotoponActivityPhotoKey       = @"photo";

// Type values
NSString *const kPhotoponActivityTypeLike       = @"like";
NSString *const kPhotoponActivityTypeFollow     = @"follow";
NSString *const kPhotoponActivityTypeComment    = @"comment";
NSString *const kPhotoponActivityTypeJoined     = @"joined";



#pragma mark - Base Entity Attribute Keys

// Base/Standard/Generic keys
NSString *const kPhotoponModelIdentifierKey                             = @"identifier";
NSString *const kPhotoponCurrentUserKey                                 = @"currentUser";
NSString *const kPhotoponEntityIdentifierKey                            = @"entityIdentifier";
NSString *const kPhotoponEntityNameKey                                  = @"entityName";
NSString *const kPhotoponCreatedTimeKey                                 = @"createdTime";


#pragma mark - Cached Current User
// Field keys
NSString *const kPhotoponCurrentUserAttributesUsernameKey               = @"current_username";
NSString *const kPhotoponCurrentUserAttributesPasswordKey               = @"current_password";
NSString *const kPhotoponCurrentUserAttributesPhotoponAppSecretKey      = @"photopon_app_secret";
NSString *const kPhotoponCurrentUserAttributesPhotoponAppKeyKey         = @"photopon_app_key";

#pragma mark - Cached HashTag Attributes
// Field keys
NSString *const kPhotoponHashTagAttributesContentKey                   = @"content";

#pragma mark - Cached User Attributes
// Field keys
NSString *const kPhotoponUserAttributesCurrentUserKey                   = @"currentUserKey";
NSString *const kPhotoponUserAttributesIdentifierKey                    = @"identifier";
NSString *const kPhotoponUserAttributesUsernameKey                      = @"username";
NSString *const kPhotoponUserAttributesFullNameKey                      = @"fullName";
NSString *const kPhotoponUserAttributesFirstNameKey                     = @"firstName";
NSString *const kPhotoponUserAttributesLastNameKey                      = @"lastName";
NSString *const kPhotoponUserAttributesEmailKey                         = @"email";
NSString *const kPhotoponUserAttributesBioKey                           = @"bio";
NSString *const kPhotoponUserAttributesWebsiteKey                       = @"website";
NSString *const kPhotoponUserAttributesProfilePictureUrlKey             = @"profilePictureUrl";
NSString *const kPhotoponUserAttributesProfileCoverPictureUrlKey        = @"profileCoverPictureUrl";
NSString *const kPhotoponUserAttributesFollowedByCountKey               = @"followedByCount";
NSString *const kPhotoponUserAttributesFollowersCountKey                = @"followersCount";
NSString *const kPhotoponUserAttributesRedeemCountKey                   = @"redeemCount";
NSString *const kPhotoponUserAttributesMediaCountKey                    = @"mediaCount";
NSString *const kPhotoponUserAttributesScoreKey                         = @"score";
NSString *const kPhotoponUserAttributesDidFollowKey                     = @"didFollow";
NSString *const kPhotoponUserAttributesMediaCountStringKey              = @"mediaCountString";
NSString *const kPhotoponUserAttributesFollowersCountStringKey          = @"followersCountString";
NSString *const kPhotoponUserAttributesFollowedByCountStringKey         = @"followedByCountString";
NSString *const kPhotoponUserAttributesRedeemCountStringKey             = @"redeemCountString";
NSString *const kPhotoponUserAttributesScoreStringKey                   = @"scoreString";
NSString *const kPhotoponUserAttributesDidFollowStringKey               = @"didFollowString";
NSString *const kPhotoponUserAttributesFacebookFriendsKey               = @"facebookFriends";
NSString *const kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey      = @"alreadyAutoFollowedFacebookFriends";

NSString *const kPhotoponUserAttributesFacebookIDKey          = @"facebookID";
NSString *const kPhotoponUserAttributesFacebookAccessTokenKey = @"facebookAccessToken";
NSString *const kPhotoponUserAttributesInstagramIDKey         = @"instagramID";
NSString *const kPhotoponUserAttributesTwitterIDKey           = @"twitterID";

#pragma mark - Media Class
// Class key
NSString *const kPhotoponMediaClassKey = @"Media";

// Field keys
NSString *const kPhotoponMediaPictureKey         = @"image";
NSString *const kPhotoponMediaThumbnailKey       = @"thumbnail";
NSString *const kPhotoponMediaUserKey            = @"user";
NSString *const kPhotoponMediaOpenGraphIDKey     = @"fbOpenGraphID";

#pragma mark - Cached Media Attributes

/* ************************************************************ */
/* New Photopon Draft keys                                      */
/* ************************************************************ */
/*      NOTE:   Used to interface with NSUserDefaults (in the   //
 *              case of a crash or lost network connection      //
 *              during new Photopon composition                 */
/* ************************************************************ */

NSString *const kPhotoponMediaAttributesNewPhotoponLocalImageFileNameKey        = @"newPhotoponLocalImageFileName";
NSString *const kPhotoponMediaAttributesNewPhotoponLocalImageFilePathKey        = @"newPhotoponLocalImageFilePath";
NSString *const kPhotoponMediaAttributesNewPhotoponMediaKey                     = @"newPhotoponMediaKey";
NSString *const kPhotoponMediaAttributesNewPhotoponCouponKey                    = @"newPhotoponCouponKey";
NSString *const kPhotoponMediaAttributesNewPhotoponPlaceKey              = @"newPhotoponPlaceKey";


/*
$comment_model = array('identifier' 				=> $identifier,
                       'content'					=> $content,
                       'activityID' 				=> $act_id_string_media, // media item activity id
                       'mediaID' 					=> $media_id,
                       'user' 						=> $user_model,
                       'location_identifier' 		=> $locationIdentifier,
                       'location_latitude' 		=> $locationLatitude,
                       'location_longitude' 		=> $locationLongitude,
                       'createdTime' 				=> $createdTime,
                       'isEditing'					=> 'NO');
*/



// comment attributes keys
NSString *const kPhotoponCommentAttributesIdentifierKey             = @"identifier";
NSString *const kPhotoponCommentAttributesContentKey                = @"content";
NSString *const kPhotoponCommentAttributesActivityIDKey             = @"activityID";
NSString *const kPhotoponCommentAttributesMediaIDKey                = @"mediaID";
NSString *const kPhotoponCommentAttributesUserKey                   = @"user";
NSString *const kPhotoponCommentAttributesLocationIdentifierKey     = @"location_identifier";
NSString *const kPhotoponCommentAttributesLocationLatitudeKey       = @"location_latitude";
NSString *const kPhotoponCommentAttributesLocationLongitudeKey      = @"location_longitude";
NSString *const kPhotoponCommentAttributesCreatedTimeKey            = @"createdTime";
NSString *const kPhotoponCommentAttributesIsEditingKey              = @"isEditing";

// activity attributes keys
NSString *const kPhotoponActivityAttributesIdentifierKey            = @"identifier";
NSString *const kPhotoponActivityAttributesTitleKey                 = @"title";
NSString *const kPhotoponActivityAttributesMediaIdentifierKey       = @"media_identifier";
NSString *const kPhotoponActivityAttributesUserIdentifierKey        = @"user_identifier";
NSString *const kPhotoponActivityAttributesThumbnailURLKey          = @"thumbnail_url";
NSString *const kPhotoponActivityAttributesFromUserKey              = @"from_user";
NSString *const kPhotoponActivityAttributesToUserKey                = @"to_user";
NSString *const kPhotoponActivityAttributesContentKey               = @"content";
NSString *const kPhotoponActivityAttributesPhotoKey                 = @"photo";
NSString *const kPhotoponActivityAttributesTypeKey                  = @"type";

// Activity attributes values
NSString *const kPhotoponActivityAttributesTypeLike                 = @"type_like";
NSString *const kPhotoponActivityAttributesTypeFollow               = @"type_follow";
NSString *const kPhotoponActivityAttributesTypeSnip                 = @"type_snip";
NSString *const kPhotoponActivityAttributesTypeRedeem               = @"type_redeem";
NSString *const kPhotoponActivityAttributesTypeComment              = @"type_comment";
NSString *const kPhotoponActivityAttributesTypeJoined               = @"type_joined";

// media attributes keys
NSString *const kPhotoponMediaAttributesIdentifierKey               = @"identifier";
NSString *const kPhotoponMediaAttributesCoordinateKey               = @"coordinate";
NSString *const kPhotoponMediaAttributesValueTitleKey               = @"value_title";
NSString *const kPhotoponMediaAttributesCostKey                     = @"cost";
NSString *const kPhotoponMediaAttributesMonetaryValueKey            = @"monetaryValue";
NSString *const kPhotoponMediaAttributesSocialValueKey              = @"socialValue";
NSString *const kPhotoponMediaAttributesCaptionKey                  = @"caption";
NSString *const kPhotoponMediaAttributesLinkURLKey                  = @"linkURL";
NSString *const kPhotoponMediaAttributesLikeCountKey                = @"likeCount";
NSString *const kPhotoponMediaAttributesLikersKey                   = @"likers";
NSString *const kPhotoponMediaAttributesCommentCountKey             = @"commentCount";
NSString *const kPhotoponMediaAttributesCommentersKey               = @"commenters";
NSString *const kPhotoponMediaAttributesSnipCountKey                = @"snipCount";
NSString *const kPhotoponMediaAttributesSnippersKey                 = @"snippers";
NSString *const kPhotoponMediaAttributesUserKey                     = @"user";
NSString *const kPhotoponMediaAttributesCouponKey                   = @"coupon";
NSString *const kPhotoponMediaAttributesThumbURLKey                 = @"thumbURL";
NSString *const kPhotoponMediaAttributesImageMidURLKey              = @"imageMidURL";
NSString *const kPhotoponMediaAttributesImageLargeURLKey            = @"imageLargeURL";
NSString *const kPhotoponMediaAttributesLocationIdentifierKey       = @"location_identifier";
NSString *const kPhotoponMediaAttributesLocationLatitudeKey         = @"location_latitude";
NSString *const kPhotoponMediaAttributesLocationLongitudeKey        = @"location_longitude";
NSString *const kPhotoponMediaAttributesCreatedTimeKey              = @"createdTime";
NSString *const kPhotoponMediaAttributesUsersKey                    = @"users";
NSString *const kPhotoponMediaAttributesTagsKey                     = @"tags";
NSString *const kPhotoponMediaAttributesDidLikeKey                  = @"didLike";
NSString *const kPhotoponMediaAttributesDidSnipKey                  = @"didSnip";
NSString *const kPhotoponMediaAttributesDidLikeBoolKey              = @"did_like_bool";
NSString *const kPhotoponMediaAttributesDidSnipBoolKey              = @"did_snip_bool";

#pragma mark - Cached Coupon Attributes
// keys
NSString *const kPhotoponCouponAttributesIdentifierKey              = @"identifier";
NSString *const kPhotoponCouponAttributesDetailsKey                 = @"details";
NSString *const kPhotoponCouponAttributesTermsKey                   = @"terms";
NSString *const kPhotoponCouponAttributesInstructionsKey            = @"instructions";
NSString *const kPhotoponCouponAttributesStartKey                   = @"start";
NSString *const kPhotoponCouponAttributesStartStringKey             = @"startString";
NSString *const kPhotoponCouponAttributesExpirationKey              = @"expiration";
NSString *const kPhotoponCouponAttributesExpirationStringKey        = @"expirationString";
NSString *const kPhotoponCouponAttributesExpirationTextStringKey    = @"expirationTextString";
NSString *const kPhotoponCouponAttributesPlaceKey                   = @"place";
NSString *const kPhotoponCouponAttributesCouponTypeKey              = @"coupon_type";
NSString *const kPhotoponCouponAttributesCouponURLKey               = @"coupon_url";
NSString *const kPhotoponCouponAttributesValueKey                   = @"value";

#pragma mark - Cached Place Attributes

// meta keys
NSString *const kPhotoponPlaceAttributesMetaOfferSourceURLKey       = @"offer_source_url";
NSString *const kPhotoponPlaceAttributesMetaOfferSourceImageURLKey  = @"offer_source_image_url";
NSString *const kPhotoponPlaceAttributesMetaOfferSourceNameKey      = @"offer_source_name";
// keys
NSString *const kPhotoponPlaceAttributesIdentifierKey               = @"identifier";
NSString *const kPhotoponPlaceAttributesPublicIDKey                 = @"publicID";
NSString *const kPhotoponPlaceAttributesNameKey                     = @"name";
NSString *const kPhotoponPlaceAttributesAddressFullKey              = @"addressFull";
NSString *const kPhotoponPlaceAttributesStreetKey                   = @"street";
NSString *const kPhotoponPlaceAttributesCityKey                     = @"city";
NSString *const kPhotoponPlaceAttributesStateKey                    = @"state";
NSString *const kPhotoponPlaceAttributesZipKey                      = @"zip";
NSString *const kPhotoponPlaceAttributesPhoneKey                    = @"phone";
NSString *const kPhotoponPlaceAttributesCategoryKey                 = @"category";
NSString *const kPhotoponPlaceAttributesImageURLKey                 = @"imageUrl";
NSString *const kPhotoponPlaceAttributesBioKey                      = @"bio";
NSString *const kPhotoponPlaceAttributesLocationIdentifierKey       = @"locationIdentifier";
NSString *const kPhotoponPlaceAttributesLocationLatitudeKey         = @"locationLatitude";
NSString *const kPhotoponPlaceAttributesLocationLongitudeKey        = @"locationLongitude";
NSString *const kPhotoponPlaceAttributesRatingKey                   = @"rating";
NSString *const kPhotoponPlaceAttributesURLKey                      = @"url";

#pragma mark - Cached Tag Attributes

NSString *const kPhotoponTagAttributesIdentifierKey                  = @"identifier";
NSString *const kPhotoponTagAttributesTaggedObjectTitleKey           = @"taggedObjectTitle";
NSString *const kPhotoponTagAttributesTaggedObjectIdentifierKey      = @"taggedObjectIdentifier";
NSString *const kPhotoponTagAttributesTaggedObjectClassNameKey       = @"taggedObjectClassName";
NSString *const kPhotoponTagAttributesAddedTimeKey                   = @"addedTime";

#pragma mark - Cached User Attributes
// keys
NSString *const kPhotoponUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kPhotoponUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";

// Date
NSString *const kPhotoponLastSyncDate = @"lastSyncDate";

#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kPhotoponPushPayloadPayloadTypeKey          = @"p";
NSString *const kPhotoponPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kPhotoponPushPayloadActivityTypeKey     = @"t";
NSString *const kPhotoponPushPayloadActivityLikeKey     = @"l";
NSString *const kPhotoponPushPayloadActivityCommentKey  = @"c";
NSString *const kPhotoponPushPayloadActivityFollowKey   = @"f";

NSString *const kPhotoponPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kPhotoponPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kPhotoponPushPayloadPhotoObjectIdKey    = @"pid";