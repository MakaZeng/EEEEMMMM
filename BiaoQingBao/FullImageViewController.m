//
//  FullImageViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/15.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "FullImageViewController.h"

@interface FullImageViewController ()

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgSrc]];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"旋转" style:UIBarButtonItemStyleBordered target:self action:@selector(rotate)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)rotate
{
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
