//
//  PhotoponFile.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponFile.h"
#import "PhotoponModel.h"
#import "PhotoponMediaModel.h"
#import "UIImage+Resize.h"
#import "NSString+Helpers.h"
#import "AFHTTPRequestOperation.h"
#import "PhotoponWelcomeViewController.h"
#import "PhotoponUploadHeaderView.h"
#import "UIImage+Scaling.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponNewPhotoponUtility.h"

@interface PhotoponFile (PrivateMethods)
- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure ;
@end

@implementation PhotoponFile {
    AFHTTPRequestOperation *_uploadOperation;
    float _progress;
}

//@synthesize pmm;

@synthesize mediaID;
@synthesize mediaType;
@synthesize remoteURL;
@synthesize localURL;
@synthesize localURLRaw;
@synthesize shortcode;
@synthesize width;
@synthesize length;
@synthesize title;
@synthesize thumbnail;
@synthesize height;
@synthesize filename;
@synthesize filenameRaw;
@synthesize filesize;
@synthesize orientation;
@synthesize creationDate;
@synthesize posts;
@synthesize remoteStatusNumber;
//@synthesize progress;
@synthesize photoponUploadHeaderView;

+ (PhotoponFile *)initNewPhotoponFile {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponFile *photoponMediaImageFile = [[PhotoponFile alloc] init];
    
    
    return photoponMediaImageFile;
}

- (void)awakeFromFetch {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ((self.remoteStatus == FileRemoteStatusPushing && _uploadOperation == nil) || (self.remoteStatus == FileRemoteStatusProcessing)) {
        self.remoteStatus = FileRemoteStatusFailed;
    }
}
/*
-(void)setPhotoponUploadHeaderView:(PhotoponUploadHeaderView *)photoponUploadHeaderView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self.photoponUploadHeaderView = photoponUploadHeaderView;
    
    [self addObserver:photoponUploadHeaderView forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(PhotoponUploadHeaderView*)photoponUploadHeaderView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.photoponUploadHeaderView;
}
*/
-(PhotoponModelManager *)pmm{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] pmm];
}

- (float)progress {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self willAccessValueForKey:@"progress"];
    //NSNumber *result = [self valueForKey:@"progress"];
    //[self didAccessValueForKey:@"progress"];
    
    return _progress;  //[result floatValue];
}

- (void)setProgress:(float)aProgress {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self willChangeValueForKey:@"progress"];
    //[self setValue:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    
    _progress = aProgress;
    
    
    
    
    if (!self.photoponUploadHeaderView){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (!self.photoponUploadHeaderView) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        
        
    }else{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else (!self.photoponUploadHeaderView) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }
    
    
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        
        
        //self.photoponUploadHeaderView.progress = self.progress;
        
    });
    */
    //[self didChangeValueForKey:@"progress"];
    
}

- (FileRemoteStatus)remoteStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (FileRemoteStatus)[[self remoteStatusNumber] intValue];
}

- (void)setRemoteStatus:(FileRemoteStatus)aStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setRemoteStatusNumber:[NSNumber numberWithInt:aStatus]];
}

+ (NSString *)titleForRemoteStatus:(NSNumber *)remoteStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch ([remoteStatus intValue]) {
        case FileRemoteStatusPushing:
            return NSLocalizedString(@"Uploading", @"");
            break;
        case FileRemoteStatusFailed:
            return NSLocalizedString(@"Failed", @"");
            break;
        case FileRemoteStatusSync:
            return NSLocalizedString(@"Uploaded", @"");
            break;
        default:
            return NSLocalizedString(@"Pending", @"");
            break;
    }
}

- (NSString *)remoteStatusText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponFile titleForRemoteStatus:self.remoteStatusNumber];
}

- (void)remove {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self cancelUpload];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.localURL error:&error];
}

- (void)removeRaw {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.localURLRaw error:&error];
}

- (void)save {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        WPFLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    */
    
    
}

- (void)cancelUpload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.remoteStatus == FileRemoteStatusPushing || self.remoteStatus == FileRemoteStatusProcessing) {
        [_uploadOperation cancel];
        _uploadOperation = nil;
        self.remoteStatus = FileRemoteStatusFailed;
    }
}

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self save];
    self.progress = 0.0f;
    
    [self xmlrpcUploadWithSuccess:success failure:failure];
}

- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
                            mimeType, @"type",
                            self.filename, @"name",
                            [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
                            nil];
    NSArray *parameters = [self.pmm getXMLRPCArgsWithExtra:object];
    
    self.remoteStatus = FileRemoteStatusProcessing;

    __weak __typeof(&*self)weakSelf = self;    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        // Create the request asynchronously
        // TODO: use streaming to avoid processing on memory
        NSMutableURLRequest *request = [weakSelf.pmm.api requestWithMethod:@"bp.uploadPhotoponMediaFile" parameters:parameters];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
                //if ([self isDeleted])
                    //return;
                
                if ([weakSelf.mediaType isEqualToString:@"featured"]) {
                    
                //[[NSNotificationCenter defaultCenter] postNotificationName:FeaturedImageUploadFailed object:self];
                    
                }
                
                weakSelf.remoteStatus = FileRemoteStatusFailed;
                _uploadOperation = nil;
                if (failure) failure(error);
            };
            AFHTTPRequestOperation *operation = [weakSelf.pmm.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //if ([self isDeleted])
                    //return;
                
                NSDictionary *response = (NSDictionary *)responseObject;
                
                if (![response isKindOfClass:[NSDictionary class]]) {
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The server returned an empty response. This usually means you need to increase the memory limit in your blog", @"")}];
                    failureBlock(operation, error);
                    return;
                }
                if([response objectForKey:@"videopress_shortcode"] != nil)
                    weakSelf.shortcode = [response objectForKey:@"videopress_shortcode"];
                
                if([response objectForKey:@"url"] != nil)
                    weakSelf.remoteURL = [response objectForKey:@"url"];
                
                if ([response objectForKey:@"id"] != nil) {
                    weakSelf.mediaID = [response objectForKey:kPhotoponModelIdentifierKey];
                }
                
                weakSelf.remoteStatus = FileRemoteStatusSync;
                _uploadOperation = nil;
                if (success) success();
                
                if([weakSelf.mediaType isEqualToString:@"video"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                                                                        object:weakSelf
                                                                      userInfo:response];
                } else if ([self.mediaType isEqualToString:@"image"]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                        object:weakSelf
                                                                      userInfo:response];
                } else if ([self.mediaType isEqualToString:@"featured"]){
                    //[[NSNotificationCenter defaultCenter] postNotificationName:FeaturedImageUploadSuccessful object:self userInfo:response];
                    
                }
            } failure:failureBlock];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //if ([self isDeleted])
                        //return;
                    weakSelf.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                });
            }];
            _uploadOperation = operation;
            
            // Upload might have been canceled while processing
            if (weakSelf.remoteStatus == FileRemoteStatusProcessing) {
                weakSelf.remoteStatus = FileRemoteStatusPushing;
                [weakSelf.pmm.api enqueueHTTPRequestOperation:operation];
            }
        });
    });
}

