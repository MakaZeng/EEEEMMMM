//
//  MyCollectionViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <ZFModalTransitionAnimator.h>
#import "MyCollectionViewController.h"
#import "SearchEmotionCollectionReusableView.h"
#import "SubListCollectionViewCell.h"
#import "ListDetailViewController.h"
#import "CommonHeader.h"
#import "ServiceManager.h"
#import "ShareInstance.h"
#import <FLAnimatedImage.h>
#import <objc/runtime.h>
#import "SubListViewController.h"
#import "AddFromAlbumCell.h"

@interface UICollectionView(MZEdit)

@property (nonatomic,assign) BOOL edit;

@end

@implementation UICollectionView (MZEdit)

-(BOOL)edit
{
    return [objc_getAssociatedObject(self, @"UICollectionViewMZEdit") boolValue];
}

-(void)setEdit:(BOOL)edit
{
    objc_setAssociatedObject(self, @"UICollectionViewMZEdit", [NSNumber numberWithBool:edit], OBJC_ASSOCIATION_ASSIGN);
    [self reloadData];
}

@end

@interface MyCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SubListCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat padding,width,height;
}

@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@property (nonatomic,strong) NSMutableArray* zipDataSource;//表情包

@property (nonatomic,strong) NSMutableArray* dataSource;//表情

@property (nonatomic,strong) NSMutableArray* myCollectionDataSource;//网页收集

@property (nonatomic,strong) NSMutableArray* myMobanDataSource;//模版

@end

@implementation MyCollectionViewController

-(instancetype)initWithType:(MyCollectionViewControllerType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.collectionView registerClass:[SearchEmotionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchEmotionCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddFromAlbumCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AddFromAlbumCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    self.dataSource = [NSMutableArray array];
    self.zipDataSource = [NSMutableArray array];
    self.myCollectionDataSource = [NSMutableArray array];
    self.myMobanDataSource = [NSMutableArray array];
    self.collectionView.backgroundColor = self.view.backgroundColor;

    width = 95;
    height = width+30;
    padding = 5;
    [self updateData];
    
    UILongPressGestureRecognizer* lp =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editAction:)];
    [self.collectionView addGestureRecognizer:lp];
}

-(void)editAction:(UILongPressGestureRecognizer*)lp
{
    if (lp.state == UIGestureRecognizerStateBegan) {
        self.collectionView.edit = !self.collectionView.edit;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


-(void)firstLoadData
{
}

-(void)firstLoadUserInterface
{

}

-(void)updateData
{
    switch (self.type) {
        case MyCollectionViewControllerTypeEmotion:
        {
            [self.dataSource removeAllObjects];
            NSMutableArray* array = [ShareInstance shareInstance].myLikeArray;
            for (NSString* str in array) {
                if ([str containsString:@","]) {
                    [self.zipDataSource insertObject:str atIndex:0];
                }else {
                    [self.dataSource insertObject:str atIndex:0];
                }
            }
            break;
        }
         
        case MyCollectionViewControllerTypeEmotionZip:
        {
            [self.zipDataSource removeAllObjects];
            NSMutableArray* array = [ShareInstance shareInstance].myLikeArray;
            for (NSString* str in array) {
                if ([str containsString:@","]) {
                    [self.zipDataSource insertObject:str atIndex:0];
                }else {
                    [self.dataSource insertObject:str atIndex:0];
                }
            }
            break;
        }
        case MyCollectionViewControllerTypeMoban:
        {
            [self.myMobanDataSource removeAllObjects];
            [self.myMobanDataSource addObjectsFromArray:[ShareInstance getAllMubanFromCollectionFolder]];
            break;
        }
        case MyCollectionViewControllerTypeCollection:
        {
            [self.myCollectionDataSource removeAllObjects];
            [self.myCollectionDataSource addObjectsFromArray:[ShareInstance getAllImageFromCollectionFolder]];
            break;
        }
        default:
            break;
    }
    [self.collectionView reloadData];
}

-(void)updateUserInterface
{
    
}


#pragma mark <UICollectionViewDataSource>


-(void)emotionTapIndexPath:(NSIndexPath*)indexPath
{
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.dataSource index:indexPath.row];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
//    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
//    self.animator.dragable = NO;
//    self.animator.direction = ZFModalTransitonDirectionBottom;
//    [self.animator setContentScrollView:detailViewController.collectionView];
//    
//    // set transition delegate of modal view controller to our object
//    detailViewController.transitioningDelegate = self.animator;
//    
//    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
//    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [ShareInstance saveToMubanFolder:UIImageJPEGRepresentation(image, 1)];
     [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [ShareInstance saveToMubanFolder:UIImageJPEGRepresentation(image, 1)];
     [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)mubanEmotionTapIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row >= self.myMobanDataSource.count) {
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        return;
    }
    
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.myMobanDataSource index:indexPath.row];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
//    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
//    self.animator.dragable = NO;
//    self.animator.direction = ZFModalTransitonDirectionBottom;
//    [self.animator setContentScrollView:detailViewController.collectionView];
//    
//    // set transition delegate of modal view controller to our object
//    detailViewController.transitioningDelegate = self.animator;
//    
//    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
//    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

-(void)collectionEmotionTapIndexPath:(NSIndexPath*)indexPath
{
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWithImageArray:self.myCollectionDataSource index:indexPath.row];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
//    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
//    self.animator.dragable = NO;
//    self.animator.direction = ZFModalTransitonDirectionBottom;
//    [self.animator setContentScrollView:detailViewController.collectionView];
//    
//    // set transition delegate of modal view controller to our object
//    detailViewController.transitioningDelegate = self.animator;
//    
//    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
//    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger i = 0;
    switch (self.type) {
        case MyCollectionViewControllerTypeEmotion:
        {
            i = self.dataSource.count;
            break;
        }
            
        case MyCollectionViewControllerTypeEmotionZip:
        {
            i = self.zipDataSource.count;
            break;
        }
        case MyCollectionViewControllerTypeMoban:
        {
            i = self.myMobanDataSource.count;
            i+=1;
            break;
        }
        case MyCollectionViewControllerTypeCollection:
        {
            i = self.myCollectionDataSource.count;
            break;
        }
        default:
            break;
    }
    
    if (i == 0) {
        self.state = BaseViewControllerSateNotLoadEmpty;
    }else {
        self.state = BaseViewControllerSateNotLoadComplete;
    }
    return i;
}

