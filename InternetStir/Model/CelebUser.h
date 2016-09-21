//
//  PopoUser.h
//  PoPoNews
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CelebThirdUser : NSObject

@property (nonatomic, copy) NSString *openid;//第三方唯一标示
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *type;

@end

@interface CelebUser : NSObject

@property (assign) BOOL isCBADM;

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *email;

//@property (nonatomic, copy) NSString *openid;//第三方唯一标示
//@property (nonatomic, copy) NSString *email;
//@property (nonatomic, copy) NSString *gender;//性别
//@property (nonatomic, copy) NSString *link;
//@property (nonatomic, copy) NSString *locale;//地区

//@property (copy) NSString *type;

@property (assign) BOOL isLogin;
//@property (assign) int loginType;
@property (nonatomic, strong) NSMutableArray *primary;

- (void) initWithData;
- (BOOL) isBindThirdAccount:(NSString*) type;
- (CelebThirdUser*) getBindThirdAccount:(NSString*) type;
- (void) resetData;

@end
