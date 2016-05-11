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
#import <NKOColorPickerView.h>

@interface FactoryJotViewController ()<JotViewControllerDelegate>
{
    CGFloat lastScale;
}

@property (nonatomic,assign) BOOL lock;
@property (nonatomic, strong) JotViewController *jotViewController;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *innerView;
@property (strong, nonatomic) UIButton* cancelButton;
@property (strong, nonatomic) UIButton* saveButton;
@property (strong, nonatomic) UIButton* wipeButton;
@property (nonatomic,strong) UIButton* colorButton;
@property (strong, nonatomic) UIButton* textButton;
@property (strong, nonatomic) UIButton* sendButton;
@property (strong, nonatomic) UIButton* printButton;
@property (strong, nonatomic) UIButton* saveModelButton;
@property (strong, nonatomic) FLAnimatedImageView *bottomImageView;

@end

@implementation FactoryJotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self firstLoadUserInterface];
}

-(void)tapAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction:(id)sender {
    UIImage* image = [self drawImageScale:YES];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error) {
        [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Save To Album Success", @"保存成功")];
    }else {
        [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Save To Album Fail", @"保存失败")];
    }
}


-(void)firstLoadUserInterface
{
    [super firstLoadUserInterface];
    
    UIView* vvv = [[UIView alloc]init];
    vvv.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:vvv];
    [vvv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
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
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.sendButton];
    [self.sendButton setImage:ImageNamed(@"icon_send") forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(60);
    }];
    
    
    self.printButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.printButton];
    [self.printButton setImage:ImageNamed(@"icon_print") forState:UIControlStateNormal];
    [self.printButton addTarget:self action:@selector(printAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.printButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(60);
    }];
    [ShareInstance showTips:NSLocalizedString(@"Snapshot Current", @"") onView:self.printButton];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.saveButton];
    [self.saveButton setImage:ImageNamed(@"icon_save") forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.saveModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.saveModelButton];
    [self.saveModelButton setImage:ImageNamed(@"icon_templet") forState:UIControlStateNormal];
    [self.saveModelButton addTarget:self action:@selector(saveMuban:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(65);
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(60);
    }];
    [ShareInstance showTips:NSLocalizedString(@"Save As Templet", @"") onView:self.saveModelButton];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.cancelButton];
    [self.cancelButton setImage:ImageNamed(@"imag_back") forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.textButton];
    [self.textButton setImage:ImageNamed(@"icon_text") forState:UIControlStateNormal];
    [self.textButton setImage:ImageNamed(@"icon_text_selected") forState:UIControlStateSelected];
    [self.textButton addTarget:self action:@selector(switchToTextMode) forControlEvents:UIControlEventTouchUpInside];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.wipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.wipeButton];
    [self.wipeButton setImage:ImageNamed(@"icon_brush") forState:UIControlStateNormal];
    [self.wipeButton setImage:ImageNamed(@"icon_brush_selected") forState:UIControlStateSelected];
    [self.wipeButton addTarget:self action:@selector(switchToDrawMode) forControlEvents:UIControlEventTouchUpInside];
    [self.wipeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-65);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorButton.layer.cornerRadius = 11;
    self.colorButton.clipsToBounds = YES;
    self.colorButton.layer.borderColor = [UIColor brownColor].CGColor;
    self.colorButton.layer.borderWidth = 1;
    self.colorButton.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:self.colorButton];
    [self.colorButton addTarget:self action:@selector(colorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-115);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(22);
    }];

    self.bottomImageView = [[FLAnimatedImageView alloc]init];
    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    self.innerView = [[UIView alloc]init];
    self.innerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.innerView];
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    self.innerView = [[UIView alloc]init];
    self.innerView.backgroundColor = [UIColor clearColor];
    self.innerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:self.innerView];
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    _jotViewController = [JotViewController new];
    [self.jotViewController setTextColor:[UIColor blackColor]];
    self.jotViewController.delegate = self;
    self.jotViewController.font = [UIFont systemFontOfSize:17];
    self.jotViewController.fontSize = 17;
    self.jotViewController.drawingStrokeWidth = 17.f;
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

