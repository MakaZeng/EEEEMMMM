//
//  RssViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"

#define RssViewControllerWillDisAppear @"RssViewControllerWillDisAppear"

@interface RssViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
