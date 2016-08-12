//
//  GRSettingsService.h
//  Go2Reach
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRSettingsService_h
#define Go2Reach_GRSettingsService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GRJsonDatabase.h"

@interface GRSettingsService: NSObject

@property GRCollection* col;

-(GRSettingsService*) initSettings;

-(void) setStringValue: (NSString*) key
                 data : (NSString*) value;
-(NSString*) getStringValue: (NSString*) key
                   defValue: (NSString*) def;

-(void) setBooleanValue: (NSString*) key
                   data: (BOOL) value;
-(BOOL) getBooleanValue: (NSString*) key
               defValue: (BOOL) def;

-(void) setIntValue: (NSString*) key
               data: (int) value;
-(int) getIntValue: (NSString*) key
          defValue: (int) def;

-(void) setLongValue: (NSString*) key
               data: (long) value;
-(long) getLongValue: (NSString*) key
          defValue: (long) def;

-(void) setFloatValue: (NSString*) key
                 data: (float) value;
-(float) getFloatValue: (NSString*) key
              defValue: (float) def;


-(void) setDictoryValue: (NSString*) key
                   data: (NSDictionary*) value;
-(NSDictionary*) getDictoryValue: (NSString*) key
                        defValue: (NSDictionary*) def;

-(void) setArrayValue: (NSString*) key
                 data: (NSArray*) value;
-(NSArray*) getArrayValue: (NSString*) key
                 defValue: (NSArray*) def;

@end

#endif
