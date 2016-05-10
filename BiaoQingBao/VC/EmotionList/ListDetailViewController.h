//
//  ListDetailViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"
#import <FLAnimatedImage.h>

@interface ListDetailViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

-(instancetype)initWitImage:(UIImage*)image;

-(instancetype)initWithImageArray:(NSArray*)array index:(NSInteger)index;

@property (strong, nonatomic)   UIView *topView;
@property (strong, nonatomic)   UIView *bottomView;
@property (nonatomic,strong) UILabel* titleLabel;

@property (nonatomic,strong) UIButton* cancelButton;
@property (strong, nonatomic)   UIButton *likeButton;
@property (strong, nonatomic)   UIButton *editButton;
@property (strong, nonatomic)   UIButton *saveButton;
@property (strong, nonatomic)   UIButton *fullscreen;
@property (strong, nonatomic)   UICollectionView *collectionView;

@end
