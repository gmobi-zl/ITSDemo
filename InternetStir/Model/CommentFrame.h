//
//  DetailCommentFrame.h
//  InternetStir
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentItem.h"
@interface CommentFrame : NSObject
//@property (nonatomic, strong) ReplyItem *item;
@property (nonatomic, strong) CommentItem *detailCommentItem;
@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect lineF;
//@property (nonatomic, assign) CGRect photoF;
@property (nonatomic, assign) CGRect contentF;
@property (nonatomic, assign) CGRect replyF;
@property (nonatomic, strong) NSMutableArray *replysF;
@property (nonatomic, strong) NSMutableArray *replyPictureF;
@property (nonatomic, strong) NSMutableArray *replyNameF;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) CGRect replyBackgroundF;
@property (nonatomic, assign) CGRect replyIcon;
@property (nonatomic, assign) CGRect replyName;

@property (nonatomic, assign) CGRect timeF;
@end
