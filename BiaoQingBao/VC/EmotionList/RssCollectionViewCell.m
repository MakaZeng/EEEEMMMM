//
//  RssCollectionViewCell.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "RssCollectionViewCell.h"
#import "CommonHeader.h"

@implementation RssCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    Color_Layer_View(self.contentView);
}

@end
