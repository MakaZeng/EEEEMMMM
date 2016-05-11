//
//  RssViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//


#import <ZFModalTransitionAnimator.h>
#import "MyCollectionViewController.h"
#import "SearchEmotionCollectionReusableView.h"
#import "ListDetailViewController.h"
#import "CommonHeader.h"
#import "ServiceManager.h"
#import "ShareInstance.h"
#import "SubListViewController.h"
#import "RssViewController.h"
#import "RssCollectionViewCell.h"
#import <ReactiveCocoa.h>
#import "IndexViewController.h"
#import "ServiceManager.h"
#import <Masonry.h>

@interface RssViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat padding,width,height;
}


@property (nonatomic,strong) NSMutableArray* myRssDataSource;

@property (nonatomic,strong) NSMutableArray* dataSource;

@end

@implementation RssViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ShareInstance shareInstance] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IndexViewController" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RssCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RssCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.title = NSLocalizedString(@"Rss", @"Rss");
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


-(void)firstLoadData
{
    [self.collectionView registerClass:[SearchEmotionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView"];
    self.myRssDataSource = [ShareInstance shareInstance].myRssArray;
    self.dataSource = [NSMutableArray array];
    @weakify(self);
    [ServiceManager queryRssWithDic:nil callBack:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]]) {
            
            @strongify(self);
            for (NSDictionary* dic in result) {
                [self.dataSource addObject:NSDictionary_String_ForKey(dic, @"title")];
            }
            
            for (NSInteger i = self.dataSource.count -1; i>=0; i--) {
                NSString* str = self.dataSource[i];
                if ([self.myRssDataSource containsObject:str]) {
                    [self.dataSource removeObject:str];
                }
            }
            [self firstLoadUserInterface];
        }
        
    }];
    
}

-(void)firstLoadUserInterface
{
    width = 60;
    height = 25;
    padding = 5;
    [self.collectionView reloadData];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}


#pragma mark <UICollectionViewDataSource>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        SearchEmotionCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView" forIndexPath:indexPath];
        
        NSString *title = nil;
        
        if (indexPath.section == 0) {
            title=NSLocalizedString(@"My Rss:", @"我的订阅:");
            headerView.addButton.hidden = NO;
            [headerView.addButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        }else {
            title=NSLocalizedString(@"Suggest Rss:", @"推荐订阅:");
            headerView.addButton.hidden = YES;
        }
        
        headerView.titleLabel.text = title;
        
        reusableview = headerView;
    }
    return reusableview;
    
}

-(void)buttonAction
{
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Edit)
    .title(NSLocalizedString(@"Add KeyWord", @"添加关键词"))
    .subTitle(NSLocalizedString(@"Keyword Should be accurate", @"注意:关键词为动物,是搜索不到猫的。"))
    .duration(0);
    
    __block SCLTextView* textView;
    
    @weakify(self);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(NSLocalizedString(@"Add", @"添加"), ^{
        @strongify(self);
        [self addKeyWithString:textView.text];
    });
    
    textView = [builder.alertView addTextField:NSLocalizedString(@"Input KeyWord", @"输入关键词")];
    
    [builder.alertView addButton:NSLocalizedString(@"Cancel", @"取消") actionBlock:^{
        
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, [UIApplication sharedApplication].keyWindow.rootViewController);
}

-(void)addKeyWithString:(NSString*)string
{
    if (string.length == 0 || [self.myRssDataSource containsObject:string]) {
        return;
    }
    [self.myRssDataSource addObject:string];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.myRssDataSource.count-1 inSection:0]]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myRssDataSource.count;
    }else {
        return self.dataSource.count;
    }
}

- (RssCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RssCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RssCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.contentLabel.text = self.myRssDataSource[indexPath.row];
    }else {
        cell.contentLabel.text = self.dataSource[indexPath.row];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSString* str = [self.myRssDataSource objectAtIndex:indexPath.row];
        [self.myRssDataSource removeObjectAtIndex:indexPath.row];
        [self.dataSource insertObject:str atIndex:0];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }else {
        NSString* str = [self.dataSource objectAtIndex:indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.myRssDataSource insertObject:str atIndex:0];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = nil;
    if (indexPath.section == 0) {
        str = [self.myRssDataSource objectAtIndex:indexPath.row];
    }else {
        str = [self.dataSource objectAtIndex:indexPath.row];
    }
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 30) lineBreakMode:NSLineBreakByCharWrapping];
    size.height = 30;
    size.width = size.width+10;
    return size;
}

@end
