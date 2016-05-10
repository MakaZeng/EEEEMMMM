//
//  ImageCollectionViewCell.m
//  ExampleBIZCollectionViewLayout4plus1Grid
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "CommonHeader.h"
#import "ImageCollectionViewCell.h"


@implementation ImageCollectionViewCell


#pragma mark - Class


+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backImageView.image = ImageResizeImage(ImageNamed(@"indexListBorder"));
}

@end
