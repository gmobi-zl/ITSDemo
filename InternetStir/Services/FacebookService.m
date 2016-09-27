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

@implementation FacebookService


-(void) facebookUserInfo{
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
                
                us.user.userName = self.userName;
                us.user.avatar = self.icon;
                us.user.email = self.email;
                us.user.isLogin = YES;
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"facebook",@"type",
                                     self.uId,@"openid",
                                     self.userName ,@"name",
                                     self.icon,@"avatar",
                                     self.email,@"email",
                                     [[NSNumber alloc] initWithBool:us.user.isLogin],@"isLogin",
                                     nil];
                
                [itsApp.remoteSvr doLogin:self.email uid:self.uId accessToken:[self getToken] type:1];
                
                SettingService* ss = [SettingService get];
                [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
                if ([self.delegate respondsToSelector:@selector(passMessage)]) {
                    [self.delegate passMessage];
                }
            }
        }];
    }
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
    if ([FBSDKAccessToken currentAccessToken]){
        cb(ITS_FB_LOGIN_SUCCESS);
        return;
    }
    
    self.login = [[FBSDKLoginManager alloc] init];
    [self.login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_likes", @"user_posts"] fromViewController:view handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
}
@end
