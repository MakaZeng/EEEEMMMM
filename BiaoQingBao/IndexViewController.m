//
//  IndexViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/19.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "ShareInstance.h"
#import "IndexViewController.h"
#import <Masonry.h>
#import "ServiceManager.h"
#import <HMSegmentedControl.h>
#import <ReactiveCocoa.h>
#import "IndexListViewController.h"
#import "SearchEmotionController.h"
#import "RssViewController.h"

@interface IndexViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) HMSegmentedControl* segmentedControl;

@property (nonatomic,strong) NSMutableArray* viewControllers;

@property (nonatomic,strong) id result;

@end

@implementation IndexViewController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)rightItemAction
{
    SearchEmotionController* search = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SearchEmotionController"];
    [self presentViewController:search animated:YES completion:nil];
}

-(void)firstLoadData
{
    self.title = NSLocalizedString(@"Emotions", @"Emotions");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:RssViewControllerWillDisAppear object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"index_search") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.viewControllers = [NSMutableArray arrayWithCapacity:5];
    
    @weakify(self);
    [ServiceManager queryIndexListWithDic:nil callBack:^(id result) {
        @strongify(self);
        self.result = result;
        [self firstLoadUserInterface];
    }];
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


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSMutableArray* titles = [NSMutableArray array];
    for (NSDictionary* dic in self.result) {
        if (MAKA_isDicionary(dic))
        {
            [titles addObject:NSDictionary_String_ForKey(dic, @"title")];
        }
    }
    [titles addObjectsFromArray:[ShareInstance shareInstance].myRssArray];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*titles.count, 20);
}


-(void)firstLoadUserInterface
{
    if (MAKA_isArray(self.result)) {
        
        NSMutableArray* titles = [NSMutableArray array];
        for (NSDictionary* dic in self.result) {
            if (MAKA_isDicionary(dic))
            {
                [titles addObject:NSDictionary_String_ForKey(dic, @"title")];
            }
        }
        [titles addObjectsFromArray:[ShareInstance shareInstance].myRssArray];
        
        UIButton* rssButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rssButton setImage:[UIImage imageNamed:@"rss_icon"] forState:UIControlStateNormal];
        [self.view addSubview:rssButton];
        [rssButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(30);
        }];
        [rssButton addTarget:self action:@selector(rssAction) forControlEvents:UIControlEventTouchUpInside];
        [self updateData];
    }
}

#pragma mark - BASE_Tint_COLOR

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width-10;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    if (page >= [self.result count]) {
        IndexListViewController* list = NSArray_ObjectAt_Index(self.viewControllers, page);
        [list shouldFirstLoadWithKeyword:NSArray_String_Object_AtIndex(self.segmentedControl.sectionTitles, page)];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width-10;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    if (page >= [self.result count]) {
        IndexListViewController* list = NSArray_ObjectAt_Index(self.viewControllers, page);
        [list shouldFirstLoadWithKeyword:NSArray_String_Object_AtIndex(self.segmentedControl.sectionTitles, page)];
    }
    
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
    if (MAKA_isArray(self.result)) {
        
        NSMutableArray* titles = [NSMutableArray array];
        for (NSDictionary* dic in self.result) {
            if (MAKA_isDicionary(dic))
            {
                [titles addObject:NSDictionary_String_ForKey(dic, @"title")];
            }
        }
        [titles addObjectsFromArray:[ShareInstance shareInstance].myRssArray];
        
        if (titles.count > 0) {
            self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 30)];
            self.segmentedControl.sectionTitles = titles;
            self.segmentedControl.selectedSegmentIndex = 0;
            self.segmentedControl.backgroundColor = BASE_Tint_COLOR;
            self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : BASE_BACK_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:15]};
            self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : BASE_BACK_COLOR};
            self.segmentedControl.selectionIndicatorColor = BASE_BACK_COLOR;
            self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
            self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
            self.segmentedControl.tag = 3;
            BottomLine_View(self.segmentedControl,LightDarkColor);
            __weak typeof(self) weakSelf = self;
            [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
                [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 200) animated:YES];
            }];
            
            [self.view addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(30);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
                make.top.mas_equalTo(0);
            }];
            
            
            IndexListViewController* vc;
            IndexListViewController* lastVC;
            
            for (NSInteger i = 0 ; i< titles.count ; i ++ ) {
                NSDictionary* dic = NSArray_ObjectAt_Index(((NSArray*)self.result), i);
                vc = [IndexListViewController  instanceWithDictionary:dic];
                [self.viewControllers addObject:vc];
                [self addChildViewController:vc];
                vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height-self.segmentedControl.frame.size.height);
                [self.scrollView addSubview:vc.view];
                [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastVC) {
                        make.left.equalTo(lastVC.view.mas_right);
                    }else {
                        make.left.mas_equalTo(0);
                    }
                    make.top.mas_equalTo(0);
                    make.width.equalTo(self.scrollView);
                    make.height.equalTo(self.scrollView).offset(-self.segmentedControl.frame.size.height);
                }];
                lastVC = vc;
            }
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*titles.count, 20);
            self.scrollView.contentInset = UIEdgeInsetsMake(self.segmentedControl.frame.size.height, 0, 0, 0);
            [self.scrollView setContentOffset:CGPointMake(0, -self.segmentedControl.frame.size.height) animated:YES];
            self.scrollView.delegate = self;
            self.scrollView.pagingEnabled = YES;
            self.scrollView.showsHorizontalScrollIndicator= NO;
            self.scrollView.showsVerticalScrollIndicator = NO;
            self.scrollView.directionalLockEnabled = YES;
        }
    }

}

-(void)updateUserInterface
{
    
}

@end
