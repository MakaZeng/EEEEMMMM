//
//  DetailCollectionViewCell.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//
#import "CommonHeader.h"
#import "DetailCollectionViewCell.h"

@implementation DetailCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