-(void)colorAction
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIImage *viewImage = [self captureImageFromViewLow:screenWindow];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.layer.borderColor = [UIColor redColor].CGColor;
    imageView.layer.borderWidth = 2;
    imageView.backgroundColor = LightDarkColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    imageView.image = viewImage;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseColor:)];
    [imageView addGestureRecognizer:tap];
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Tap To Choose Target Color", @"Tap To Choose Target Color")];
}

-(void)chooseColor:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (id)tap.view;
    UIImage* image = imageView.image;
    CGPoint p = [tap locationInView:imageView];
    p.x = p.x*[UIScreen mainScreen].scale;
    p.y = p.y*[UIScreen mainScreen].scale;
    UIColor* color = [self getPixelColorAtLocation:p image:image];
    self.colorButton.backgroundColor = color;
    [imageView removeFromSuperview];
    if (self.jotViewController.state == JotViewStateText) {
        self.jotViewController.textColor = color;
    }else if (self.jotViewController.state == JotViewStateDrawing) {
        self.jotViewController.drawingColor = color;
    }
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point image:(UIImage*)image{
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

- (void)switchToDrawMode
{
    self.wipeButton.selected = YES;
    self.textButton.selected = NO;
    self.jotViewController.state = JotViewStateDrawing;
}

- (void)switchToTextMode
{
    self.wipeButton.selected = NO;
    self.textButton.selected = YES;
    self.jotViewController.state = JotViewStateText;
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

- (void)saveMuban:(UIButton*)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Save As Templet Success", @"保存模板成功")];
    UIImage* image = [self drawImageScale:YES];
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

- (void)printAction:(UIButton*)sender {
    
    [self switchToDrawMode];
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Snapshot Success", @"保存当前状态成功")];
    
    UIImage* image = [self drawImageScale:NO];
    self.bottomImageView.image = image;
    self.jotViewController.view.transform=CGAffineTransformIdentity;
    self.bottomImageView.transform=CGAffineTransformIdentity;
    if (self.bottomImageView.image) {
        CGSize size = [ShareInstance suitSizeForMaxWidth:self.innerView.bounds.size.width MaxHeight:self.innerView.bounds.size.height WithImage:self.bottomImageView.image];
        if (size.width < self.innerView.bounds.size.width-10 && size.height < self.innerView.bounds.size.height-10) {
            self.bottomImageView.contentMode = UIViewContentModeCenter;
        }else {
            self.bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        self.jotViewController.view.bounds = CGRectMake(0, 0, size.width, size.height);
        self.jotViewController.view.center = CGPointMake(self.innerView.bounds.size.width/2, self.innerView.bounds.size.height/2);
        [self.jotViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
            make.center.equalTo(self.innerView);
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jotViewController clearAll];
    });
    
    [ShareInstance whiteScreen];
}

- (void)sendAction:(id)sender {
    UIImage* image = [self drawImageScale:YES];
    ListDetailViewController *detailViewController = [[ListDetailViewController alloc]initWitImage:image];
    [self presentViewController:detailViewController animated:YES completion:nil];
}


-(UIImage*)drawImageScale:(BOOL)isScale
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIImage *viewImage = [self captureImageFromViewLow:screenWindow];
    CGRect frame = self.jotViewController.view.frame;
    CGRect rect = [screenWindow convertRect:frame fromView:self.innerView];
    rect.origin = CGPointMake(rect.origin.x*[UIScreen mainScreen].scale, rect.origin.y*[UIScreen mainScreen].scale);
    rect.size = CGSizeMake(rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale);
    viewImage = [self getPartOfImage:viewImage rect:rect];
    viewImage = [ShareInstance scaleImageWithScale:1.0/[UIScreen mainScreen].scale image:viewImage];
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
