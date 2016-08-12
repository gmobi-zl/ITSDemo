//
//  GRNativeAd.h
//  Go2ReachSample
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2ReachSample_GRNativeAd_h
#define Go2ReachSample_GRNativeAd_h

#import <Foundation/Foundation.h>
#import "IGRAd.h"
#import "GRAd.h"
#import "GRAdItem.h"
#import "GRImageHolder.h"

@class GRAdItem;
@class GRAdImage;
@class GRAdRichWebView;
@class GRAdService;

// native ad
@interface GRBinder : NSObject

@property NSMutableDictionary* views;
@property NSMutableArray* props;

@end

@interface GRNativeAd : GRAd <IGRAd,GRImageHolderDelegate,UIGestureRecognizerDelegate>

@property int imageWidth;
@property int imageHeight;
@property NSMutableArray* requiredFields;
@property NSMutableArray* items;
@property NSMutableArray* jaItems;
@property NSMutableArray* adTags;
@property NSMutableArray* binders;
//@property NSMutableArray* gifPlayViews;
@property NSMutableDictionary* cachedImageHolders;
@property NSMutableDictionary* cachedGifPlayer;
@property id<GRAdCallbackDelegate> grAdDelegate;
@property UITapGestureRecognizer* adTapEventHdl;
@property BOOL isGifPlay;
@property BOOL videoAutoPlayMode;

-(GRNativeAd*) initNativeAd: (GRAdService*) service
                  placement: (NSString*) placement
                 imageWidth: (int) imageWidth
                imageHeight: (int) imageHeight
                      count: (int) count
             requiredFields: (NSArray*) requiredFields;


-(int) getAdCount;
-(GRAdItem*) getAdItem: (int) index;

-(NSDictionary*) getRawData: (int) index;
-(void) bind: (int) index
       views: (NSMutableDictionary*) views
       props: (NSMutableArray*) props;

-(void) bind: (int) index
   bindviews: (NSMutableDictionary*) bindviews;

-(void) refreshView;
-(void) onRefreshView;
-(void) onClicked: (int) index;
-(void) onLoaded: (int) resultCode;

-(int) getPreferredImageWidth;
-(int) getPreferredImageHeight;

-(NSString*) getType;

-(void) stopAllAnimations;
-(void) setAutoPlayMode: (BOOL) enabled;
-(BOOL) isAutoPlayMode;

@end


#endif
