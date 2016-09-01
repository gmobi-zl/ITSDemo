//
//  CBUserService.h
//  InternetStir
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef CBUserService_h
#define CBUserService_h

#import <Foundation/Foundation.h>
#import "CelebUser.h"

@interface CBUserService : NSObject

@property (retain) CelebUser *user;


//user
-(void) initUser;


@end


#endif /* CBUserService_h */
