//
//  UserInfoManager.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAKA_UserDefault_User_Point @"MAKA_UserDefault_User_Point"
#define MAKA_UserDefault_RatedKey @"MAKA_UserDefault_RatedKey"
#define MAKA_UserDefault_RatedDictionaryKey @"MAKA_UserDefault_RatedDictionaryKey"
#define MAKA_UserDefault_ClickedADS_Dictionary @"MAKA_UserDefault_ClickedADS_Dictionary"

@interface UserInfoManager : NSObject

+(instancetype)shareInstance;

@end
