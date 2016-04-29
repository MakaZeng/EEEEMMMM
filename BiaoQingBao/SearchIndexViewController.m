//
//  SearchIndexViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/18.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "SearchIndexViewController.h"
#import "ServiceManager.h"
#import "CommonHeader.h"
#import "ImageCollectionViewCell.h"

@interface SearchIndexViewController ()<UISearchBarDelegate>
{
    CGFloat padding,width,height,maxWidth,minWidth;
}
@property (nonatomic,strong) NSArray* result;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation SearchIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Search";
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self firstLoadUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

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
            [self.collectionView reloadData];
        }
    }];
}

-(void)firstLoadData
{

}

-(void)firstLoadUserInterface
{
    minWidth = (320 - 4*8)/3;
    maxWidth = 130;
    
    NSInteger row = 0;
    
    for (NSInteger i = 3; i<100 ; i++) {
        if ((SCREEN_WIDTH / i >= minWidth) && (SCREEN_WIDTH /i <= maxWidth)) {
            row = i;
            break;
        }
    }
    
    if (row == 0) {
        row = 3;
    }
    
    CGFloat perWidth = SCREEN_WIDTH/row;
    perWidth -= ((NSInteger)perWidth)%10;
    CGFloat totalWidth = perWidth*row;
    
    CGFloat totalPadding = SCREEN_WIDTH - totalWidth;
    
    padding = totalPadding/(row+1);
    
    width = perWidth-10;
    height = perWidth+30;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView reloadData];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
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

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return padding;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return padding;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
