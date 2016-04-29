//
//  MyCollectionViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <ZFModalTransitionAnimator.h>
#import "MyCollectionViewController.h"
//#import "ImageCollectionViewCell.h"
#import "SearchEmotionCollectionReusableView.h"
#import "SubListCollectionViewCell.h"
#import "ListDetailViewController.h"
#import "CommonHeader.h"
#import "ServiceManager.h"
#import "ShareInstance.h"
#import <FLAnimatedImage.h>
#import "SubListViewController.h"

@interface MyCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat padding,width,height;
}

@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@property (nonatomic,strong) NSMutableArray* zipDataSource;

@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSMutableArray* myCollectionDataSource;

@property (nonatomic,assign) BOOL hasZip;

@property (nonatomic,assign) BOOL hasEmotion;

@property (nonatomic,assign) BOOL hasMyCollection;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.collectionView registerClass:[SearchEmotionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    self.zipDataSource = [NSMutableArray array];
    self.myCollectionDataSource = [NSMutableArray array];
    
    NSMutableArray* array = [ShareInstance shareInstance].myLikeArray;
    for (NSString* str in array) {
        if ([str containsString:@","]) {
            [self.zipDataSource addObject:str];
        }else {
            [self.dataSource addObject:str];
        }
    }
    [self.myCollectionDataSource addObjectsFromArray:[ShareInstance getAllImageFromCollectionFolder]];
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    self.collectionView.backgroundColor = self.view.backgroundColor;
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
        
        if (indexPath.section == 0) {
            if (_hasZip) {
                title=@"这些是收藏的表情包:";
            }else if (_hasEmotion) {
                title=@"收藏的表情:";
            }else {
                title = @"从网页收集的内容:";
            }
        }else if(indexPath.section == 1) {
            if (_hasZip) {
                if (_hasEmotion) {
                    title=@"收藏的表情:";
                }else {
                    title = @"从网页收集的内容:";
                }
            }else {
                title = @"从网页收集的内容:";
            }
        }else if (indexPath.section == 2){
            title = @"从网页收集的内容:";
        }
        
        headerView.titleLabel.text = title;
        
        reusableview = headerView;
    }
    return reusableview;
    
}


-(void)emotionTapIndexPath:(NSIndexPath*)indexPath
{
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.dataSource index:indexPath.row];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
    self.animator.dragable = NO;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    [self.animator setContentScrollView:detailViewController.collectionView];
    
    // set transition delegate of modal view controller to our object
    detailViewController.transitioningDelegate = self.animator;
    
    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

-(void)collectionEmotionTapIndexPath:(NSIndexPath*)indexPath
{
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.myCollectionDataSource index:indexPath.row];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
    self.animator.dragable = NO;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    [self.animator setContentScrollView:detailViewController.collectionView];
    
    // set transition delegate of modal view controller to our object
    detailViewController.transitioningDelegate = self.animator;
    
    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
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
    if (self.myCollectionDataSource.count > 0) {
        self.hasMyCollection = YES;
        i++;
    }
    return i;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_hasZip) {
            return self.zipDataSource.count;
        }else if (_hasEmotion) {
            return self.dataSource.count;
        }else {
            return self.myCollectionDataSource.count;
        }
    }else if(section == 1) {
        if (_hasZip) {
            if (_hasEmotion) {
                return self.dataSource.count;
            }else {
                return self.myCollectionDataSource.count;
            }
        }else {
            return self.myCollectionDataSource.count;
        }
    }else if (section == 2){
        return self.myCollectionDataSource.count;
    }
    return 0;
}

- (SubListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string;
    
    if (indexPath.section == 0) {
        if (_hasZip) {
            string = self.zipDataSource[indexPath.row];
            
            string = [[string componentsSeparatedByString:@","] firstObject];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            NSString* headImageURL = string;
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
            return cell;
        }else if (_hasEmotion) {
            
            string = self.dataSource[indexPath.row];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            NSString* headImageURL = string;
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
            return cell;
            
        }else {
            
            string = self.myCollectionDataSource[indexPath.row];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            NSData* data = [[NSData alloc]initWithContentsOfFile:string];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                cell.imageView.animatedImage = animatedImage;
            }else {
                cell.imageView.image  =[[UIImage alloc]initWithData:data];
            }
            return cell;
            
        }
    }else if(indexPath.section == 1) {
        
        if (_hasZip) {
            if (_hasEmotion) {
                string = self.dataSource[indexPath.row];
                
                SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
                
                NSString* headImageURL = string;
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
                return cell;
            }else {
                string = self.myCollectionDataSource[indexPath.row];
                
                SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
                
                NSData* data = [[NSData alloc]initWithContentsOfFile:string];
                
                FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                if (animatedImage) {
                    cell.imageView.animatedImage = animatedImage;
                }else {
                    cell.imageView.image  =[[UIImage alloc]initWithData:data];
                }
                return cell;
            }
        }else {
            string = self.myCollectionDataSource[indexPath.row];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            NSData* data = [[NSData alloc]initWithContentsOfFile:string];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                cell.imageView.animatedImage = animatedImage;
            }else {
                cell.imageView.image  =[[UIImage alloc]initWithData:data];
            }
            return cell;
        }
        
    }else if (indexPath.section == 2){
        string = self.myCollectionDataSource[indexPath.row];
        
        SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
        
        NSData* data = [[NSData alloc]initWithContentsOfFile:string];
        
        FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
        if (animatedImage) {
            cell.imageView.animatedImage = animatedImage;
        }else {
            cell.imageView.image  =[[UIImage alloc]initWithData:data];
        }
        return cell;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (_hasZip) {
            NSDictionary* dic = @{@"urls":self.zipDataSource[indexPath.row],@"title":@"收藏的表情包"};
            SubListViewController* subList = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SubListViewController"];
            subList.hidesBottomBarWhenPushed = YES;
            subList.dic = dic;
            [self.navigationController pushViewController:subList animated:YES];
        }else if (_hasEmotion) {
            [self emotionTapIndexPath:indexPath];
        }else {
            [self collectionEmotionTapIndexPath:indexPath];
        }
    }else if(indexPath.section == 1) {
        if (_hasZip) {
            if (_hasEmotion) {
                [self emotionTapIndexPath:indexPath];
            }else {
                [self collectionEmotionTapIndexPath:indexPath];
            }
        }else {
            [self collectionEmotionTapIndexPath:indexPath];
        }
    }else if (indexPath.section == 2){
        [self collectionEmotionTapIndexPath:indexPath];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, height);
}

@end
