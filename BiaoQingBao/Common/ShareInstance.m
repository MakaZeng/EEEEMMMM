//
//  ShareInstance.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ShareInstance.h"
#import <Masonry.h>
#import <JDStatusBarNotification.h>

@implementation ShareInstance

+(void)showTips:(NSString*)tips onView:(UIView*)view
{
    UILabel* label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:9];
    label.text = tips;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    CGRect bounds = label.bounds;
    label.bounds = CGRectInset(bounds, -5, -5);
    label.layer.cornerRadius = label.bounds.size.height/2;
    label.backgroundColor = [UIColor redColor];
    label.clipsToBounds = YES;
    UIImageView* im = [[UIImageView alloc]init];
    [view.superview addSubview:im];
    [view.superview addSubview:label];
    view.superview.clipsToBounds = NO;
    label.center = CGPointMake(view.center.x, view.frame.origin.y - label.bounds.size.height/2 - 2);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(label.bounds.size.width);
        make.height.mas_equalTo(label.bounds.size.height);
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.bottom.equalTo(view.mas_top).offset(10);
    }];
    
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (label) {
            [label removeFromSuperview];
        }
        if (im) {
            [im removeFromSuperview];
        }
    });
}

+(UIImage*)scaleImageWithScale:(CGFloat)scale image:(UIImage*)image
{
    CGSize size = image.size;
    size.width = size.width*scale;
    size.height = size.height*scale;
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

+(void)whiteScreen
{
    UIView* v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [UIView animateWithDuration:1 animations:^{
        v.alpha = 0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}

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

-(NSMutableArray*)shareItems
{
    if (_shareItems) {
        return _shareItems;
    }
    NSString *Document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//获取根目录
    NSString *homePath  = [Document stringByAppendingPathComponent:@"shareItems.archiver"];
    
    _shareItems = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    if (!_shareItems) {
        _shareItems = [NSMutableArray array];
    }
    return _shareItems;
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
    homePath  = [Document stringByAppendingPathComponent:@"shareItems.archiver"];
    [NSKeyedArchiver archiveRootObject:_shareItems toFile:homePath];
}

+(CGSize)suitSizeForMaxWidth:(CGFloat)maxWidth MaxHeight:(CGFloat)maxHeight WithImage:(UIImage *)image
{
    CGSize size = image.size;
    
    if (size.width < maxWidth && size.height < maxHeight) {
        return size;
    }
    
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
        [files insertObject:[NSString stringWithFormat:@"%@%@",[self mubanFilePath],filename] atIndex:0];
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
        [files insertObject: [NSString stringWithFormat:@"%@%@",[self myCollectionFilePath],filename] atIndex:0];
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
