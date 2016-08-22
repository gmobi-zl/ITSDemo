//
//  ReplyItem.h
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) int type;
//@property (strong,nonatomic)NSMutableArray *replys;   //评论
@end
