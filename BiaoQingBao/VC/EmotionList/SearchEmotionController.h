//
//  SearchEmotionController.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/22.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchEmotionController : BaseViewController<UISearchBarDelegate>

@property (strong, nonatomic)  UISearchBar *searchBar;
@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic)  UICollectionView *collectionView;

@end
