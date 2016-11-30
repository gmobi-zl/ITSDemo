//
//  TwitterService.h
//  InternetStir
//
//  Created by Apple on 16/8/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#define ITS_TW_LOGIN_SUCCESS 0
#define ITS_TW_LOGIN_ERROR 1
#define ITS_TW_LOGIN_CANCEL 2

typedef void (^PoPoTWLoginCallback)(int resultCode);

@interface TwitterService : NSObject

@property (nonatomic) TWTRAPIClient *APIClient;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, strong) ACAccountStore *accountStore;

- (void)systemAccountTypeIdentifier;
-(void) getUserInfo;
-(void) twitterLogin:(PoPoTWLoginCallback) cb;
@end
