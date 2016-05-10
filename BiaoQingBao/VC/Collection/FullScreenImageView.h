//
//  FullScreenImageView.h
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/28.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface FullScreenImageView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) FLAnimatedImageView* imageView;


+(void)showWithData:(NSData*)data;

+(void)showWithImageURL:(NSString*)imageURL;

@end
