//
//  IndexListViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface IndexListViewController : BaseViewController

@property (nonatomic,strong) NSDictionary* dic;

+(instancetype)instanceWithDictionary:(NSDictionary*)dic;


-(void)shouldFirstLoadWithKeyword:(NSString*)keyword;

@property (nonatomic,weak) IBOutlet UICollectionView* collectionView;

@end
