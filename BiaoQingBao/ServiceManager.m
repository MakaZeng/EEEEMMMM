//
//  ServiceManager.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/17.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ServiceManager.h"
#import <SCLAlertView.h>
#import <AFNetworking/AFNetworking.h>

@implementation ServiceManager

+(void)showNeedRate
{
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"Send", ^{ /*work here*/ });
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Warning)
    .title(@"Title")
    .subTitle(@"Subtitle")
    .duration(0);
    [showBuilder showAlertView:builder.alertView onViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    // or even
    showBuilder.show(builder.alertView, [UIApplication sharedApplication].keyWindow.rootViewController);
}

+(void)queryRssWithDic:(NSDictionary *)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:SERVICE_RSS_HOST parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

+(void)querySettingWithDic:(NSDictionary *)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:SERVICE_SETTING_HOST parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

+(void)queryIndexListWithDic:(NSDictionary *)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:SERVICE_INDEXLIST_HOST parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

+(void)searchEmothionWithDic:(NSDictionary *)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    
    [manager POST:SERVICE_SEARCH_HOST parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

+(void)queryBrowserPageCongfigWithDic:(NSDictionary*)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    
    NSString* string = SERVICE_QUERY_BROWSER;
    
    [manager POST:string parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(nil);
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}


+(void)searchEmothionZipWithDic:(NSDictionary *)dic callBack:(ServiceManagerCallback)callback
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    
    NSString* string = SERVICE_EMOTIONZIP_SEARCH;
    
    [manager POST:string parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback(arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
