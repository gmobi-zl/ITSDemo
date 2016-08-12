//
//  PopoNewsData.m
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopoNewsData.h"

@implementation PopoNewsData


-(void) resetTopPhotoIndex{
//    if (self.data != nil){
//        self.topPhotoIndex = -1;
//        int index = 0;
//        for (PoPoNewsItem* item in self.data) {
//            if (item != nil){
//                if ([item.type compare:NEWS_TYPE_IMAGE] == NSOrderedSame){
//                    self.topPhotoIndex = index;
//                    break;
//                }
//            }
//            index++;
//        }
//
//    } else
//        self.topPhotoIndex = -1;
    
    if (self.data != nil){
        self.topPhotoIndex = -1;
        int index = 0;
        for (id items in self.data) {
            if ([items isKindOfClass:[PoPoNewsItem class]]) {
                PoPoNewsItem* item = items;
                if (item != nil){
                    if ([item.type compare:NEWS_TYPE_IMAGE] == NSOrderedSame){
                        self.topPhotoIndex = index;
                        break;
                    }
                }
            }
            index++;
        }
        
    } else
        self.topPhotoIndex = -1;

}


@end