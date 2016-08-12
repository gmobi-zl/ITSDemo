//
//  PopoUser.m
//  PoPoNews
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "PopoUser.h"

@implementation PopoThirdUser

@end

@implementation PopoUser
- (void) initWithData{
    
    self.uId = nil;
    self.isLogin = NO;
    self.userName = @"";
    if (self.primary == nil) {
        self.primary = [NSMutableArray arrayWithCapacity:1];
    }
}

- (BOOL) isBindThirdAccount:(NSString*) type{
    if (self.primary != nil && type != nil){
        for (int i = 0; i < [self.primary count]; i++) {
            PopoThirdUser* tempUser = [self.primary objectAtIndex:i];
            if (tempUser != nil && [tempUser.type isEqualToString:type]){
                return YES;
            }
        }
    }
        
    return NO;
}

- (PopoThirdUser*) getBindThirdAccount:(NSString*) type{
    if (self.primary != nil && type != nil){
        for (int i = 0; i < [self.primary count]; i++) {
            PopoThirdUser* tempUser = [self.primary objectAtIndex:i];
            if (tempUser != nil && [tempUser.type isEqualToString:type]){
                return tempUser;
            }
        }
    }
    
    return nil;
}

- (void) resetData{
    self.isLogin = NO;
    self.userName = @"";
    self.uId = @"";
    self.email = @"";
    self.avatar = @"";
    if (self.primary != nil) {
        [self.primary removeAllObjects];
    }
}

@end
