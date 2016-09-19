
//
//  DetailCommentItem.m
//  Jacob
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "DetailCommentItem.h"

@implementation DetailCommentItem
-(id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(id)familyGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}


@end
