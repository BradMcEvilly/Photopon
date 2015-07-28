//
//  PhotoponImageModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponImageModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponAppDelegate.h"
//#import "PhotoponConstants.h"
//#import "UIImage+Resize.h"
//#import "NSString+Helpers.h"
//#import "SFHFKeychainUtils.h"
//#import "AFXMLRPCClient.h"


@interface PhotoponImageModel (PrivateMethods)
- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure ;
@end

@implementation PhotoponImageModel {
    //AFHTTPRequestOperation *_uploadOperation;
}

@synthesize image;
@synthesize binData;
@synthesize width;
@synthesize height;
@synthesize fullUrl;
@synthesize largeUrl;
@synthesize large2xUrl;

//@synthesize options;
@synthesize appDelegate;


- (id) init{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        // Custom initialization
        //[self operationForOptionsWithSuccess:nil failure:nil];
        appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
    }
    return self;    
}
/*
- (void)awakeFromFetch {
    if ((self.remoteStatus == PhotoponGalleryMediaRemoteStatusPushing && _uploadOperation == nil) || (self.remoteStatus == PhotoponGalleryMediaRemoteStatusProcessing)) {
        self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
    }
}

- (float)progress {
    [self willAccessValueForKey:@"progress"];
    NSNumber *result = [self primitiveValueForKey:@"progress"];
    [self didAccessValueForKey:@"progress"];
    return [result floatValue];
}

- (void)setProgress:(float)progress {
    [self willChangeValueForKey:@"progress"];
    [self setPrimitiveValue:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    [self didChangeValueForKey:@"progress"];
}

- (PhotoponGalleryMediaRemoteStatus)remoteStatus {
    return (PhotoponGalleryMediaRemoteStatus)[[self remoteStatusNumber] intValue];
}

- (void)setRemoteStatus:(PhotoponGalleryMediaRemoteStatus)aStatus {
    [self setRemoteStatusNumber:[NSNumber numberWithInt:aStatus]];
}

+ (NSString *)titleForRemoteStatus:(NSNumber *)remoteStatus {
    switch ([remoteStatus intValue]) {
        case PhotoponGalleryMediaRemoteStatusPushing:
            return NSLocalizedString(@"Uploading", @"");
            break;
        case PhotoponGalleryMediaRemoteStatusFailed:
            return NSLocalizedString(@"Failed", @"");
            break;
        case PhotoponGalleryMediaRemoteStatusSync:
            return NSLocalizedString(@"Uploaded", @"");
            break;
        default:
            return NSLocalizedString(@"Pending", @"");
            break;
    }
}

- (NSString *)remoteStatusText {
    return [PhotoponImageModel titleForRemoteStatus:self.remoteStatusNumber];
}


- (void)setPhotoponImage:(UIImage *)aImage withSize:(MediaResize)size {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setPhotoponImage", @"")
                                                        message:@"made it"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    alertView.tag = 20;
    [alertView show];
    [alertView release];
    
    
    
    / *
    //Read the predefined resizeDimensions and fix them by using the image orietation
    //NSDictionary* predefDim = [self getImageResizeDimensions];
    CGSize smallSize = CGSizeMake(290.0f, 194.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
    CGSize mediumSize = CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
    CGSize largeSize =  CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
    switch (aImage.imageOrientation) { 
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            smallSize = CGSizeMake(smallSize.height, smallSize.width);
            mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
            largeSize = CGSizeMake(largeSize.height, largeSize.width);
            break;
        default:
            break;
    }
    
    CGSize newSize;
    switch (size) {
        case kResizeSmall:
			newSize = smallSize;
            break;
        case kResizeMedium:
            newSize = mediumSize;
            break;
        case kResizeLarge:
            newSize = largeSize;
            break;
        default:
            newSize = aImage.size;
            break;
    }
    
    switch (aImage.imageOrientation) { 
        case UIImageOrientationUp: 
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDown: 
        case UIImageOrientationDownMirrored:
            self.orientation = @"landscape";
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            self.orientation = @"portrait";
            break;
        default:
            self.orientation = @"portrait";
    }
    
    //The dimensions of the image, taking orientation into account.
    CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
    
    UIImage *resizedImage = aImage;
    if(aImage.size.width > newSize.width || aImage.size.height > newSize.height)
        resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                   bounds:newSize
                                     interpolationQuality:kCGInterpolationHigh];
    else  
        resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                   bounds:originalSize
                                     interpolationQuality:kCGInterpolationHigh];
    * /
    NSData *imageData = self.binData;//UIImageJPEGRepresentation(image, 0.90);
	//UIImage *imageThumbnail = [image thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	//[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
    
    
    
    //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSData *imageData = UIImagePNGRepresentation(pickedImage);
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imageName.png"];
    
    NSError * error = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
        return;
    }
    
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *documentsDirectory = [paths objectAtIndex:0];
	//NSString *photoponPhotoFilename = @"/test.png";//[NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
    //[formatter release]; formatter = nil;
	//NSString *filepath = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    //fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
    / *
	self.creationDate = [NSDate date];
	self.filename = photoponPhotoFilename;
	self.localURL = filepath;
	self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
	self.mediaType = @"image";
	self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
	self.width = [NSNumber numberWithInt:resizedImage.size.width];
	self.height = [NSNumber numberWithInt:resizedImage.size.height];
    
    
    
    [self setCreationDate:[NSDate date]];
	[self setFilename:path];
    
    
	[self setLocalURL:filepath];
	[self setFilesize:[NSNumber numberWithInt:(imageData.length/1024)]];
	[self setMediaType:@"image"];
	//[self setThumbnail:UIImageJPEGRepresentation(imageThumbnail, 0.90)];
	[self setWidth:[NSNumber numberWithInt:image.size.width]];
	[self setHeight:[NSNumber numberWithInt:image
                     .size.height]];
    */
    /* EMMA'S CODE
    [self setCreationDate:[NSDate date]];
	[self setFilename:photoponPhotoFilename];
	[self setLocalURL:filepath];vc8bdçc1`1X
	[self setFilesize:[NSNumber numberWithInt:(imageData.length/1024)]];
	[self setMediaType:@"image"];
	[self setThumbnail:UIImageJPEGRepresentation(imageThumbnail, 0.90)];
	[self setWidth:[NSNumber numberWithInt:resizedImage.size.width]];
	[self setHeight:[NSNumber numberWithInt:resizedImage.size.height]];QZXXB  BMC
    * /
}

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    //[self save];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadWithSuccess", @"")
                                                        message:@"made it"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    alertView.tag = 20;
    [alertView show];
    [alertView release];
    
    self.progress = 0.0f;
    
    [self xmlrpcUploadWithSuccess:success failure:failure];
    
    / *
     if (!self.blog.isWPcom && [self.mediaType isEqualToString:@"video"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"video_api_preference"] intValue] == 1) {
     [self atomPubUploadWithSuccess:success failure:failure];
     } else {
     [self xmlrpcUploadWithSuccess:success failure:failure];
     }* /
}



- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"xmlrpcUploadWithSuccess", @"")
                                                        message:@"made it"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    alertView.tag = 20;
    [alertView show];
    [alertView release];
    
    NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
                            mimeType, @"type",
                            self.filename, @"name",
                            [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
                            nil];
    
    NSArray *parameters = [appDelegate getXMLRPCArgsWithExtra:object];
    
    self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
    
    AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];    
    //[api callMethod:@"bp.updateProfileStatus"
    [api callMethod:@"wp.uploadFile"
         parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Well, that upload failed", @"")
                                                                    message:[error localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                alertView.tag = 20;
                [alertView show];
                [alertView release]; 
                //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
                
                
                NSLog(@"--------->");
                NSLog(@"-------------------------------------------------------------");
                NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
                NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
                NSLog(@"-------------------------------------------------------------");
                NSLog(@"--------->");
                
                
                
            }];
  
    
    
    
    
    
    
    
    
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        // Create the request asynchronously
        // TODO: use streaming to avoid processing on memory
        
        / *
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        NSAutoreleasePool *pool = [NSAutoreleasePool new];

        AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];    
        //[api callMethod:@"bp.updateProfileStatus"
        [api callMethod:@"bp.uploadMediaObject"
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    //NSString *status = [[NSString alloc] init];
                    //status = @"";
                    //NSDictionary *returnData = [responseObject retain];
                    
                    
                    / *
                     NSArray *errors = [NSArray arrayWithObjects:@"field_1", @"password", @"field_5", @"field_6", @"field_7", nil];
                     for (id e in errors) {
                     if ([returnData valueForKey:e])
                     status = [returnData valueForKey:e];
                     }
                     
                     if ([status isEqualToString:@""])
                     status = @"Success";
                     
                     if (status != @"Success") {
                     [self setFooterText:@"Error"];
                     [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];                
                     } else {* /
                    
                    // You're now ready to pull money out of thin air and make your first photopon. Have fun!
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload Awesome!", @"") 
                                                                    message:NSLocalizedString(@"Uploaded successfully!", @"")
                                                                   delegate:self 
                                                          cancelButtonTitle:@"OK" 
                                                          otherButtonTitles:nil];
                    
                    alert.tag = 10;
                    [alert autorelease];
                    [alert show];
                    //}
                    
                    
                    
                    NSDictionary *response = (NSDictionary *)responseObject;
                    if([response objectForKey:@"videopress_shortcode"] != nil)
                        self.shortcode = [response objectForKey:@"videopress_shortcode"];
                    
                    if([response objectForKey:@"url"] != nil)
                        self.remoteURL = [response objectForKey:@"url"];
                    
                    if ([response objectForKey:@"id"] != nil) {
                        self.mediaID = [[response objectForKey:@"id"] numericValue];
                    }
                    
                    self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
                    [_uploadOperation release]; _uploadOperation = nil;
                    if (success) success();
                    
                    if([self.mediaType isEqualToString:@"video"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                                                                            object:self
                                                                          userInfo:response];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                            object:self
                                                                          userInfo:response];
                    }
                    
                    
                    
                    NSLog(@"--------->");
                    NSLog(@"-------------------------------------------------------------");
                    NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
                    NSLog(@"CREATE ACCOUNT SUCCESS!!!");
                    NSLog(@"-------------------------------------------------------------");
                    NSLog(@"--------->");
                    
                    
                    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    
                    //[appDelegate showLoggedIn];
                    
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Well, that upload failed", @"")
                                                                        message:[error localizedDescription]
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                    alertView.tag = 20;
                    [alertView show];
                    [alertView release]; 
                    //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
                    
                    
                    NSLog(@"--------->");
                    NSLog(@"-------------------------------------------------------------");
                    NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
                    NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
                    NSLog(@"-------------------------------------------------------------");
                    NSLog(@"--------->");
                    
                    
                    
                }];
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
            });
        }];
        
        [pool release];
        
    }
        
        
        
        
        
        
        
        
        
        
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    //AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];    
    //[api callMethod:@"bp.updateProfileStatus"
    
    //dispatch_async(dispatch_get_main_queue(), ^(void) {
        
    NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"wp.uploadFile" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationInternal, id responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response objectForKey:@"videopress_shortcode"] != nil)
            self.shortcode = [response objectForKey:@"videopress_shortcode"];
        
        if([response objectForKey:@"url"] != nil)
            self.remoteURL = [response objectForKey:@"url"];
        
        if ([response objectForKey:@"id"] != nil) {
            self.mediaID = [[response objectForKey:@"id"] numericValue];
        }
        
        self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
        [_uploadOperation release]; _uploadOperation = nil;
        if (success) success();
        
        if([self.mediaType isEqualToString:@"video"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                                                                object:self
                                                              userInfo:response];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                object:self
                                                              userInfo:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
        [_uploadOperation release]; _uploadOperation = nil;
        if (failure) failure(error);
    }];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
        });
    }];
    _uploadOperation = [operation retain];
    self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
    [appDelegate.api enqueueHTTPRequestOperation:operation];
    
    [pool release];
    
    
    
    
    
    
    / *[api callMethod:@"bp.verifyConnection"
         parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject){ 
                
            
                
        
                
                
    //AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
        
        
        
            //AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *response = (NSDictionary *)responseObject;
                if([response objectForKey:@"videopress_shortcode"] != nil)
                    self.shortcode = [response objectForKey:@"videopress_shortcode"];
                
                if([response objectForKey:@"url"] != nil)
                    self.remoteURL = [response objectForKey:@"url"];
                
                if ([response objectForKey:@"id"] != nil) {
                    self.mediaID = [[response objectForKey:@"id"] numericValue];
                }
                
                self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
                [_uploadOperation release]; _uploadOperation = nil;
                if (success) success();
                
                if([self.mediaType isEqualToString:@"video"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                                                                        object:self
                                                                      userInfo:response];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                        object:self
                                                                      userInfo:response];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
                [_uploadOperation release]; _uploadOperation = nil;
                if (failure) failure(error);
            }];
            [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                });
            }];
            _uploadOperation = [operation retain];
            self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
            [appDelegate.api enqueueHTTPRequestOperation:operation];
        });
     
    });
     * /
}

- (NSString *)html {
	NSString *result = @"";
	
	if(self.mediaType != nil) {
		if([self.mediaType isEqualToString:@"image"]) {
			if(self.shortcode != nil)
				result = self.shortcode;
			else if(self.remoteURL != nil) {
                NSString *linkType = @"none";//[self getOptionValue:@"image_default_link_type"];
                if ([linkType isEqualToString:@"none"]) {
                    result = [NSString stringWithFormat:
                              @"<img src=\"%@\" alt=\"%@\" class=\"alignnone size-full\" />",
                              self.remoteURL, self.filename];
                } else {
                    result = [NSString stringWithFormat:
                              @"<a href=\"%@\"><img src=\"%@\" alt=\"%@\" class=\"alignnone size-full\" /></a>",
                              self.remoteURL, self.remoteURL, self.filename];
                }
            }
		}
		else if([self.mediaType isEqualToString:@"video"]) {
			NSString *embedWidth = [NSString stringWithFormat:@"%@", self.width];
			NSString *embedHeight= [NSString stringWithFormat:@"%@", self.height];
			
			// Check for landscape resize
			if(([self.width intValue] > [self.height intValue]) && ([self.width intValue] > 640)) {
				embedWidth = @"640";
				embedHeight = @"360";
			}
			else if(([self.height intValue] > [self.width intValue]) && ([self.height intValue] > 640)) {
				embedHeight = @"640";
				embedWidth = @"360";
			}
			
			if(self.shortcode != nil)
				result = self.shortcode;
			else if(self.remoteURL != nil) {
				self.remoteURL = [self.remoteURL stringByReplacingOccurrencesOfString:@"\"" withString:@""];
				NSNumber *htmlPreference = [NSNumber numberWithInt:
											[[[NSUserDefaults standardUserDefaults] 
											  objectForKey:@"video_html_preference"] intValue]];
				
				if([htmlPreference intValue] == 0) {
					// Use HTML 5 <video> tag
					result = [NSString stringWithFormat:
							  @"<video src=\"%@\" controls=\"controls\" width=\"%@\" height=\"%@\">"
							  "Your browser does not support the video tag"
							  "</video>",
							  self.remoteURL, 
							  embedWidth, 
							  embedHeight];
				}
				else {
					// Use HTML 4 <object><embed> tags
					embedHeight = [NSString stringWithFormat:@"%d", ([embedHeight intValue] + 16)];
					result = [NSString stringWithFormat:
							  @"<object classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\""
							  "codebase=\"http://www.apple.com/qtactivex/qtplugin.cab\""
							  "width=\"%@\" height=\"%@\">"
							  "<param name=\"src\" value=\"%@\">"
							  "<param name=\"autoplay\" value=\"false\">"
							  "<embed src=\"%@\" autoplay=\"false\" "
							  "width=\"%@\" height=\"%@\" type=\"video/quicktime\" "
							  "pluginspage=\"http://www.apple.com/quicktime/download/\" "
							  "/></object>",
							  embedWidth, embedHeight, self.remoteURL, self.remoteURL, embedWidth, embedHeight];
				}
				
				NSLog(@"media.html: %@", result);
			}
		}
	}
	
	return result;
}

- (NSString *)mediaTypeName {
    if ([self.mediaType isEqualToString:@"image"]) {
        return NSLocalizedString(@"Image", @"");
    } else if ([self.mediaType isEqualToString:@"video"]) {
        return NSLocalizedString(@"Video", @"");
    } else {
        return self.mediaType;
    }
}
         */

@end
