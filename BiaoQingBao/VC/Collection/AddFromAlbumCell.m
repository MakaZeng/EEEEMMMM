//
//  AddFromAlbumCell.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/5/6.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "AddFromAlbumCell.h"

@implementation AddFromAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel* label = self.subviews.firstObject;
    label.backgroundColor = BASE_BACK_COLOR;
    Layer_View(label);
}

@end
