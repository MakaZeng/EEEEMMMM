//
//  FullImageViewController.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/15.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage.h>

@interface FullImageViewController : UIViewController

@property (nonatomic,strong) NSString* imgSrc;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;

@end
