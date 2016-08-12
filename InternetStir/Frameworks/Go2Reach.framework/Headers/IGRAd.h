//
//  GRIAd.h
//  Go2ReachSample
//
//  Created by apple on 15/10/15.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRIAd_h
#define GRIAd_h

#import <Foundation/Foundation.h>

#define GR_IAD_OK 0
#define GR_IAD_ERR_FAILS_TO_CONNECT -1
#define GR_IAD_ERR_WRONG_RESPONSE -2
#define GR_IAD_ERR_LOGIN_FIRST -3
#define GR_IAD_ERR_SESSION_EXPIRED -101
#define GR_IAD_ERR_OTHERS -1000

#define GR_IAD_SIZE_NONE 0
#define GR_IAD_SIZE_FULL_SCREEN -1

typedef void (^GRICallback)(int resultCode, id resultData);

@protocol GRAdCallbackDelegate <NSObject>

@optional
-(void) GRAdOnLoaded: (id) sender
          resultCode: (int) resultCode
              result: (id) result;
-(void) GRAdOnClicked: (id) sender
           resultCode: (int) resultCode
              result: (id) result;
-(void) GRAdOnRefreshed: (id) sender
             resultCode: (int) resultCode
              result: (id) result;
-(void) GRAdVideoOnPlay: (id) sender
             resultCode: (int) resultCode
                 result: (id) result;
@end

@protocol IGRAd

-(void) setTags: (NSArray*) tags;
-(void) load;
-(BOOL) isLoaded;

@end


#endif /* GRIAd_h */
