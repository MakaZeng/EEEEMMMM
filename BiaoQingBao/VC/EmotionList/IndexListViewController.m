//
//  IndexListViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "IndexListViewController.h"
#import "ImageCollectionViewCell.h"
#import <FLAnimatedImage.h>
#import "CommonHeader.h"
#import <Masonry.h>
#import "ShareInstance.h"
#import "ServiceManager.h"
#import <HMSegmentedControl.h>
#import "ServiceManager.h"
#import <ReactiveCocoa.h>
#import "SubListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IndexListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGFloat padding,width,height;
}

@property (nonatomic,strong) NSArray* result;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isDownloading;

@end

@implementation IndexListViewController

+(instancetype)instanceWithDictionary:(NSDictionary *)dic
{
    IndexListViewController* list = [[IndexListViewController alloc]init];
    list.dic = dic;
    return list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


-(void)shouldFirstLoadWithKeyword:(NSString *)keyword
{
    if (self.dataSource.count > 0 || self.isDownloading) {
        return;
    }
    
    self.isDownloading = YES;
    @weakify(self);
    NSDictionary* dic = [NSDictionary dictionaryWithObject:keyword forKey:@"keyword"];
    [ServiceManager searchEmothionZipWithDic:dic callBack:^(id result) {
        self.isDownloading = NO;
        if (MAKA_isArray(result)) {
            if (!self.dataSource) {
                self.dataSource = [NSMutableArray array];
            }
            @strongify(self);
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result];
            self.isLoaded = YES;
            [self firstLoadUserInterface];
        }
    }];
}

-(void)setDic:(NSDictionary *)dic
{
    if (_dic == dic) {
        return;
    }
    _dic = dic;
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    NSString* arrStr = NSDictionary_String_ForKey(self.dic, @"emotionZIPs");
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:[arrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    [self.dataSource addObjectsFromArray:arr];
    [ShareInstance randomBreakArray:self.dataSource];
    self.isLoaded = YES;
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    width = 90;
    height = width+30;
    padding = 5;
    [self.collectionView reloadData];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}


-(void)segmentedControlChangedValue:(HMSegmentedControl*)control
{
    
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger i = self.dataSource.count;
    if (i == 0 && self.isLoaded) {
        self.state = BaseViewControllerSateNotLoadEmpty;
    }else {
        self.state = BaseViewControllerSateNotLoadComplete;
    }
    return i;
}

- (ImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.dataSource[indexPath.row];
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    NSString* headImageURL = NSDictionary_String_ForKey(dic, @"url");
    
    
    if (headImageURL.length < 10) {
        headImageURL = [[(NSString*)NSDictionary_String_ForKey(dic, @"urls") componentsSeparatedByString:@","] lastObject];
        dic =[dic mutableCopy];
        NSMutableDictionary_setObjectForKey((NSMutableDictionary*)dic,headImageURL,@"headImage");
        NSMutableArray_replaceObjectAtIndex(self.dataSource, indexPath.row ,dic);
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
    cell.titleLabel.text = NSDictionary_String_ForKey(dic, @"title");
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.dataSource[indexPath.row];
    SubListViewController* subList = [[SubListViewController alloc]init];
    subList.hidesBottomBarWhenPushed = YES;
    subList.dic = dic;
    [self.navigationController pushViewController:subList animated:YES];
}

@end
