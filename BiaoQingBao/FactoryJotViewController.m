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
#import "ColorPicker.h"
#import <CMPopTipView.h>

#import "DrawPointView.h"

@interface FactoryJotViewController ()<JotViewControllerDelegate,CMPopTipViewDelegate,ColorPickerDelegate>

@property (nonatomic, strong) JotViewController *jotViewController;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *bottomImageView;
@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@property (nonatomic,strong) CMPopTipView *navBarLeftButtonPopTipView;

@property (nonatomic,assign) UIButton* colorButton;

@end

@implementation FactoryJotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    _jotViewController = [JotViewController new];
    [self.jotViewController setTextColor:[UIColor blackColor]];
    self.jotViewController.delegate = self;
    self.jotViewController.font = [UIFont systemFontOfSize:17];
    self.jotViewController.fontSize = 17;
    self.jotViewController.drawingStrokeWidth = 40.f;
    self.jotViewController.textEditingInsets = UIEdgeInsetsMake(30, 10, 10, 30);
    [self addChildViewController:self.jotViewController];
    self.jotViewController.view.autoresizesSubviews = NO;
    [self.innerView addSubview:self.jotViewController.view];
    self.jotViewController.view.backgroundColor = [UIColor clearColor];
    self.innerView.backgroundColor = [UIColor clearColor];
    [self.jotViewController didMoveToParentViewController:self];
    [self switchToTextMode];
}

-(void)tapAction
{
    [self.view endEditing:YES];
}


- (IBAction)colorAction:(id)sender {
    self.colorButton = sender;
    if (!self.navBarLeftButtonPopTipView) {
        ColorPicker* picker = [ColorPicker instanceFromNib];
        picker.delegate = self;
        [picker setBounds:CGRectMake(0, 0, 80, 80)];
        self.navBarLeftButtonPopTipView = [[CMPopTipView alloc] initWithCustomView:picker];
        self.navBarLeftButtonPopTipView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        self.navBarLeftButtonPopTipView.borderColor = [UIColor lightGrayColor];
        self.navBarLeftButtonPopTipView.delegate = self;
    }
    
    [self.navBarLeftButtonPopTipView presentPointingAtView:sender inView:self.view animated:YES];
}
static dispatch_once_t onceToken;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_once(&onceToken, ^{
        self.bottomImageView.image = self.image;
        if (self.bottomImageView.image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize size = [ShareInstance suitSizeForMaxWidth:self.innerView.bounds.size.width MaxHeight:self.innerView.bounds.size.height WithImage:self.bottomImageView.image];
                self.jotViewController.view.bounds = CGRectMake(0, 0, size.width, size.height);
                self.jotViewController.view.center = CGPointMake(self.innerView.bounds.size.width/2, self.innerView.bounds.size.height/2);
                [self.jotViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size.width);
                    make.height.mas_equalTo(size.height);
                    make.center.equalTo(self.innerView);
                }];
            });
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    onceToken = 0;
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
- (IBAction)printAction:(id)sender {
    [self.view endEditing:YES];
    UIImage* image = [self drawImage];
    self.bottomImageView.image = image;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jotViewController clearAll];
    });
}

- (IBAction)sendAction:(id)sender {
    UIImage* image = [self drawImage];
    
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWitImage:image];
    //    detailViewController.task = sender;
    // create animator object with instance of modal view controller
    // we need to keep it in property with strong reference so it will not get release
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailViewController];
    self.animator.dragable = NO;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    [self.animator setContentScrollView:detailViewController.collectionView];
    
    // set transition delegate of modal view controller to our object
    detailViewController.transitioningDelegate = self.animator;
    
    // if you modal cover all behind view controller, use UIModalPresentationFullScreen
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}



- (IBAction)valueChange:(UISegmentedControl*)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 0) {
        [self switchToTextMode];
    }else if ( index == 1 )
    {
        [self switchToDrawMode];
    }
}

-(void)buttonAction:(UIButton *)btn
{
    [self.navBarLeftButtonPopTipView dismissAnimated:YES];
    [self.colorButton setTitleColor:btn.backgroundColor forState:UIControlStateNormal];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
