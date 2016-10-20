//
//  FacebookService.m
//  InternetStir
//
//  Created by Apple on 16/8/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "FacebookService.h"
#import "MMLogger.h"
#import "SettingService.h"
#import "ITSApplication.h"
#import "ConfigService.h"
#import "ITSAppConst.h"

@implementation FacebookService


-(void) facebookUserInfo{
    
#ifdef TEST_CELEB_LOGIN
    /* 
     {
     "success": true,
     "profile": {
     "name": "Tomoto Lai",
     "uuid": "017d8be4-8d03-4722-ae8e-6500c086f2ec",
     "session": "0d1c1f77-afcd-4354-a0a8-750142d9dd23",
     "acl": {
     "role": "celeb",
     "object": null
     }
     }
     }
     */
    
    self.userName = @"Tomoto Lai";
    self.uId = @"017d8be4-8d03-4722-ae8e-6500c086f2ec";
    self.icon = @"https://scontent-tpe1-1.xx.fbcdn.net/v/t1.0-1/p160x160/12938287_972142962863863_37536436875128892_n.jpg?oh=0501feabb5712a2951a9baeb4522c1a1&oe=58607417";
    self.email = @"tomoto.app@gmail.com";

    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    us.user.userName = self.userName;
    us.user.avatar = self.icon;
    us.user.email = self.email;
    us.user.session = @"85a8b3fb-fb49-4fa2-ba41-7053c8f04314";
    us.user.uId = self.uId;
    
    us.user.isCBADM = YES;
    us.user.role = CELEB_USER_CELEB;
    us.user.isLogin = YES;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:self.uId forKey:@"openid"];
    [dic setObject:@"facebook" forKey:@"type"];
    [dic setObject:us.user.userName forKey:@"name"];
    [dic setObject:us.user.avatar forKey:@"avatar"];
    [dic setObject:us.user.email forKey:@"email"];
    [dic setObject:us.user.uId forKey:@"uuid"];
    [dic setObject:us.user.session forKey:@"session"];
    [dic setObject:[[NSNumber alloc] initWithBool:us.user.isLogin] forKey:@"isLogin"];
    [dic setObject:[[NSNumber alloc] initWithInteger:us.user.role] forKey:@"role"];
    
    SettingService* ss = [SettingService get];
    [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
    if ([self.delegate respondsToSelector:@selector(passMessage)]) {
        [self.delegate passMessage];
    }
#else
    if ([FBSDKAccessToken currentAccessToken]){
        
        ITSApplication* itsApp = [ITSApplication get];
        CBUserService* us = itsApp.cbUserSvr;
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
        [params setValue:@"id,name,first_name,age_range,link,gender,locale,picture,timezone,updated_time,verified,email" forKey:@"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (error == nil){
                MMLogDebug(@"FB user info:  %@", result);
                self.userName = [result objectForKey:@"name"];
                self.uId = [result objectForKey:@"id"];
                self.icon = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                self.email = [result objectForKey:@"email"];
                
                ITSApplication* poApp = [ITSApplication get];
                NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
                [eParams setObject:self.uId forKey:@"userId"];
                [poApp.reportSvr recordEvent:@"ok" params:eParams eventCategory:@"login.click"];
                
                [itsApp.remoteSvr doLogin:self.email uid:self.uId name:self.userName
                                   avator:self.icon accessToken:[self getToken] type:1 callback:^(int status, int code, NSDictionary *resultData) {
                                       if (resultData != nil){
                                           NSDictionary* profile = [resultData objectForKey:@"profile"];
                                           if (profile != nil){
                                               NSString* name = [profile objectForKey:@"name"];
                                               NSString* email = [profile objectForKey:@"email"];
                                               NSString* avator = [profile objectForKey:@"avatar"];
                                               NSString* session = [profile objectForKey:@"session"];
                                               NSString* uuid = [profile objectForKey:@"uuid"];
                                               NSDictionary* acl = [profile objectForKey:@"acl"];
                                               
                                               
                                               NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                                               
                                               if (name != nil)
                                                   us.user.userName = name;
                                               else
                                                   us.user.userName = self.userName;
                                               
                                               if (avator != nil)
                                                   us.user.avatar = avator;
                                               else
                                                   us.user.avatar = self.icon;
                                               
                                               if (email != nil)
                                                   us.user.email = email;
                                               else
                                                   us.user.email = self.email;
                                               
                                               if (session != nil)
                                                   us.user.session = session;
                                               
                                               if (uuid != nil)
                                                   us.user.uId = uuid;
                                               else
                                                   us.user.uId = self.uId;
                                               
                                               ConfigService* cs = [ConfigService get];
                                               NSString* ch = [cs getChannel];
                                               us.user.isCBADM = NO;
                                               
                                               if (acl != nil){
                                                   NSString* role = [acl objectForKey:@"role"];
                                                   if (role != nil){
                                                       if ([role isEqualToString:@"celeb"]){
                                                           us.user.isCBADM = YES;
                                                           us.user.role = CELEB_USER_CELEB;
                                                       } else if ([role isEqualToString:@"admin"]){
                                                           us.user.role = CELEB_USER_ADMIN;
                                                       } else if ([role isEqualToString:@"user"]){
                                                           us.user.role = CELEB_USER_NORMAL;
                                                       }
                                                   }
                                                   
                                                   //                                id vipObj = [acl objectForKey:@"object"];
                                                   //                                if (vipObj != nil)
                                                   //                                    us.user.role = CELEB_USER_VIP;
                                                   
                                               }
                                               
                                               //                            if ([uuid isEqualToString:ch]){
                                               //                                us.user.isCBADM = YES;
                                               //                            } else {
                                               //                                us.user.isCBADM = NO;
                                               //                            }
                                               
                                               //us.user.isCBADM = YES;
                                               us.user.isLogin = YES;
                                               
                                               [dic setObject:self.uId forKey:@"openid"];
                                               [dic setObject:@"facebook" forKey:@"type"];
                                               [dic setObject:us.user.userName forKey:@"name"];
                                               [dic setObject:us.user.avatar forKey:@"avatar"];
                                               [dic setObject:us.user.email forKey:@"email"];
                                               [dic setObject:us.user.uId forKey:@"uuid"];
                                               [dic setObject:us.user.session forKey:@"session"];
                                               [dic setObject:[[NSNumber alloc] initWithBool:us.user.isLogin] forKey:@"isLogin"];
                                               [dic setObject:[[NSNumber alloc] initWithInt:us.user.role] forKey:@"role"];

                                               SettingService* ss = [SettingService get];
                                               [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
                                               if ([self.delegate respondsToSelector:@selector(passMessage)]) {
                                                   [self.delegate passMessage];
                                               }
                                           }
                                       }
                                   }];
                
            }
        }];
    }
#endif
}

-(void) facebookLogOut{
    
    [self.login logOut];
}

-(NSString*) getToken{
    FBSDKAccessToken* fbToken = [FBSDKAccessToken currentAccessToken];
    if (fbToken != nil){
        return fbToken.tokenString;
    }
    return @"";
}

-(void) facebookLogin:(PoPoFBLoginCallback) cb viewController:(UIViewController *)view{
    
#ifdef TEST_CELEB_LOGIN
    cb(ITS_FB_LOGIN_SUCCESS);
#else
    if ([FBSDKAccessToken currentAccessToken]){
        cb(ITS_FB_LOGIN_SUCCESS);
        return;
    }
    
    self.login = [[FBSDKLoginManager alloc] init];
    //@"public_profile", @"email", @"user_friends", @"user_likes", @"user_posts"
    [self.login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:view handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        MMLogDebug(@"FB login rsp:  %@", result);
        if (error){
            // process error
            cb(ITS_FB_LOGIN_ERROR);
        } else if (result.isCancelled){
            // handle cancellations
            cb(ITS_FB_LOGIN_CANCEL);
        } else {
            // login success
            cb(ITS_FB_LOGIN_SUCCESS);
        }
    }];
#endif
}
@end
