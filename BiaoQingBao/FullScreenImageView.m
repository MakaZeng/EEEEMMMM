//
//  FullScreenImageView.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/28.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "ShareInstance.h"
#import <Masonry.h>
#import <SDWebImage/SDImageCache.h>
#import "FullScreenImageView.h"

@implementation FullScreenImageView

+(void)showWithImageURL:(NSString *)imageURL
{
    FullScreenImageView* v = [FullScreenImageView new];
    NSData* data;
    if ([imageURL hasPrefix:@"http://"]) {
        NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:imageURL];
        data = [[NSData alloc]initWithContentsOfFile:path];
    }else {
        data = [[NSData alloc]initWithContentsOfFile:imageURL];
    }
    
    FLAnimatedImage* image = [FLAnimatedImage animatedImageWithGIFData:data];
    if (image) {
        v.imageView.animatedImage = image;
    }else {
        v.imageView.image = [[UIImage alloc]initWithData:data];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        UIView* b = [[UIView alloc]init];
        b.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIScrollView* s = [[UIScrollView alloc]init];
        s.maximumZoomScale = 10;
        s.minimumZoomScale = 0.1;
        s.delegate = self;
        [self addSubview:s];
        [s mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        FLAnimatedImageView* imageView = [[FLAnimatedImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [s addSubview:imageView];
        self.imageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.width.height.equalTo(s);
        }];
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

-(void)tapAction
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

+(void)showWithData:(NSData *)data
{
    FullScreenImageView* v = [FullScreenImageView new];
    
    FLAnimatedImage* image = [FLAnimatedImage animatedImageWithGIFData:data];
    if (image) {
        v.imageView.animatedImage = image;
    }else {
        v.imageView.image = [[UIImage alloc]initWithData:data];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end

