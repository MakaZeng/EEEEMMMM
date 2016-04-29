//
//  SearchIndexViewController.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/18.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchIndexViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UISearchBar *mkSearchBar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
