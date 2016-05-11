//
//  SubListViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "SubListViewController.h"
#import "SubListCollectionViewCell.h"
#import "CommonHeader.h"
#import "ShareInstance.h"
#import <FLAnimatedImage.h>
#import "ListDetailViewController.h"
#import <ZFModalTransitionAnimator.h>
#import "ServiceManager.h"

@interface SubListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGFloat padding,width,height;
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    
    NSString* str = NSDictionary_String_ForKey(self.dic, @"urls");
    [self.dataSource  addObjectsFromArray:[str componentsSeparatedByString:@","]];
    [ShareInstance randomBreakArray:self.dataSource];
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    width = CollectionCellWidth;
    height = width;
    padding = CollectionCellPadding;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    if ([[ShareInstance shareInstance].myLikeArray containsObject:NSDictionary_String_ForKey(self.dic, @"urls")]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_selected") style:UIBarButtonItemStylePlain target:self action:@selector(deselectLike)];
    }else {

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_normal") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    }
    [self.collectionView reloadData];
}

-(void)rightItemAction
{
    [[ShareInstance shareInstance].myLikeArray addObject:NSDictionary_String_ForKey(self.dic, @"urls")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_selected") style:UIBarButtonItemStylePlain target:self action:@selector(deselectLike)];
}
-(void)deselectLike
{
    [[ShareInstance shareInstance].myLikeArray removeObject:NSDictionary_String_ForKey(self.dic, @"urls")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_normal") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}

#pragma mark <UICollectionViewDataSource>

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ShareInstance shareInstance] save];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (SubListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:NSArray_String_Object_AtIndex(self.dataSource, indexPath.row)] placeholderImage:(ImageNamed(@"img_default"))];
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
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.dataSource index:indexPath.row];
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

@end
