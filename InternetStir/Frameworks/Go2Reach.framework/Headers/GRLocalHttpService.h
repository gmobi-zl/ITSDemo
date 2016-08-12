//
//  GRLocalHttpService.h
//  Go2ReachSample
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef GRLocalHttpService_h
#define GRLocalHttpService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HTTPServer.h"

typedef void (^CacheFileBlock)(NSString* fileUri);

@interface GRLocalHttpService : NSObject

-(void) initService;

-(void) stop;
-(void) start;

-(NSString*) getLocalFileURI: (NSString*) url;

-(void) getLocalCacheFile: (NSString*) url
                 callback: (CacheFileBlock) callback;

@end


#endif /* GRLocalHttpService_h */
