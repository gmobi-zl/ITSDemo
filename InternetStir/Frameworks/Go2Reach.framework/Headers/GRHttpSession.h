//
//  CMHttpSession.h
//  momock
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRHttpSession_h
#define momock_GRHttpSession_h

#import <Foundation/Foundation.h>

#define GR_HTTP_STATE_WAITING 0
#define GR_HTTP_STATE_STARTED 1
#define GR_HTTP_STATE_HEADER_RECEIVED 2
#define GR_HTTP_STATE_CONTENT_RECEIVING 3
#define GR_HTTP_STATE_CONTENT_RECEIVED 4
#define GR_HTTP_STATE_ERROR 5
#define GR_HTTP_STATE_FINISHED 6

#define GR_HTTP_RESULT_DATA @"data"
#define GR_HTTP_RESULT_ERROR @"error"
#define GR_HTTP_RESULT_DOWNLOAD_URL @"url"

#define GR_HTTP_STATUS_ERROR 800

typedef void (^GRHttpSessionCallback)(int status, int code, NSDictionary* resultData);
typedef void (^GRHttpSessionProgressCallback)(NSString* url, double progress);

@interface GRHttpSession: NSObject <NSURLSessionDelegate>{
    NSURLSession* session;
    NSMutableDictionary *reqHeader;
    NSDictionary* rspHeader;
    NSURL* reqUrl;
    NSMutableURLRequest* request;
    NSURLSessionDataTask* mmDataTask;
    NSURLSessionDownloadTask* mmDownloadTask;
    NSURLSessionUploadTask* mmUploadTask;
    int mmStatus;
}

@property (retain) NSURLSession* session;
@property (retain) NSMutableDictionary* reqHeader;
@property (retain) NSDictionary* rspHeader;
@property (retain) NSURL* reqUrl;
@property (retain) NSMutableURLRequest* request;
@property (retain) NSURLSessionDataTask* mmDataTask;
@property (retain) NSURLSessionDownloadTask* mmDownloadTask;
@property (retain) NSURLSessionUploadTask* mmUploadTask;
@property (nonatomic, strong) GRHttpSessionCallback mmCallbackHandler;
@property (nonatomic, strong) GRHttpSessionProgressCallback mmProgressCallbackHandler;
@property (assign) int mmStatus;

-(void) doGet: (NSString*) url
    reqHeader: (NSMutableDictionary*) header
     callback: (GRHttpSessionCallback) cb;

-(void) doGet: (NSString*) url
    reqHeader: (NSMutableDictionary*) header
     callback: (GRHttpSessionCallback) cb
       params: (NSMutableDictionary*) params;

-(void) doPost: (NSString*) url
     reqHeader: (NSMutableDictionary*) header
       reqBody: (NSString*) body
      callback: (GRHttpSessionCallback) cb;

-(void) doPostJSON: (NSString*) url
     reqHeader: (NSMutableDictionary*) header
       reqBody: (NSDictionary*) body
      callback: (GRHttpSessionCallback) cb;

-(NSString*) download: (NSString*) url
            reqHeader: (NSMutableDictionary*) header
             filePath: (NSString*) file
             callback: (GRHttpSessionCallback) cb
     progressCallback: (GRHttpSessionProgressCallback) proCb;

@end


#endif