- (NSString *)html {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	NSString *result = @"";
	
	if(self.mediaType != nil) {
		if([self.mediaType isEqualToString:@"image"]) {
			if(self.shortcode != nil)
				result = self.shortcode;
			else if(self.remoteURL != nil) {
                NSString *linkType = nil;
                if( [[self.pmm getOptionValue:@"image_default_link_type"] isKindOfClass:[NSString class]] )
                    linkType = (NSString *)[self.pmm getOptionValue:@"image_default_link_type"];
                else
                    linkType = @"";
                
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
/*
+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
    
}*/



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([keyPath isEqualToString:@"progress"]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([keyPath isEqualToString:@progress]) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        self.photoponUploadHeaderView.progress = self.progress;
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            self.photoponUploadHeaderView.progress = self.progress", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }
    
    
    /*
    if( [keyPath isEqualToString:@"dataManager.cleanedUp"] )
    {
        if( [[[self dataManager] cleanedUp] isEqualToString:@"Yes"] )
        {
            [appDelegate.hud hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [appDelegate.hud release];  appDelegate.hud = nil;
            [self removeObserver:self forKeyPath:@"dataManager.progress"];
            [self removeObserver:self forKeyPath:@"dataManager.cleanedUp"];
            [self removeObserver:self forKeyPath:@"dataManager.downHUD"];
        }
    }* /
    
    
    if( [keyPath isEqualToString:@"progress"] )
    {
        //  if the data manager updates progress, update our HUD
        appDelegate..progress = self.progress;
        if( self.progress == 0.0 )
            //  no progress; we're just connecting
            appDelegate.hud.labelText = NSLocalizedString(@"Connecting", "");
        else if( self.progress < 1.0 )
        {
            //  progress >0.0 and < 1.0; we're downloading
            appDelegate.hud.labelText = NSLocalizedString(@"Downloading", "");
            NSString *percent = [NSString stringWithFormat:@"%.0f%%", appDelegate.hud.progress/1*100];
            appDelegate.hud.detailsLabelText = percent;
        }
        else
        {
            / *  progress == 1.0, but we haven't cleaned up, so unpacking
            if( [[[self dataManager] cleanedUp] isEqualToString:@"No"] )
            {
                appDelegate.hud.labelText = NSLocalizedString(@"Unpacking","");
                appDelegate.hud..detailLabelsText = @" ";
            }* /
            
        }
    }*/
}


- (NSString *)mediaTypeName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self.mediaType isEqualToString:@"image"]) {
        return NSLocalizedString(@"Image", @"");
    } else if ([self.mediaType isEqualToString:@"video"]) {
        return NSLocalizedString(@"Video", @"");
    } else {
        return self.mediaType;
    }
}



/*
 - (void)setImage:(UIImage *)image withRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIImage *newImage = [image croppedImageWithRect:rect];
    
    NSLog(@"||||||||||||||>     8-1-1");
    
    newImage = [newImage imageByScalingProportionallyToSize:CGSizeMake(320.0f, 320.0f)];
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.90);
	UIImage *imageThumbnail = [newImage thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
	self.creationDate = [NSDate date];
	self.filename = filename;
	self.localURL = filepath;
	self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
	self.mediaType = @"image";
	self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
	self.width = [NSNumber numberWithInt:image.size.width];
    
	self.height = [NSNumber numberWithInt:image.size.height];
}*/

- (void)setImage:(UIImage *)image withSize:(CGSize)imageSize  {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGFloat resizeScale = (image.size.width / imageSize.width);
    
    NSLog(@"||||||||||||||>     1");
    
    CGSize size = image.size;
    
    NSLog(@"||||||||||||||>     2");
    
    //CGSize reSize = CGSizeMake(self.cropOverlaySize.width * resizeScale, self.cropOverlaySize.height * resizeScale);
    
    CGSize cropSize = CGSizeMake(imageSize.width * resizeScale, imageSize.height * resizeScale);
    
    NSLog(@"||||||||||||||>     3");
    
    CGFloat scalex = cropSize.width / size.width;
    CGFloat scaley = cropSize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    NSLog(@"||||||||||||||>     4");
    
    NSLog(@"||||||||||||||>     5");
    
    CGFloat width = size.width * scalex;
    CGFloat height = size.height * scaley;
    
    NSLog(@"||||||||||||||>     6");
    
    CGFloat originX = ((cropSize.width - width) / 2.0f);
    CGFloat originY = ((cropSize.height - height) / 2.0f) + ([PhotoponNewPhotoponUtility photoponCropFrameOffset] * resizeScale);
    
    NSLog(@"||||||||||||||>     7");
    
    CGRect rect = CGRectMake(originX, originY, size.width * scalex, size.height * scaley);
    
    image = [image croppedImageWithRect:rect];
    
    NSLog(@"||||||||||||||>     8-1-1");
    
    image = [image imageByScalingProportionallyToSize:CGSizeMake(320.0f, 320.0f)];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.90);
	UIImage *imageThumbnail = [image thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
	self.creationDate = [NSDate date];
	self.filename = filename;
	self.localURL = filepath;
	self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
	self.mediaType = @"image";
	self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
	self.width = [NSNumber numberWithInt:image.size.width];
    
	self.height = [NSNumber numberWithInt:image.size.height];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.filename forKey:kPhotoponMediaAttributesNewPhotoponLocalImageFileNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.localURL forKey:kPhotoponMediaAttributesNewPhotoponLocalImageFilePathKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage object:nil userInfo:nil];
}

- (void)setRawImage:(UIImage *)image {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.90);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@-raw.jpg", [formatter stringFromDate:[NSDate date]]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
    self.filenameRaw = filename;
    self.localURLRaw = filepath;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
