//
//  GRUserServices.h
//  Go2Reach
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRUserService_h
#define Go2Reach_GRUserService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GRSettingsService.h"
#import "GRDeviceService.h"

typedef void (^GRUserSvrCallback)(int resultCode);

#define GR_USER_OK 0
#define GR_USER_ERR_FAILS_TO_CONNECT -1
#define GR_USER_ERR_WRONG_RESPONSE -2
#define GR_USER_ERR_LOGIN_FIRST -3
#define GR_USER_ERR_LOGIN_AT_LEAST_ONCE_BEFORE -4

#define GR_USER_ERR_SESSION_EXPIRED -101
#define GR_USER_ERR_WRONG_EMAIL_FORMAT -102
#define GR_USER_ERR_DUPLICATED_USERNAME -103
#define GR_USER_ERR_FAILS_TO_UPDATE_PROFILE -104
#define GR_USER_ERR_EMPTY_USERNAME -105
#define GR_USER_ERR_EMPTY_PASSWORD -106
#define GR_USER_ERR_FAILS_TO_AUTO_REGISTER -107
#define GR_USER_ERR_USER_NOT_FOUND -108
#define GR_USER_ERR_WRONG_PASSWORD -109
#define GR_USER_ERR_EMAIL_NOT_SET -110
#define GR_USER_ERR_WRONG_RESET_CODE -111
#define GR_USER_ERR_WRONG_APP_KEY -201
#define GR_USER_ERR_WRONG_PROVIDER -202
#define GR_USER_ERR_OTHERS  -1000


typedef enum {
    GRUserServiceNone = 0,
    GRUserServiceConnecting,
    GRUserServiceConnected,
    GRUserServiceError
} GRUserServiceStatus;

@interface GRUser : NSObject

@property NSMutableDictionary* joUser;
@property NSMutableDictionary* joProfile;

-(GRUser*) initUser: (NSDictionary*) jo;
-(NSString*) getID;
-(NSString*) getUsername;
-(id) getExtra: (NSString*) key
      defValue: (id) defValue;
-(void) setExtra: (NSString*) key
           value: (id) value;
-(void) load: (GRUserSvrCallback) cb;
-(void) save: (GRUserSvrCallback) cb;

@end

@interface GRUserService : NSObject

@property GRSettingsService* grSettings;
@property GRDeviceService* deviceService;
@property NSString* appKey;
@property NSString* appSecret;
@property NSString* server;
@property int status;
@property NSString* sessionId;
@property GRUser* user;

-(void) initUserService: (GRSettingsService*) settings
          deviceservice: (GRDeviceService*) device;

-(NSString*) getServerURI: (NSString*) path;

-(void) login: (NSString*) username
     password: (NSString*) password
     callback: (GRUserSvrCallback) cb;

-(void) login: (GRUserSvrCallback) cb;

-(void) registerUser: (NSString*) username
            password: (NSString*) password
               email: (NSString*) email
               extra: (NSDictionary*) extra
            callback: (GRUserSvrCallback) cb;

-(void) resetPassword: (NSString*) username
            resetCode: (NSString*) resetCode
             password: (NSString*) password
             callback: (GRUserSvrCallback) cb;

-(void) findPassword: (NSString*) username
            callback: (GRUserSvrCallback) cb;

-(void) logout: (GRUserSvrCallback) cb;

@end

#endif
