//
//  CrawlersViewController.m
//  Qing
//
//  Created by Maka on 15/11/18.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "CrawlersViewController.h"
#import "CrawlersCollectionViewCell.h"
#import <Masonry.h>
#import "TFHpple.h"
#import <MJRefresh.h>
#import <ReactiveCocoa.h>
#import <FLAnimatedImage.h>
#import "FullImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CrawlersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView* collectionView;

@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSString* startString;

@property (nonatomic,strong) NSString* endString;

@property (nonatomic,strong) NSString* XPathString;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger subIncreasingPage;

@property (nonatomic,strong) NSOperationQueue* operationQueue;

@end

@implementation CrawlersViewController

-(instancetype)initWithUrlStartString:(NSString *)startString endString:(NSString *)endString XPathString:(NSString *)XPathString startPage:(NSInteger)page subIncreasingPage:(NSInteger)subIncreasingPage
{
    if (self = [super init]) {
        self.startString = startString;
        self.endString = endString;
        self.XPathString = XPathString;
        self.dataSource = [NSMutableArray array];
        self.page = page;
        self.subIncreasingPage = subIncreasingPage;
        self.operationQueue = [[NSOperationQueue alloc]init];
    }
    return self;
}

-(void)refreshDataWithUrl:(NSString*)url
{
    [self.dataSource removeAllObjects];
    NSData *htmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:htmlData];
    NSArray *array = [xpathparser searchWithXPathQuery:self.XPathString];
    [self.dataSource addObjectsFromArray:array];
}

-(void)appendData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* url;
        if (self.subIncreasingPage) {
            self.subIncreasingPage +=1;
            url = [NSString stringWithFormat:@"%@%ld_%ld%@",self.startString,(long)self.page,self.subIncreasingPage,self.endString];
        }else {
            self.page+=1;
            url = [NSString stringWithFormat:@"%@%ld%@",self.startString,(long)self.page,self.endString];
        }
        
        NSData *htmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
        TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:htmlData];
        NSArray *array = [xpathparser searchWithXPathQuery:self.XPathString];
        if (array.count == 0) {
            if (self.subIncreasingPage) {
                self.page+=1;
                self.subIncreasingPage=0;
            }
            [self appendData];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView.mj_footer endRefreshing];
            
            NSMutableArray* indexPaths = [NSMutableArray array];
            for (NSInteger i = self.dataSource.count ; i < array.count + self.dataSource.count ; i++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [self.dataSource addObjectsFromArray:array];
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* url;
    if (self.subIncreasingPage) {
        url = [NSString stringWithFormat:@"%@%ld_%ld%@",self.startString,(long)self.page,self.subIncreasingPage,self.endString];
    }else {
        url = [NSString stringWithFormat:@"%@%ld%@",self.startString,(long)self.page,self.endString];
    }
    [self refreshDataWithUrl:url];
    
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CrawlersCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CrawlersCollectionViewCell"];
    
    @weakify(self);
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self appendData];
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(loadWebview)];
}

-(void)loadWebview
{

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.dataSource.count > 0) {
        if (self.collectionView.contentOffset.y + [UIScreen mainScreen].bounds.size.height > self.collectionView.contentSize.height + 50) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFHppleElement* element = self.dataSource[indexPath.row];
    NSString* imgSrc = [[element attributes] objectForKey:@"src"];
    CrawlersCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CrawlersCollectionViewCell" forIndexPath:indexPath];
    [cell.crawlerImageView sd_setImageWithURL:[NSURL URLWithString:imgSrc]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    TFHppleElement* element = self.dataSource[indexPath.row];
    NSString* imgSrc = [[element attributes] objectForKey:@"src"];
    FullImageViewController* full =[[FullImageViewController alloc]init];
    full.imgSrc = imgSrc;
    [self.navigationController pushViewController:full animated:YES];
}

#define NumberPerLine 4
#define CollectionCellInset 2

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
    
    CGFloat width = (screenWidth - (NumberPerLine +1)*CollectionCellInset)/NumberPerLine;
    CGFloat height = width*1.2;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(CollectionCellInset, CollectionCellInset, CollectionCellInset, CollectionCellInset);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

@end
