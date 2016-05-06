//
//  CollectionViewController.m
//  BiaoQingBao
//
//  Created by maka on 16/5/4.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "ShareInstance.h"
#import "IndexViewController.h"
#import <Masonry.h>
#import "ServiceManager.h"
#import <HMSegmentedControl.h>
#import <ReactiveCocoa.h>
#import "MyCollectionViewController.h"
#import "SearchEmotionController.h"
#import "RssViewController.h"
#import "MyCollectionViewController.h"
#import "CollectionViewController.h"

@interface CollectionViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) HMSegmentedControl* segmentedControl;

@property (nonatomic,strong) NSMutableArray* viewControllers;

@end

@implementation CollectionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self firstLoadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%s",object_getClassName(self.viewControllers.firstObject)] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)firstLoadData
{
    self.viewControllers = [NSMutableArray arrayWithCapacity:5];
    [self firstLoadUserInterface];
}

-(void)rssAction
{
    RssViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RssViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshList
{
    [self updateData];
}


-(void)firstLoadUserInterface
{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    NSMutableArray* titles = [NSMutableArray array];
    [titles addObject:@"制图模版"];
    [titles addObject:@"表情"];
    [titles addObject:@"表情包"];
    [titles addObject:@"网页抓图"];
    if (titles.count > 0) {
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 30)];
        self.segmentedControl.sectionTitles = titles;
        self.segmentedControl.selectedSegmentIndex = 0;
        self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        self.segmentedControl.backgroundColor = BASE_Tint_COLOR;
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : BASE_BACK_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:15]};
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : BASE_BACK_COLOR};
        self.segmentedControl.selectionIndicatorColor = BASE_BACK_COLOR;
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
        self.segmentedControl.tag = 3;
        __weak typeof(self) weakSelf = self;
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 200) animated:YES];
        }];
        self.navigationItem.titleView = self.segmentedControl;
        
        
        MyCollectionViewController* vc;
        MyCollectionViewController* lastVC = nil;
        
        for (NSInteger i = 0 ; i< titles.count ; i ++ ) {
            vc = [[MyCollectionViewController alloc] initWithType:i];
            vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
            [self.scrollView addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastVC) {
                    make.left.equalTo(lastVC.view.mas_right);
                }else {
                    make.left.mas_equalTo(0);
                }
                make.top.mas_equalTo(0);
                make.width.height.equalTo(self.scrollView);
            }];
            [self.viewControllers addObject:vc];
            [self addChildViewController:vc];
            lastVC = vc;
            
        }
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*titles.count, 20);
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator= NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.directionalLockEnabled = YES;
    }
}

#pragma mark - BASE_Tint_COLOR

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 20);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width-10;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

-(void)segmentedControlChangedValue:(id)sender
{
    
}

-(void)updateData
{
    [self.segmentedControl removeFromSuperview];
    [self.viewControllers removeAllObjects];
    for (UIViewController* vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}

-(void)updateUserInterface
{
    
}

@end
