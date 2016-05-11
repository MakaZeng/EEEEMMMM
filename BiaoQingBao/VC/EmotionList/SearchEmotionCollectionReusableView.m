//
//  SearchEmotionCollectionReusableView.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/22.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "ShareInstance.h"
#import "ServiceManager.h"
#import <Masonry.h>
#import "SearchEmotionCollectionReusableView.h"

@implementation SearchEmotionCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self  =[super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor  = BASE_Tint_COLOR;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(self);
        }];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setImage:ImageNamed(@"icon_add") forState:UIControlStateNormal];
        [self addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
        }];
        self.addButton.hidden = YES;
    }
    return self;
}

@end
