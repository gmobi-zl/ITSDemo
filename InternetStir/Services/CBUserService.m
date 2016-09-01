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

@implementation CBUserService

-(void) initUser{
    
    self.user = [[CelebUser alloc] init];
    [self.user initWithData];
    
    // load last login user info;
    SettingService* ss = [SettingService get];
    NSDictionary *data = [ss getDictoryValue:CONFIG_USERLOGIN_INFO defValue:nil];
    if (data == nil){
        self.user.userName = @"高圆圆";
        self.user.avatar = @"高圆圆";
        self.user.isLogin = NO;
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
        self.user.uId = [data objectForKey:@"openid"];
        self.user.isLogin = [[data objectForKey:@"isLogin"] boolValue];
    }
}

@end