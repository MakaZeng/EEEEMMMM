//
//  ServiceManager.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/17.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import <Foundation/Foundation.h>

typedef void(^ServiceManagerCallback)(id result);

#define SERVICE_HOST @"http://120.25.198.252/html/index.php?"

#define SERVICE_EMOTIONZIP_SEARCH @"http://120.25.198.252/html/searchEmotionZip.php?"

#define SERVICE_QUERY_BROWSER @"http://120.25.198.252/html/browser.php"

#define SERVICE_INDEXLIST_HOST @"http://120.25.198.252/html/emotionList.php?"

#define SERVICE_RSS_HOST @"http://120.25.198.252/html/rss.php"

#define SERVICE_SETTING_HOST @"http://120.25.198.252/html/setting.php"

#define SERVICE_SEARCH_HOST @"http://120.25.198.252/html/search.php?"

@interface ServiceManager : NSObject

+(void)queryRssWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)querySettingWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)queryIndexListWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)searchEmothionWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)searchEmothionZipWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)queryBrowserPageCongfigWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback;

+(void)showNeedRate;

@end
