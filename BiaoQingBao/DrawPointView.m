//
//  DrawPointView.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/29.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "DrawPointView.h"

@implementation DrawPointView

+(instancetype)instance
{
    DrawPointView* view = [[DrawPointView alloc]init];
    
    CGFloat width = 15;
    
    CGFloat height = 10;
    
    for (NSInteger i = 0; i<5; i++) {
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, height*i, width, height)];
        [view addSubview:v];
        
        UIView* vvv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, i+2.5, i+2.5)];
        vvv.layer.cornerRadius = vvv.bounds.size.width/2;
        vvv.layer.masksToBounds = YES;
        vvv.backgroundColor = [UIColor redColor];
        [v addSubview:vvv];
        v.center = CGPointMake(width/2, height/2);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = v.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [v addSubview:btn];
        [btn addTarget:view action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
}

-(void)buttonAction
{
    
}

@end
