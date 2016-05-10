//
//  SearchEmotionController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/22.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ServiceManager.h"
#import "SearchEmotionController.h"
#import "SubListViewController.h"
#import "ListDetailViewController.h"
#import <ZFModalTransitionAnimator.h>
#import "SubListCollectionViewCell.h"
#import "ShareInstance.h"
#import "SearchEmotionCollectionReusableView.h"

@interface SearchEmotionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat padding,width,height;
}

@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@property (nonatomic,strong) NSMutableArray* zipDataSource;

@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,assign) BOOL hasZip;

@property (nonatomic,assign) BOOL hasEmotion;

@end

@implementation SearchEmotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Search", @"Search");
    [self firstLoadUserInterface];
}


#pragma mark - Table view data source

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)cancelAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    if (searchBar.text.length  == 0) {
        return;
    }
    NSDictionary* dic = [NSDictionary dictionaryWithObject:searchBar.text forKey:@"keyword"];
    [ServiceManager searchEmothionWithDic:dic callBack:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            if (!self.dataSource) {
                self.dataSource = [NSMutableArray array];
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result];
            [ShareInstance randomBreakArray:self.dataSource];
            [self.collectionView reloadData];
        }
    }];
    [ServiceManager searchEmothionZipWithDic:dic callBack:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            if (!self.zipDataSource) {
                self.zipDataSource = [NSMutableArray array];
            }
            [self.zipDataSource removeAllObjects];
            [self.zipDataSource addObjectsFromArray:result];
            [ShareInstance randomBreakArray:self.zipDataSource];
            self.isLoaded = YES;
            [self.collectionView reloadData];
        }
    }];
}

-(void)firstLoadData
{
    
}

-(void)firstLoadUserInterface
{
    
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(2);
        make.height.mas_equalTo(41);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton setImage:ImageNamed(@"imag_back") forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.searchBar);
        make.width.height.mas_equalTo(40);
    }];
    
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(43, 0, 0, 0));
    }];
    [self.collectionView registerClass:[SearchEmotionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    width = 95;
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


#pragma mark <UICollectionViewDataSource>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        SearchEmotionCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView" forIndexPath:indexPath];
        
        NSString *title = nil;
        
        if (self.hasZip&&indexPath.section == 0) {
            title=NSLocalizedString(@"Package Result:", @"下面这些是表情包:");
        }else {
            title=NSLocalizedString(@"Emoticon Result:", @"这些是搜索到的表情:");
        }
        
        headerView.titleLabel.text = title;
        
        reusableview = headerView;
    }
    return reusableview;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.hasZip) {
        if (indexPath.section == 0) {
            [self emotionZipTapIndexPath:indexPath];
        }else{
            [self emotionTapIndexPath:indexPath];
        }
    }else{
        [self emotionTapIndexPath:indexPath];
    }
}

-(void)emotionZipTapIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary* dic = self.zipDataSource[indexPath.row];
    SubListViewController* subList = [[SubListViewController alloc]init];
    subList.hidesBottomBarWhenPushed = YES;
    subList.dic = dic;
    subList.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:subList animated:YES];
}


-(void)emotionTapIndexPath:(NSIndexPath*)indexPath
{
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.dataSource index:indexPath.row];
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    self.hasZip = NO;
    self.hasEmotion = NO;
    NSInteger i = 0;
    if (self.dataSource.count > 0) {
        self.hasEmotion = YES;
        i++;
    }
    if (self.zipDataSource.count > 0) {
        self.hasZip = YES;
        i++;
    }
    if (i == 0 && self.isLoaded) {
        self.state = BaseViewControllerSateNotLoadEmpty;
    }else {
        self.state = BaseViewControllerSateNotLoadComplete;
    }
    return i;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_hasZip) {
        if (section == 0) {
            return self.zipDataSource.count;
        }else {
            return self.dataSource.count;
        }
    }else {
        return self.dataSource.count;
    }
}

- (SubListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic;
    
    
    if (indexPath.section == 0) {
        if (self.hasZip) {
             dic = self.zipDataSource[indexPath.row];
        }else {
            dic = self.dataSource[indexPath.row];
        }
        SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
        
        NSString* headImageURL = NSDictionary_String_ForKey(dic, @"url");
        
        if (self.hasZip) {
            if (headImageURL.length < 10) {
                headImageURL = [[(NSString*)NSDictionary_String_ForKey(dic, @"urls") componentsSeparatedByString:@","] firstObject];
                dic =[dic mutableCopy];
                NSMutableDictionary_setObjectForKey((NSMutableDictionary*)dic,headImageURL,@"headImage");
                NSMutableArray_replaceObjectAtIndex(self.zipDataSource, indexPath.row ,dic);
            }
        }
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
        return cell;
    }else {
        dic = self.dataSource[indexPath.row];
        SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
        
        NSString* headImageURL = NSDictionary_String_ForKey(dic, @"url");
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 30);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, height);
}



@end
