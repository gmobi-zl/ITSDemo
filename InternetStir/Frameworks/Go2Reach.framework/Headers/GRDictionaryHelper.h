//
//  GRDictionaryHelper.h
//  Go2Reach SDK
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRDictionaryHelper_h
#define momock_GRDictionaryHelper_h

#import <Foundation/Foundation.h>

@interface GRDictionaryHelper : NSObject

+(id) select: (NSMutableDictionary*) node
        path: (NSString*) path
         def: (id) def;

+(NSString*) selectString: (NSMutableDictionary*) node
                     path: (NSString*) path
                      def: (NSString*) def;

+(NSNumber*) selectNumber: (NSMutableDictionary*) node
                     path: (NSString*) path
                      def: (NSNumber*) def;

+(NSInteger) selectInteger: (NSMutableDictionary*) node
                      path: (NSString*) path
                       def: (NSInteger) def;

@end

#endif
