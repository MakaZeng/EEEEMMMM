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

@interface BaseViewController : UIViewController<BaseViewControllerProtocol>

-(void)firstLoadData;

-(void)firstLoadUserInterface;

-(void)updateData;

-(void)updateUserInterface;

@end
