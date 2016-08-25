//
//  FacebookService.h
//  InternetStir
//
//  Created by Apple on 16/8/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define ITS_FB_LOGIN_SUCCESS 0
#define ITS_FB_LOGIN_ERROR 1
#define ITS_FB_LOGIN_CANCEL 2

typedef void (^PoPoFBLoginCallback)(int resultCode);

@interface FacebookService : NSObject
@property (copy) NSString *userName;
@property (copy) NSString *icon;
@property (copy) NSString *uId;
@property (nonatomic, strong) FBSDKLoginManager *login;
-(void) facebookLogin:(PoPoFBLoginCallback) cb
       viewController:(UIViewController *)view;
-(void) facebookUserInfo;
-(void) facebookLogOut;
@end
