//
//  MyCollectionViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    MyCollectionViewControllerTypeMoban,
    MyCollectionViewControllerTypeEmotion,
    MyCollectionViewControllerTypeEmotionZip,
    MyCollectionViewControllerTypeCollection,
} MyCollectionViewControllerType;

@interface MyCollectionViewController : BaseViewController

-(instancetype)initWithType:(MyCollectionViewControllerType)type;

@property (nonatomic,assign) MyCollectionViewControllerType type;

@property (strong, nonatomic) UICollectionView *collectionView;

@end
