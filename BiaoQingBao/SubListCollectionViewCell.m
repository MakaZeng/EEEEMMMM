//
//  SubListCollectionViewCell.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import <objc/runtime.h>
#import "SubListCollectionViewCell.h"

@interface SubListCollectionViewCell()

@property (nonatomic,strong) UIButton* chooseImageView;

@end

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

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (1) {
        if (!self.chooseImageView) {
            self.chooseImageView = [UIButton buttonWithType:UIButtonTypeCustom];
            self.chooseImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.chooseImageView setImage:ImageNamed(@"close_icon") forState:UIControlStateNormal];
            [self.chooseImageView addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.chooseImageView];
            [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.height.mas_equalTo(25);
            }];
        }
        self.chooseImageView.hidden = !selected;
    }
}

-(void)buttonAction
{
    if (self.delegate && self.indexPath) {
        [self.delegate SubListCollectionViewCellCloseAction:self];
    }
}

@end
