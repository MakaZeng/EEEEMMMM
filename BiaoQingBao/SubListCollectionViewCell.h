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

@interface SubListCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;

@end
