//
//  DetailCommentItem.h
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReplyItem.h"
@interface CommentItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *comment;
@property (strong,nonatomic)NSMutableArray *replys;
@property (nonatomic, copy) NSString *time;
//@property (strong,nonatomic)NSString *icon;  //头像
//@property (strong,nonatomic)NSString *name;  //昵称
//@property (strong,nonatomic)NSString *shuoshuoText; //说说
//@property (strong,nonatomic)NSString *time;    //发表的时间,存的是nadate，应该要有时间操作
//@property (strong,nonatomic)NSString *pictures;   //发表的图片
//@property (strong,nonatomic)NSMutableArray *replys;   //评论
//@property (strong,nonatomic)NSString *replyIcon;
@property (strong,nonatomic)ReplyItem *item;
#pragma mark - 最后要考虑是暂存coredata里还是plist文件里
+(id)familyGroupWithDict:(NSDictionary *)dict;
@end
