//
//  ImageCollectionViewCell.h
//  ExampleBIZCollectionViewLayout4plus1Grid
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage.h>

@interface ImageCollectionViewCell : UICollectionViewCell
+ (NSString *)reuseIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
