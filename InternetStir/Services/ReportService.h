//
//  ReportService.h
//  PoPoNews
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_ReportService_h
#define PoPoNews_ReportService_h

#import <Foundation/Foundation.h>
#import "MMJsonDatabase.h"
/**
 * 报告消息发送服务
 */
@interface ReportService : NSObject

@property NSMutableArray* sendingDataIds; //发送中的数据id
@property NSThread* reportService;
@property BOOL isSending;

@property Collection* reportCol;

-(void) initService;

-(void) startReportService;

-(void) recordEmo: (NSString*) nId
          emoType: (NSString*) emo;

-(void) recordFav: (NSString*) nId
              fav: (int) favData;

-(void) recordFeedback: (NSString*) msg;

-(void) recordCrash: (NSString*) stack
                msg: (NSString*) errMsg
             device: (NSString*) deviceInfo;

-(void) recordPV: (NSString*) nId;
-(void) recordPushMsgReceived: (NSString*) nId;
-(void) recordPushMsgClicked: (NSString*) nId;

-(void) recordCategory: (NSString*) cId;

-(void) recordEvent: (NSString*) eventId
             params: (NSDictionary*) params
      eventCategory: (NSString*) category;

-(void) recordEvent: (NSString*) eventId
             params: (NSDictionary*) params
              timed: (BOOL) timed
      eventCategory: (NSString*) category;

-(void) recordEndTimedEvent: (NSString*) eventId
               params: (NSDictionary*) params;

-(void) recordAdPurchase: (NSString*) placement
                    type: (NSString*) type;

@end



#endif
