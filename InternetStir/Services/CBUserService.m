//
//  CBUserService.m
//  InternetStir
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBUserService.h"
#import "SettingService.h"
#import "ITSAppConst.h"
#import "ConfigService.h"

@implementation CBUserService

-(void) initUser{
    
    self.user = [[CelebUser alloc] init];
    [self.user initWithData];
    
    // load last login user info;
    SettingService* ss = [SettingService get];
    NSDictionary *data = [ss getDictoryValue:CONFIG_USERLOGIN_INFO defValue:nil];
    if (data == nil){
        self.user.userName = @"";
        self.user.avatar = @"";
        self.user.isLogin = NO;
        self.user.email = @"";
        //        self.user.uId = [MMDictionaryHelper selectString:(NSMutableDictionary*)data path:@"data/user/_id" def:nil];
        //        self.user.avatar = [MMDictionaryHelper selectString:(NSMutableDictionary*)data path:@"data/user/avatar" def:nil];
        //        self.user.userName = [MMDictionaryHelper selectString:(NSMutableDictionary*)data path:@"data/user/name" def:nil];
        //        self.user.email = [MMDictionaryHelper selectString:(NSMutableDictionary*)data path:@"data/user/email" def:nil];
        //
        //        [self.user.primary removeAllObjects];
        //        NSArray* primaryData = [MMDictionaryHelper select:(NSMutableDictionary*)data path:@"data/primary" def:nil];
        //        if (primaryData != nil){
        //            for (int i = 0; i < [primaryData count]; i++) {
        //                NSDictionary* pData = [primaryData objectAtIndex:i];
        //                if (pData != nil){
        //                    PopoThirdUser* u = [PopoThirdUser alloc];
        //                    u.type = [MMDictionaryHelper selectString:(NSMutableDictionary*)pData path:@"type" def:nil];
        //                    u.openid = [MMDictionaryHelper selectString:(NSMutableDictionary*)pData path:@"open_id" def:nil];
        //                    u.email = [MMDictionaryHelper selectString:(NSMutableDictionary*)pData path:@"email" def:nil];
        //                    [self.user.primary addObject:u];
        //                }
        //            }
        //        }
        //
        //        if (self.user.uId != nil)
        //            self.user.isLogin = YES;
    }else{
        
        self.user.avatar = [data objectForKey:@"avatar"];
        self.user.userName = [data objectForKey:@"name"];
        self.user.uId = [data objectForKey:@"uid"];
        self.user.email = [data objectForKey:@"email"];
        self.user.isLogin = [[data objectForKey:@"isLogin"] boolValue];
        self.user.session = [data objectForKey:@"session"];
        self.user.role = [[data objectForKey:@"role"] integerValue];
        
        if (self.user.role == CELEB_USER_CELEB){
            self.user.isCBADM = YES;
        }
        
//        ConfigService* cs = [ConfigService get];
//        NSString* ch = [cs getChannel];
//        if ([self.user.uId isEqualToString:ch]){
//            self.user.isCBADM = YES;
//        } else {
//            self.user.isCBADM = NO;
//        }
    }
}

@end