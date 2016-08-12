//
//  GRImageHolder.h
//  Go2Reach SDK
//
//  Created by zl on 15/10/22.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRImageHolder_h
#define momock_GRImageHolder_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GRIMAGE_PREFIX_HTTP @"http://"
#define GRIMAGE_PREFIX_HTTPS @"https://"
#define GRIMAGE_PREFIX_FILE @"file://"
#define GRIMAGE_PREFIX_RES @"res://"

#define GRIMAGE_GIF_IMAGES @"gif_images"
#define GRIMAGE_GIF_TIMES @"gif_times"
#define GRIMAGE_GIF_TOTALTIME @"gif_totaltime"

@protocol GRImageHolderDelegate <NSObject>

-(void) imageLoaded: (NSString*) uri
            uiImage: (UIImage*) uiImage;

@end

@interface GRImageHolder : NSObject

@property BOOL isDownloading;
@property NSString* imageUri;
@property id<GRImageHolderDelegate> loadedDelegate;

+(GRImageHolder*) get: (NSString*) uri
        expectedWidth: (int) expectedWidth
       expectedHeight: (int) expectedHeight;

-(BOOL) isLoaded;
-(UIImage*) getAsUIImage;
-(BOOL) isGIFImage;
-(NSMutableDictionary*) getGifDatas;
-(NSString*) getCacheFilePath;

@end

#endif /* GRImageHolder_h */
