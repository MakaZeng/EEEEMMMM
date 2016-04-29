//
//  SubListViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "BaseViewController.h"

@interface SubListViewController : BaseViewController

@property (nonatomic,strong) NSDictionary* dic;

@property (nonatomic,weak) IBOutlet UICollectionView* collectionView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
