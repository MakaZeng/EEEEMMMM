//
//  BaseViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ShareInstance.h"

@interface BaseViewController (MakaZeng)

@end

@implementation BaseViewController(MakaZeng)

+(void)load
{
    if (!BannberADIdenList) {
        BannberADIdenList = [NSMutableArray array];
        [BannberADIdenList addObjectsFromArray:@[]];
    }
}

@end

@implementation BaseViewController

static NSInteger instanceCount;

-(instancetype)init
{
    if (self = [super init]) {
        instanceCount++;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        instanceCount++;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[ShareInstance shareInstance] shouldShowAds]) {
            if (instanceCount%2==0) {
                UIView* adsView = [[ShareInstance shareInstance] adsView];
                [self.view addSubview:adsView];
                [adsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                }];
            }
        }
    });
}
-(void)firstLoadData
{
    
}

-(void)firstLoadUserInterface
{
    
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
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
