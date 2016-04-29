//
//  DetailCollectionViewCell.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage.h>

@interface DetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;

+(NSString*)reuseIdentifier;

@end
