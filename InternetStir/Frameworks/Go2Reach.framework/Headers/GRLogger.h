//
//  Logger.h
//  momock
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//


#ifndef momock_GRLogger_h
#define momock_GRLogger_h

#import <Foundation/Foundation.h>

#define GR_LOG_LEVEL_DEBUG @"Debug"
#define GR_LOG_LEVEL_INFO @"Info"
#define GR_LOG_LEVEL_WARN @"Warn"
#define GR_LOG_LEVEL_ERROR @"Error"

#define GR_LOG_I_LEVEL_ALL     0
#define GR_LOG_I_LEVEL_DEBUG   3
#define GR_LOG_I_LEVEL_INFO    4
#define GR_LOG_I_LEVEL_WARN    5
#define GR_LOG_I_LEVEL_ERROR   6
#define GR_LOG_I_LEVEL_NONE    7


#define GRLogDebug(format,...) grwriteLog(__FILE__,__LINE__,__FUNCTION__,GR_LOG_LEVEL_DEBUG, GR_LOG_I_LEVEL_DEBUG,format,##__VA_ARGS__);
#define GRLogInfo(format,...) grwriteLog(__FILE__,__LINE__,__FUNCTION__,GR_LOG_LEVEL_INFO, GR_LOG_I_LEVEL_INFO,format,##__VA_ARGS__);
#define GRLogWarn(format,...) grwriteLog(__FILE__,__LINE__,__FUNCTION__,GR_LOG_LEVEL_WARN,GR_LOG_I_LEVEL_WARN,format,##__VA_ARGS__);
#define GRLogError(format,...) grwriteLog(__FILE__,__LINE__,__FUNCTION__,GR_LOG_LEVEL_ERROR,GR_LOG_I_LEVEL_ERROR,format,##__VA_ARGS__);


@interface GRLogger : NSObject{
    BOOL debug;
    NSFileHandle *logFileHdl;
    NSMutableData *writerBuf;
    int level;
    NSString *logName;
    NSString *appName;
}

+(void)openLog: (NSString*) file
      logLevel: (int) plevel
   maxLogCount: (int) maxLogFile;

@property BOOL debug;
@property NSFileHandle *logFileHdl;
@property NSMutableData *writerBuf;
@property int level;
@property NSString* logName;
@property NSString* appName;

void grwriteLog(const char* file, int line,const char* func, NSString* slevel, int ilevel ,NSString* fmt, ...);

@end

#endif
