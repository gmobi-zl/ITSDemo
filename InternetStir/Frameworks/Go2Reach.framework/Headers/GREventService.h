//
//  SDEventService.h
//  MediatekSmartDevice
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Gmobi. All rights reserved.
//

#ifndef momock_GREventService_h
#define momock_GREventService_h

#import <Foundation/Foundation.h>

@interface GRIEventItem : NSObject{
    id target;
    NSString *event;
    SEL selector;
}

@property id target;
@property NSString *event;
@property SEL selector;

-(void)setData: (id) tg
     eventName: (NSString*) e
   selectorHdl: (SEL) h;

@end

@interface GREventService : NSObject{
    NSMutableArray *eventList;
}

@property NSMutableArray *eventList;

+(GREventService*) getInstance;

-(void)send: (NSString*) event
  eventData: (id) data;

-(void)addEventHandler: (id) tg
             eventName: (NSString*) event
              selector: (SEL)handler;

-(void)removeEventHandler: (NSString*) event;

@end

#endif
