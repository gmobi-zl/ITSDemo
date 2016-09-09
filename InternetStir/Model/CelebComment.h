//
//  CelebComment.h
//  InternetStir
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef CelebComment_h
#define CelebComment_h

#import <Foundation/Foundation.h>

@interface CelebComment : NSObject

@property NSString* fid;
@property NSString* ccId;
@property NSString* name;
@property NSString* avator;
@property NSString* context;
@property NSString* image;
@property NSArray* topFansComments;
@property long releaseTime;
@property NSString* pts;
@property NSString* uts;

@end

#endif /* CelebComment_h */
