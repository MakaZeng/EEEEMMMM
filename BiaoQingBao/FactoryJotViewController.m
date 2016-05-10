//
//  JotViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/11.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <jot/jot.h>
#import <Masonry.h>
#import "ShareInstance.h"
#import <FLAnimatedImage.h>
#import "FactoryJotViewController.h"
#import "ListDetailViewController.h"
#import <ZFModalTransitionAnimator.h>
#import <CMPopTipView.h>

@interface FactoryJotViewController ()<JotViewControllerDelegate,CMPopTipViewDelegate>
{
    CGFloat lastScale;
}

@property (nonatomic,assign) BOOL lock;
@property (nonatomic, strong) JotViewController *jotViewController;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *innerView;
@property (strong, nonatomic) FLAnimatedImageView *bottomImageView;

@end

@implementation FactoryJotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    [super firstLoadUserInterface];
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    _jotViewController = [JotViewController new];
    [self.jotViewController setTextColor:[UIColor blackColor]];
    self.jotViewController.delegate = self;
    self.jotViewController.font = [UIFont systemFontOfSize:17];
    self.jotViewController.fontSize = 17;
    self.jotViewController.drawingStrokeWidth = 20.f;
    self.jotViewController.textEditingInsets = UIEdgeInsetsMake(30, 10, 10, 30);
    self.jotViewController.drawingColor = [UIColor whiteColor];
    [self addChildViewController:self.jotViewController];
    self.jotViewController.view.autoresizesSubviews = NO;
    [self.innerView addSubview:self.jotViewController.view];
    self.jotViewController.view.backgroundColor = [UIColor clearColor];
    self.innerView.backgroundColor = [UIColor clearColor];
    [self.jotViewController didMoveToParentViewController:self];
    [self switchToDrawMode];
    lastScale = 1;
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [self.innerView addGestureRecognizer:pinch];
}

-(void)pinchAction:(UIPinchGestureRecognizer*)recognizer
{
    if (self.bottomImageView.contentMode != UIViewContentModeCenter || self.jotViewController.state != JotViewStateDrawing) {
        return;
    }
    recognizer.scale=recognizer.scale-lastScale+1;
    self.jotViewController.view.transform=CGAffineTransformScale(self.jotViewController.view.transform, recognizer.scale,recognizer.scale);
    self.bottomImageView.transform=CGAffineTransformScale(self.bottomImageView.transform, recognizer.scale,recognizer.scale);
    lastScale=recognizer.scale;
}

-(void)tapAction
{
    [self.view endEditing:YES];
}

- (IBAction)saeMuban:(UIButton*)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"保存模板成功", @"保存模板成功")];
    UIImage* image = [self drawImage];
    [ShareInstance saveToMubanFolder:UIImageJPEGRepresentation(image, 1)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCollectionViewController" object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.lock) {
        self.bottomImageView.image = self.image;
        if (self.bottomImageView.image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize size = [ShareInstance suitSizeForMaxWidth:self.innerView.bounds.size.width MaxHeight:self.innerView.bounds.size.height WithImage:self.bottomImageView.image];
                if (size.width < self.innerView.bounds.size.width-10 && size.height < self.innerView.bounds.size.height-10) {
                    self.bottomImageView.contentMode = UIViewContentModeCenter;
                }else {
                    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
                }
                self.jotViewController.view.bounds = CGRectMake(0, 0, size.width, size.height);
                self.jotViewController.view.center = CGPointMake(self.innerView.bounds.size.width/2, self.innerView.bounds.size.height/2);
                [self.jotViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size.width);
                    make.height.mas_equalTo(size.height);
                    make.center.equalTo(self.innerView);
                }];
            });
        }
        self.lock = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clearAction:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 0) {
        [self.jotViewController clearText];
    }else {
        [self.jotViewController clearDrawing];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.selectedSegmentIndex = -1;
    });
}
- (IBAction)printAction:(UIButton*)sender {
    
    [self switchToDrawMode];
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"保存当前状态成功", @"保存当前状态成功")];
    
    UIImage* image = [self drawImage];
    self.bottomImageView.image = image;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jotViewController clearAll];
    });
}

- (IBAction)sendAction:(id)sender {
    UIImage* image = [self drawImage];
    
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWitImage:image];
    [self presentViewController:detailViewController animated:YES completion:nil];
}



- (IBAction)valueChange:(UISegmentedControl*)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 1) {
        [self switchToTextMode];
    }else if ( index == 0)
    {
        [self switchToDrawMode];
    }
}

-(void)buttonAction:(UIButton *)btn
{
    [self.jotViewController setDrawingColor:btn.backgroundColor];
    [self.jotViewController setTextColor:btn.backgroundColor];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}

- (void)switchToDrawMode
{
    self.jotViewController.state = JotViewStateDrawing;
}

- (void)switchToTextMode
{
    self.jotViewController.state = JotViewStateText;
}

- (void)switchToTextEditMode
{
    self.jotViewController.state = JotViewStateEditingText;
}

-(UIImage*)drawImage
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIImage *viewImage = [self captureImageFromViewLow:screenWindow];
    CGRect rect = [screenWindow convertRect:self.jotViewController.view.frame fromView:self.innerView];
    rect.origin = CGPointMake(rect.origin.x*[UIScreen mainScreen].scale, rect.origin.y*[UIScreen mainScreen].scale);
    rect.size = CGSizeMake(rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale);
    viewImage = [self getPartOfImage:viewImage rect:rect];
    
    return viewImage;
}

-(UIImage *)captureImageFromViewLow:(UIView *)orgView {
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// get part of the image
- (UIImage *)getPartOfImage:(UIImage *)img rect:(CGRect)partRect
{
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}

@end
