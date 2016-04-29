//
//  SearchViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "RxWebViewController.h"
#import "TOWebViewController+QRCodeHelper.h"
#import "RxWebViewNavigationViewController.h"
#import "CrawlersViewController.h"

@interface SearchViewController ()
{
    CGFloat width,height,padding;
}
@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSDictionary* dic;


@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    NSString* arrStr = NSDictionary_String_ForKey(self.dic, @"emotionZIPs");
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:[arrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    [self.dataSource addObjectsFromArray:arr];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"camera" forKey:@"imageURL"];
    [dic setObject:@"camera" forKey:@"localImage"];
    [dic setObject:@"使用相机选取图片" forKey:@"title"];
    [dic setObject:@"生成动态表情" forKey:@"subTitle"];
    [dic setObject:@"http://www.baidu.com" forKey:@"jumpURL"];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    width = (SCREEN_WIDTH-10)/2;
    height = width;
    padding = 0;
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

- (SearchCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.dataSource[indexPath.row];
    
    SearchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
    
    NSString* str = NSDictionary_String_ForKey(dic, @"localImage");
    
    cell.backImageView.image = ImageResizeImage(ImageNamed(@"icon_back"));
    if (str.length > 0) {
        cell.iconImageView.image = [UIImage imageNamed:str];
    }else {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"imageURL")]];
    }
    
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
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1) {
        
    }else if (indexPath.row == 2) {
        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CrawlerWebList" ofType:@".plist"]];
        
        NSArray* arr = [dic objectForKey:@"data"];
        
        dic = [arr firstObject];
        
        CrawlersViewController* crawlers = [[CrawlersViewController alloc]initWithUrlStartString:[dic objectForKey:@"startString"] endString:[dic objectForKey:@"endString"] XPathString:[dic objectForKey:@"xPath"] startPage:[[dic objectForKey:@"startPage"] integerValue] subIncreasingPage:[dic objectForKey:@"subIncreasingPage"] ? [[dic objectForKey:@"subIncreasingPage"] integerValue] : 0];
        crawlers.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:crawlers animated:YES];
    }else if (indexPath.row == 3){
        NSString* urlStr = @"https://www.baidu.com";
        RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
