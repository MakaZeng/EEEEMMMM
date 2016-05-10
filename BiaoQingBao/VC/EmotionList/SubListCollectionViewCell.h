//
//  SubListCollectionViewCell.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <Masonry.h>
#import <FLAnimatedImage.h>
#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@class SubListCollectionViewCell;

@protocol SubListCollectionViewCellDelegate <NSObject>

-(void)SubListCollectionViewCellCloseAction:(SubListCollectionViewCell*)cell;

@end

@interface SubListCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic,weak) id<SubListCollectionViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;

@end
