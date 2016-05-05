//
//  ShareInstance.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ShareInstance.h"
#import <JDStatusBarNotification.h>

@implementation ShareInstance

-(UIView*)adsView
{
    return nil;
}

-(BOOL)shouldShowAds
{
    return YES;
}

+(instancetype)shareInstance
{
    static ShareInstance* i = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        i = [[ShareInstance alloc]init];
    });
    return i;
}

-(NSMutableArray*)myLikeArray
{
    if (_myLikeArray) {
        return _myLikeArray;
    }
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    NSString *homePath  = [Document stringByAppendingPathComponent:@"myLikeArray.archiver"];
    
    _myLikeArray = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    if (!_myLikeArray) {
        _myLikeArray = [NSMutableArray array];
    }
    return _myLikeArray;
}

-(NSMutableArray*)myRssArray
{
    if (_myRssArray) {
        return _myRssArray;
    }
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    NSString *homePath  = [Document stringByAppendingPathComponent:@"myRssArray.archiver"];
    
    _myRssArray = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    if (!_myRssArray) {
        _myRssArray = [NSMutableArray array];
    }
    return _myRssArray;
}

-(NSMutableArray*)webSiteArray
{
    if (_webSiteArray) {
        return _webSiteArray;
    }
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    NSString *homePath  = [Document stringByAppendingPathComponent:@"webSiteArray.archiver"];
    
    _webSiteArray = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    if (!_webSiteArray) {
        _webSiteArray = [NSMutableArray array];
    }
    return _webSiteArray;
}

-(void)save
{
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    NSString *homePath  = [Document stringByAppendingPathComponent:@"myLikeArray.archiver"];
    [NSKeyedArchiver archiveRootObject:_myLikeArray toFile:homePath];
    homePath  = [Document stringByAppendingPathComponent:@"myRssArray.archiver"];
    [NSKeyedArchiver archiveRootObject:_myRssArray toFile:homePath];
    homePath  = [Document stringByAppendingPathComponent:@"webSiteArray.archiver"];
    [NSKeyedArchiver archiveRootObject:_webSiteArray toFile:homePath];
}

+(CGSize)suitSizeForMaxWidth:(CGFloat)maxWidth MaxHeight:(CGFloat)maxHeight WithImage:(UIImage *)image
{
    CGSize size = image.size;
    
    CGFloat scale = size.width/size.height;
    
    if (maxWidth/maxHeight < size.width/size.height) {
        size.width = maxWidth;
        size.height = maxWidth/scale;
    }else {
        size.height = maxHeight;
        size.width = maxHeight*scale;
    }
    
    return size;
}

+(NSString*)mubanFilePath
{
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    return [NSString stringWithFormat:@"%@/muban/",Document];
}


+(NSString*)myCollectionFilePath
{
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    return [NSString stringWithFormat:@"%@/myCollections/",Document];
}

+(void)saveToMubanFolder:(NSData*)image
{
    if ([image isKindOfClass:[NSData class]]) {
        NSFileManager* folder = [NSFileManager defaultManager];
        BOOL isExist = YES;
        isExist = [folder fileExistsAtPath:[self mubanFilePath] isDirectory:(&isExist)];
        if (!isExist) {
            [folder createDirectoryAtPath:[self mubanFilePath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSDate* date = [NSDate date];
        NSString* fileName = [NSString stringWithFormat:@"Image%f",date.timeIntervalSince1970];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",[self mubanFilePath],fileName];
        NSLog(@"%@",filePath);
        [image writeToFile:filePath atomically:YES];
    }
}

+(void)removeFile:(NSString *)path
{
    NSFileManager* m = [NSFileManager defaultManager];
    [m removeItemAtPath:path error:nil];
}


+(void)saveToCollectionFolder:(NSData*)image
{
    if ([image isKindOfClass:[NSData class]]) {
        NSFileManager* folder = [NSFileManager defaultManager];
        BOOL isExist = YES;
        isExist = [folder fileExistsAtPath:[self myCollectionFilePath] isDirectory:(&isExist)];
        if (!isExist) {
            [folder createDirectoryAtPath:[self myCollectionFilePath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSDate* date = [NSDate date];
        NSString* fileName = [NSString stringWithFormat:@"Image%f",date.timeIntervalSince1970];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",[self myCollectionFilePath],fileName];
        NSLog(@"%@",filePath);
        [image writeToFile:filePath atomically:YES];
    }
}

+(NSArray*)getAllMubanFromCollectionFolder
{
    NSFileManager *manager;
    manager = [NSFileManager defaultManager];
    NSString *home;
    home = [self mubanFilePath];//获得主目录路径
    NSDirectoryEnumerator *direnum;
    direnum = [manager enumeratorAtPath: home];//枚举home下的目录
    NSMutableArray *files;
    files = [NSMutableArray arrayWithCapacity:5];
    NSString *filename;
    while (filename = [direnum nextObject]) {
        [files addObject: [NSString stringWithFormat:@"%@%@",[self mubanFilePath],filename]];
    }
    return files;
}

+(NSArray*)getAllImageFromCollectionFolder
{
    NSFileManager *manager;
    manager = [NSFileManager defaultManager];
    NSString *home;
    home = [self myCollectionFilePath];//获得主目录路径
    NSDirectoryEnumerator *direnum;
    direnum = [manager enumeratorAtPath: home];//枚举home下的目录
    NSMutableArray *files;
    files = [NSMutableArray arrayWithCapacity:5];
    NSString *filename;
    while (filename = [direnum nextObject]) {
        [files addObject: [NSString stringWithFormat:@"%@%@",[self myCollectionFilePath],filename]];
    }
    return files;
}

+(void)statusBarToastWithMessage:(NSString *)message
{
    [JDStatusBarNotification showWithStatus:message dismissAfter:1 styleName:JDStatusBarStyleSuccess];
}

+(void)randomBreakArray:(NSMutableArray *)mArray
{
    if (MAKA_isMutableArray(mArray)) {
        for(int i = 0; i< mArray.count; i++)
        {
            int m = (arc4random() % (mArray.count - i)) + i;
            [mArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
    }
}

@end
