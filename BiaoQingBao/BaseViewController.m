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

/*
 
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
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:[NSString stringWithFormat:@"%s",object_getClassName(self)] object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isActive = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isActive = NO;
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

-(void)setState:(BaseViewControllerSate )state
{
    if (_state == state) {
        return;
    }
    _state = state;
    _emptyView.hidden = YES;
    if (_state == BaseViewControllerSateNotLoadEmpty) {
        if (!_emptyView) {
            [self.view addSubview:self.emptyView];
            self.emptyView.userInteractionEnabled = NO;
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
        }
        _emptyView.hidden = NO;
    }
}

-(UIView*)emptyView
{
    if (_emptyView) {
        return _emptyView;
    }
    UIView* view = [[UIView alloc]init];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = ImageNamed(@"empty_icon");
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-20);
        make.width.height.mas_equalTo(80);
    }];
    
    UILabel* label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = NSLocalizedString(@"Empty", @"当前列表为空");
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    _emptyView = view;
    return view;
}

@end
