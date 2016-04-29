//
//  SearchViewController.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
