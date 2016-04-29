//
//  SubListCollectionViewCell.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "SubListCollectionViewCell.h"

@implementation SubListCollectionViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
