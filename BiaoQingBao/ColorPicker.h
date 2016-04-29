//
//  ColorPicker.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/12.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerDelegate <NSObject>

-(void)buttonAction:(UIButton*)btn;

@end

@interface ColorPicker : UIView

@property (nonatomic,weak) id<ColorPickerDelegate> delegate;

+(instancetype)instanceFromNib;

@end