- (SubListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string;
    switch (self.type) {
        case MyCollectionViewControllerTypeEmotion:
        {
            string = self.dataSource[indexPath.row];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            NSString* headImageURL = string;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
            cell.selected = self.collectionView.edit;
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
            break;
        }
            
        case MyCollectionViewControllerTypeEmotionZip:
        {
            string = self.zipDataSource[indexPath.row];
            string = [[string componentsSeparatedByString:@","] firstObject];
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            NSString* headImageURL = string;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:ImageNamed(@"img_default")];
            cell.selected = self.collectionView.edit;
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
            break;
        }
        case MyCollectionViewControllerTypeMoban:
        {
            if (indexPath.row < self.myMobanDataSource.count) {
                string = self.myMobanDataSource[indexPath.row];
                SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
                
                NSData* data = [[NSData alloc]initWithContentsOfFile:string];
                
                FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                if (animatedImage) {
                    cell.imageView.animatedImage = animatedImage;
                }else {
                    cell.imageView.image  =[[UIImage alloc]initWithData:data];
                }
                cell.selected = self.collectionView.edit;
                cell.indexPath = indexPath;
                cell.delegate = self;
                return cell;
            }else {
                string = @"AddFromAlbumCell";
                AddFromAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
                return (id)cell;
            }
            
            
            
            break;
        }
        case MyCollectionViewControllerTypeCollection:
        {
            string = self.myCollectionDataSource[indexPath.row];
            
            SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            
            NSData* data = [[NSData alloc]initWithContentsOfFile:string];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                cell.imageView.animatedImage = animatedImage;
            }else {
                cell.imageView.image  =[[UIImage alloc]initWithData:data];
            }
            cell.indexPath = indexPath;
            cell.selected = self.collectionView.edit;
            cell.delegate = self;
            return cell;
            break;
        }
        default:
            break;
    }
    
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)SubListCollectionViewCellCloseAction:(SubListCollectionViewCell *)cell
{
    NSIndexPath* indexPath = cell.indexPath;
    switch (self.type) {
        case MyCollectionViewControllerTypeEmotion:
        {
            [[ShareInstance shareInstance].myLikeArray removeObject:self.dataSource[indexPath.row]];
            [[ShareInstance shareInstance] save];
            [self.dataSource removeObjectAtIndex:indexPath.row];
            break;
        }
            
        case MyCollectionViewControllerTypeEmotionZip:
        {
            [[ShareInstance shareInstance].myLikeArray removeObject:self.zipDataSource[indexPath.row]];
            [[ShareInstance shareInstance] save];
            [self.zipDataSource removeObjectAtIndex:indexPath.row];
            break;
        }
        case MyCollectionViewControllerTypeMoban:
        {
            [ShareInstance removeFile:self.myMobanDataSource[indexPath.row]];
            [self.myMobanDataSource removeObjectAtIndex:indexPath.row];
            break;
        }
        case MyCollectionViewControllerTypeCollection:
        {
            [ShareInstance removeFile:self.myCollectionDataSource[indexPath.row]];
            [self.myCollectionDataSource removeObjectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    [self.collectionView reloadData];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.collectionView.edit) {
        return;
    }
    
    switch (self.type) {
        case MyCollectionViewControllerTypeEmotion:
        {
            [self emotionTapIndexPath:indexPath];
            break;
        }
            
        case MyCollectionViewControllerTypeEmotionZip:
        {
            NSDictionary* dic = @{@"urls":self.zipDataSource[indexPath.row],@"title":NSLocalizedString(@"收藏的表情包", @"收藏的表情包")};
            SubListViewController* subList = [[SubListViewController alloc]init];
            subList.hidesBottomBarWhenPushed = YES;
            subList.dic = dic;
            [self.navigationController pushViewController:subList animated:YES];
            break;
        }
        case MyCollectionViewControllerTypeMoban:
        {
            [self mubanEmotionTapIndexPath:indexPath];
            break;
        }
        case MyCollectionViewControllerTypeCollection:
        {
            [self collectionEmotionTapIndexPath:indexPath];
            break;
        }
        default:
            break;
    }

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, height);
}

@end
