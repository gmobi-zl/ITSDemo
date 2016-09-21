//
//  DetailCommentItem.h
//  Jacob
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReplyItem.h"

@interface DetailCommentItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *time;
@property (strong,nonatomic)NSMutableArray *replys;
@property (strong,nonatomic)ReplyItem *item;
#pragma mark - 最后要考虑是暂存coredata里还是plist文件里
+(id)familyGroupWithDict:(NSDictionary *)dict;

@end
