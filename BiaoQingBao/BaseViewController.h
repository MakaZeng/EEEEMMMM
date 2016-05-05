//
//  BaseViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseViewControllerProtocol <NSObject>

-(void)firstLoadData;

-(void)firstLoadUserInterface;

-(void)updateData;

-(void)updateUserInterface;

@end

static NSMutableArray* BannberADIdenList;

typedef enum : NSUInteger {
    BaseViewControllerSateNotLoadData,
    BaseViewControllerSateNotLoading,
    BaseViewControllerSateNotLoadComplete,
    BaseViewControllerSateNotLoadFail,
    BaseViewControllerSateNotLoadEmpty,
} BaseViewControllerSate;

@interface BaseViewController : UIViewController<BaseViewControllerProtocol>

@property (nonatomic,strong) UIView* emptyView;

@property (nonatomic,assign) BaseViewControllerSate state;

-(void)firstLoadData;

-(void)firstLoadUserInterface;

-(void)updateData;

-(void)updateUserInterface;

@end
