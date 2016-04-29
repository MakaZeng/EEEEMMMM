//
//  ShareItemView.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakaShareItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) UIButton* btn;

+(instancetype)instance;

@end
