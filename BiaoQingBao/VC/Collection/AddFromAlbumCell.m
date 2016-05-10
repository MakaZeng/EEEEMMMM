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
    self.label.text = NSLocalizedString(@"Add From Album", @"Add From Album");
    Layer_Border_View(self.contentView);
}

@end
