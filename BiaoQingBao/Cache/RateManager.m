//
//  RateManager.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/28.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "UserInfoManager.h"
#import "RateManager.h"
#import <SIAlertView.h>

@implementation RateManager

+(void)showRateView
{
    NSString* str =  [[NSUserDefaults standardUserDefaults] objectForKey:MAKA_UserDefault_RatedKey];
    if (!str) {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:MAKA_UserDefault_RatedDictionaryKey];
        if (dic) {
            NSString* title = NSDictionary_String_ForKey(dic, @"title");
            NSString* subTitle = NSDictionary_String_ForKey(dic, @"subTitle");
            if (subTitle.length == 0) {
                subTitle = NSLocalizedString(@"五星好评解锁所有功能，做最好用的免费表情软件。", @"五星好评解锁所有功能，做最好用的免费表情软件。");
            }
            NSString* url = NSDictionary_String_ForKey(dic, @"url");
            if (url.length > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:subTitle];
                    
                    [alertView addButtonWithTitle:NSLocalizedString(@"去好评", @"去好评")
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert) {
                                              [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MAKA_UserDefault_RatedDictionaryKey];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                          }];
                    [alertView addButtonWithTitle:NSLocalizedString(@"下次", @"下次")
                                             type:SIAlertViewButtonTypeDefault
                                          handler:^(SIAlertView *alert) {
                                              
                                          }];
                    
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    
                    [alertView show];

                });
            }
        }
    }
}

@end
