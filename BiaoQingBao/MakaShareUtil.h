//
//  ShareUtil.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define BEGIN_TAG 1000

typedef enum : NSUInteger {
    ShareUtilTypeQQ,
    ShareUtilTypeWechat,
    ShareUtilTypeWechatSession,
    ShareUtilTypeWechatCollection,
} ShareUtilType;

@class MakaShareUtil;

@protocol ShareUtilDelegate <NSObject>

-(void)ShareUtil:(MakaShareUtil*)util selectedType:(ShareUtilType)type;

@end

@interface MakaShareUtil : NSObject

+(UIView*)instanceViewForItems:(NSArray*)items delegate:(id<ShareUtilDelegate>)delegate;

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@end
