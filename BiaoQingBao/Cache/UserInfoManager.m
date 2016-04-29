//
//  UserInfoManager.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+(instancetype)shareInstance
{
    static UserInfoManager* shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[UserInfoManager alloc]init];
    });
    return shareManager;
}

@end
