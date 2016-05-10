//
//  FullImageViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/15.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "FullImageViewController.h"
#import <Masonry.h>

@interface FullImageViewController ()

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[FLAnimatedImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgSrc]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
