//
//  GRAdAudience.h
//  Go2ReachSample
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRAdAudience_h
#define Go2Reach_GRAdAudience_h

#import <Foundation/Foundation.h>

typedef enum{
    Male = 0,
    Female
}GRGender;

@interface GRAdAudience : NSObject

@property GRGender gender;
@property int age;
@property NSMutableDictionary* tags;

-(NSDictionary*) toDictionary;

-(void) setTag: (NSString*) key
         value: (id) val;

@end

#endif
