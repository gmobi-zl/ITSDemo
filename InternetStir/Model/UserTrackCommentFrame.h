//
//  UserTrackCommentFrame.h
//  Jacob
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserTrackComment.h"

@interface UserTrackCommentFrame : NSObject
@property (nonatomic, assign) CGRect userIconF;
@property (nonatomic, assign) CGRect userNameF;
@property (nonatomic, assign) CGRect userCommentF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect replyBtnF;

@property (nonatomic, assign) CGRect lineF;
@property (nonatomic, assign) CGRect articleF;
@property (nonatomic, assign) CGRect photoF;
@property (nonatomic, assign) CGRect articleBgF;

@property (nonatomic, strong) NSMutableArray *replysF;
@property (nonatomic, strong) NSMutableArray *replyIconF;
@property (nonatomic, strong) NSMutableArray *replyNameF;
@property (nonatomic, strong) NSMutableArray *replyCommentF;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) CGRect replyIcon;
@property (nonatomic, assign) CGRect replyName;

@end
