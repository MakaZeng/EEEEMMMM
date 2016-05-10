//
//  ShareItemView.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import <Masonry.h>
#import "MakaShareItemView.h"

@implementation MakaShareItemView

+(instancetype)instance
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MakaShareItemView" owner:self options:nil]firstObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.alpha = .5;
    Layer_View(self.btn);
    self.btn.backgroundColor = [UIColor clearColor];
    [self.btn setBackgroundImage:ImageNamed(@"img_black") forState:UIControlStateHighlighted];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
