//
//  GRDownloadService.h
//  PoPoNews
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRDownloadService_h
#define momock_GRDownloadService_h

#import <Foundation/Foundation.h>
#import "GRHttpSession.h"


#define GR_DOWNLOAD_FAILED  0
#define GR_DOWNLOAD_SUCCESS 1

#define GR_MAX_DOWNLOADING_ITEM 30

#define GR_SERVICE_STATUS_INIT 0
#define GR_SERVICE_STATUS_RUNNING 1
#define GR_SERVICE_STATUS_PAUSE 2
#define GR_SERVICE_STATUS_STOP 3

#define GR_DOWNLOAD_SERVICE_STATUS_WAITING 0
#define GR_DOWNLOAD_SERVICE_STATUS_DOWNLOADING 1
#define GR_DOWNLOAD_SERVICE_STATUS_FINISH_SUCC 2
#define GR_DOWNLOAD_SERVICE_STATUS_FINISH_FAIL 3

typedef void (^GRDownloadCallback)(int status, NSDictionary* resultData);
typedef void (^GRDownloadProgressCallback)(double progress);

@interface GRDownloadItem : NSObject

@property (retain) GRHttpSession* session;
@property (copy) NSString* url;
@property (copy) NSMutableDictionary* header;
@property (copy) NSString* localUri;
@property (strong) GRDownloadCallback callback;
@property (strong) GRDownloadProgressCallback cbProgress;
@property (assign) BOOL wifiOnly;
@property (assign) int status;

@end

@interface GRDownloadService : NSObject

@property NSMutableArray* downloadingList;
@property NSMutableArray* waitingList;
@property BOOL isDownloadRunning;
@property int serviceStatus;

+(GRDownloadService*) getInstance;

-(void) stopService;
-(void) startService;
-(void) pauseService;

-(void) download: (GRDownloadItem*) item;

-(void) download: (NSString*) url
            reqHeader: (NSMutableDictionary*) header
             filePath: (NSString*) file
             wifiOnly: (BOOL) wifi
             callback: (GRDownloadCallback) cb
     progressCallback: (GRDownloadProgressCallback) proCb;

@end

#endif
