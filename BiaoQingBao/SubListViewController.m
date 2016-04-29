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

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@end

@implementation SubListViewController

- (IBAction)backAction:(id)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self firstLoadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationController) {
        self.backButton.hidden = NO;
        self.likeButton.hidden = NO;
        Layer_View(self.backButton);
        Layer_View(self.likeButton);
    }else {
        self.backButton.hidden = YES;
        self.likeButton.hidden = YES;
    }
}

- (IBAction)likeAction:(UIButton*)sender {
    if (sender.isSelected) {
        [self deselectLike];
    }else{
        [self rightItemAction];
    }
    self.likeButton.selected = !self.likeButton.isSelected;
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
    width = 95;
    height = width;
    padding = 5;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    if ([[ShareInstance shareInstance].myLikeArray containsObject:NSDictionary_String_ForKey(self.dic, @"urls")]) {
        self.likeButton.selected = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_selected") style:UIBarButtonItemStyleBordered target:self action:@selector(deselectLike)];
    }else {
        self.likeButton.selected = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_normal") style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemAction)];
    }
    [self.collectionView reloadData];
}

-(void)rightItemAction
{
    [[ShareInstance shareInstance].myLikeArray addObject:NSDictionary_String_ForKey(self.dic, @"urls")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_selected") style:UIBarButtonItemStyleBordered target:self action:@selector(deselectLike)];
}
-(void)deselectLike
{
    [[ShareInstance shareInstance].myLikeArray removeObject:NSDictionary_String_ForKey(self.dic, @"urls")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"like_normal") style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemAction)];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}

#pragma mark <UICollectionViewDataSource>

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ListDetailViewController *detailViewController = segue.destinationViewController;
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
}


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

@end
