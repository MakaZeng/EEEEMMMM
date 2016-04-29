//
//  ColorPicker.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/12.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ColorPicker" owner:self options:nil]firstObject];
}

- (IBAction)ButtonAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate buttonAction:sender];
    }
}

@end
