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
        ITSApplication* poApp = [ITSApplication get];
        //        DataService* ds = poApp.dataSvr;
        
        //@{@"fields": @"id,name,first_name,age_range,link,gender,locale,picture,timezone,update_time,verified"}
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
        [params setValue:@"id,name,first_name,age_range,link,gender,locale,picture,timezone,updated_time,verified,email" forKey:@"fields"];
        
        //@{@"fields": }   @"id,name,first_name,age_range,link,gender,locale,picture,timezone,update_time,verified"
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (error == nil){
                MMLogDebug(@"FB user info:  %@", result);
                self.userName = [result objectForKey:@"name"];
                self.uId = [result objectForKey:@"id"];
                self.icon = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                self.email = [result objectForKey:@"email"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getFacebookUserInfo" object:self];
                
                SettingService* ss = [SettingService get];
                [ss setDictoryValue:POPO_FB_USER_INFO data:result];
            }
        }];
    }
}
-(void) facebookLogOut{
    
    [self.login logOut];
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
