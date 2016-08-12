//
//  GRImageService.h
//  Go2ReachSample
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRImageService_h
#define GRImageService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GRImageHolder.h"

@interface GRImageService : NSObject <GRImageHolderDelegate>

- (void)bind: (NSString*) url
   imageView: (UIImageView*) image;

- (NSString*)getCacheOf: (NSString*) url;
- (UIImage*)loadBitmap: (NSString*) url;

@end

#endif /* GRImageService_h */
