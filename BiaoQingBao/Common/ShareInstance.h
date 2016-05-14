//
//  ShareInstance.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import <SCLAlertView.h>
#import <Foundation/Foundation.h>

@interface ShareInstance : NSObject

@property (nonatomic,strong) NSMutableArray* myLikeArray;

@property (nonatomic,strong) NSMutableArray* myRssArray;

@property (nonatomic,strong) NSMutableArray* webSiteArray;

@property (nonatomic,strong) NSMutableArray* shareItems;

-(BOOL)shouldShowAds;

+(void)showTips:(NSString*)tips onView:(UIView*)view;

+(void)whiteScreen;

-(UIView*)adsView;

+(UIImage*)scaleImageWithScale:(CGFloat)scale image:(UIImage*)image;

+(instancetype)shareInstance;

//image

-(void)save;

+(CGSize)suitSizeForMaxWidth:(CGFloat)maxWidth MaxHeight:(CGFloat)maxHeight WithImage:(UIImage*)image;

+(BOOL)isADDcitonary:(NSDictionary*)dic;

+(NSString*)urlForOpen:(NSDictionary*)dic;

+(void)statusBarToastWithMessage:(NSString*)message;

+(void)randomBreakArray:(NSMutableArray*)mArray;

+(void)saveToCollectionFolder:(id)image;

+(void)saveToMubanFolder:(id)image;

+(void)removeFile:(NSString*)path;

+(NSArray*)getAllMubanFromCollectionFolder;

+(NSArray*)getAllImageFromCollectionFolder;

+(NSString*)showRateView;

@end
