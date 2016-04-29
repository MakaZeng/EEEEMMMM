//
//  TOWebViewController+QRCodeHelper.m
//  QRCodeDemo
//
//  Created by 好迪 on 16/3/23.
//  Copyright © 2016年 好迪. All rights reserved.
//

#import "TOWebViewController+QRCodeHelper.h"
#import "RNCachingURLProtocol.h"
#import <objc/runtime.h>
#import "ListDetailViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import <ZFModalTransitionAnimator.h>
#import <FLAnimatedImage.h>
#import "ShareInstance.h"

//要注入的 js 代码
static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

static NSString *const kGestrueState     = @"keyForGestrueState";
static NSString *const kImageUrl         = @"keyForImageUrl";
static NSString *const kLongGestureTimer = @"keyForLongGestureTimer";
static NSString *const kData             = @"keyForData";

static NSString *const ActionSheetSave = @"保存到相册";
static NSString *const ActionSheetCollect = @"收藏图片";
static NSString *const ActionSheetShare = @"分享图片";

static const NSTimeInterval longGestureInterval = 1.0f;

enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};

@interface TOWebViewController ()

@property (nonatomic,strong) ZFModalTransitionAnimator* animator;

@end


@implementation TOWebViewController (QRCodeHelper)

static const void* TOWebViewControllerAnimator = &TOWebViewControllerAnimator;

-(ZFModalTransitionAnimator*)animator
{
    return objc_getAssociatedObject(self, TOWebViewControllerAnimator);
}

-(void)setAnimator:(ZFModalTransitionAnimator *)animator
{
    objc_setAssociatedObject(self, TOWebViewControllerAnimator, animator, OBJC_ASSOCIATION_RETAIN);
}


// why 会加载load
+(void)load{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self towebviewHook];
    });
}

+ (void)towebviewHook{
    ADSwizzlingMethod([self class], @selector(webView:shouldStartLoadWithRequest:navigationType:), @selector(ad_webView:shouldStartLoadWithRequest:navigationType:));
    ADSwizzlingMethod([self class], @selector(webViewDidFinishLoad:), @selector(ad_webViewDidFinishLoad:));
//    ADSwizzlingMethod([self class], @selector(webViewDidStartLoad:), @selector(ad_webViewDidStartLoad:));
}

#pragma mark - seter and getter
- (void)setGesState:(int)gesState{
    objc_setAssociatedObject(self, &kGestrueState, @(gesState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)gesState{
    return [objc_getAssociatedObject(self, &kGestrueState) intValue];
}

- (void)setImgURL:(NSString *)imgURL{
    objc_setAssociatedObject(self, &kImageUrl, imgURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imgURL{
    return objc_getAssociatedObject(self, &kImageUrl);
}

- (void)setTimer:(NSTimer *)timer{
    objc_setAssociatedObject(self, &kLongGestureTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer{
    return objc_getAssociatedObject(self, &kLongGestureTimer);
}

- (void)setData:(id)data{
    objc_setAssociatedObject(self, &kData, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)data{
    return objc_getAssociatedObject(self, &kData);
}

#pragma mark - private Method
- (void)handleLongTouch {

    NSString *imageUrl = [self.webView stringByEvaluatingJavaScriptFromString:self.imgURL];
    if (imageUrl && self.gesState == GESTURE_STATE_START) {
        NSData* data = nil;
        NSString *fileName = [RNCachingURLProtocol cachePathForURLString:imageUrl];
        
        RNCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];

        if (cache !=nil) {
            data = cache.data;
        }
        else{
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        }
        
        
        UIImage* image = [UIImage imageWithData:data];
        if (image == nil) {
            return;
        }
        self.data = data;
        
        //用获取的图片 去识别二维码
        self.gesState = GESTURE_STATE_END;
        UIActionSheet* sheet ;
        {
            sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:ActionSheetShare,ActionSheetCollect,ActionSheetSave, nil];
        }
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (BOOL)isAvailableQRcodeIn:(UIImage *)img{
    UIImage *image = img;
    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image.CGImage];
    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    NSError *error = nil;
    ZXQRCodeMultiReader * reader2 = [[ZXQRCodeMultiReader alloc]init];
//    NSArray *rs = [reader2 decodeMultiple:bitmap error:&error];
    NSArray *rs =[reader2 decodeMultiple:bitmap hints:hints error:&error];
    for (ZXResult *resul in rs) {
        return YES;
    }
    return NO;
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='text';"];
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ActionSheetShare]) {
        
        ListDetailViewController *detailViewController;
        //    detailViewController.task = sender;
        
        FLAnimatedImage* animatedImage = [[FLAnimatedImage alloc]initWithAnimatedGIFData:self.data];
        if (!animatedImage) {
            UIImage* image = [[UIImage alloc]initWithData:self.data];
            detailViewController = [[ListDetailViewController alloc]initWitImage:image];
        }else {
            detailViewController = [[ListDetailViewController alloc]initWitImage:(id)animatedImage];
        }
        
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
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ActionSheetSave]){
        UIImage* image = [[UIImage alloc]initWithData:self.data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ActionSheetCollect]){
        [ShareInstance saveToCollectionFolder:self.data];
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error) {
        [ShareInstance statusBarToastWithMessage:@"保存成功"];
    }else {
        [ShareInstance statusBarToastWithMessage:@"保存失败"];
    }
}

#pragma mark - swizing
- (void)ad_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (BOOL)ad_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                self.gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                self.imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    self.imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
                }
                if (self.imgURL) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:longGestureInterval target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                self.gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
            
        }
        
        if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [self.timer invalidate];
            self.timer = nil;
            self.gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        
        if (self.imgURL && self.gesState == GESTURE_STATE_END) {
            NSLog(@"点的是图片");
        }
        
        return NO;
    }
//    return YES;
    return [self ad_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)ad_webViewDidStartLoad:(UIWebView *)webView{
    [self ad_webViewDidStartLoad:webView];
}

- (void)ad_webViewDidFinishLoad:(UIWebView *)webView{
    //控制缓存
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];

    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];

    [self ad_webViewDidFinishLoad:webView];
}



@end
