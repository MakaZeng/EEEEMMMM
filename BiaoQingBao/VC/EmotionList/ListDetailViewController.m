//
//  ListDetailViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/10.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ListDetailViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "ServiceManager.h"
#import "SubListCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "FactoryJotViewController.h"
#import "CommonHeader.h"
#import "MakaShareUtil.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "ShareInstance.h"
#import <ReactiveCocoa.h>
#import "FullScreenImageView.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

#define FirstShowGifSendToTimeLine @"FirstShowGifSendToTimeLine"

@interface ListDetailViewController ()<ShareUtilDelegate,UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController* _documentInteractionController;
}

@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSArray* imageArray;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) BOOL isLoadComplete;

@end

@implementation ListDetailViewController

-(instancetype)initWitImage:(UIImage *)image
{
    ListDetailViewController* vc =  [[ListDetailViewController alloc]init];
    vc.image = image;
    return vc;
}

-(instancetype)initWithImageArray:(NSArray *)array index:(NSInteger)index
{
    ListDetailViewController* vc =  [[ListDetailViewController alloc]init];
    vc.index = index;
    vc.imageArray = array;
    return vc;
}

- (void)tapAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveAction:(id)sender {
    id o = [self.dataSource objectAtIndex:self.currentIndex];
    UIImage* image = nil;
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        image = [[UIImage alloc]initWithData:[o data]];
    }else if ([o isKindOfClass:[NSString class]]){
        if ([o isKindOfClass:[NSString class]]) {
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                NSData* data = [[NSData alloc]initWithContentsOfFile:path];
                image = [[UIImage alloc]initWithData:data];
            }else {
                NSData* data = [[NSData alloc]initWithContentsOfFile:o];
                image = [[UIImage alloc]initWithData:data];
            }
        }
        
    }else if ([o isKindOfClass:[UIImage class]]) {
        image = o;
    }else if (MAKA_isDicionary(o)) {
        o = NSDictionary_String_ForKey(o, @"url");
        if ([o isKindOfClass:[NSString class]]) {
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                NSData* data = [[NSData alloc]initWithContentsOfFile:path];
                image = [[UIImage alloc]initWithData:data];
            }else {
                NSData* data = [[NSData alloc]initWithContentsOfFile:o];
                image = [[UIImage alloc]initWithData:data];
            }
        }
    }
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error) {
        [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Save Success", @"保存成功")];
    }else {
        [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Save Fail", @"保存失败")];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    if (self.imageArray) {
        [self.dataSource addObjectsFromArray:self.imageArray];
    }else {
        if (self.image) {
            [self.dataSource addObject:self.image];
        }
    }
    [self firstLoadUserInterface];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.currentIndex, 0)];
}

-(void)firstLoadUserInterface
{
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(70, 10, 80, 10));
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubListCollectionViewCell"];
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.cancelButton];
    [self.cancelButton setImage:ImageNamed(@"imag_back") forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.saveButton];
    [self.saveButton setImage:ImageNamed(@"icon_save") forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(65);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.likeButton];
    [self.likeButton setImage:ImageNamed(@"like_normal") forState:UIControlStateNormal];
    [self.likeButton setImage:ImageNamed(@"like_selected") forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.fullscreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.fullscreen];
    [self.fullscreen setImage:ImageNamed(@"fullscreen_icon") forState:UIControlStateNormal];
    [self.fullscreen addTarget:self action:@selector(fullscreenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-65);
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(40);
    }];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.editButton];
    [self.editButton setImage:ImageNamed(@"img_fire") forState:UIControlStateNormal];
    self.editButton.layer.cornerRadius = 25;
    self.editButton.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.5];
    [self.editButton addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.collectionView).offset(-5);
        make.width.height.mas_equalTo(50);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = BASE_Tint_COLOR;
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.topView);
    }];
    
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    NSString* l = CurrentLanguage;
    UIView* shareView = nil;
    
    NSMutableArray* items = [ShareInstance shareInstance].shareItems;
    
    if (items.count == 0) {
        if ([l hasPrefix:@"zh-Han"]) {
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechat]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeQQ]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatSession]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeLine]];
        }else if ([l hasPrefix:@"ja"]) {
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeLine]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeFacebook]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWhatsApp]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechat]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
        }else if ([l hasPrefix:@"ko"]) {
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeLine]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeFacebook]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWhatsApp]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechat]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
        }else if ([l hasPrefix:@"id"]) {
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeFacebook]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWhatsApp]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeLine]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechat]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
        }else{
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeFacebook]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWhatsApp]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeLine]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechat]];
            [items addObject:[NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
        }
        
        [[ShareInstance shareInstance] save];
    }
    
    shareView = [MakaShareUtil instanceViewForItems:items delegate:self];
    
    
    [self.bottomView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.equalTo(self.bottomView);
        make.height.mas_equalTo(60);
    }];
    
    [self.collectionView reloadData];
}

- (void)selectAction:(id)sender {
    self.likeButton.selected = !self.likeButton.isSelected;
    
    id o = [self.dataSource objectAtIndex:self.currentIndex];
    
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        
    }else if ([o isKindOfClass:[NSString class]]){
        if ([o hasPrefix:@"http://"]) {
            if (self.likeButton.selected) {
                [[ShareInstance shareInstance].myLikeArray addObject:o];
            }else {
                [[ShareInstance shareInstance].myLikeArray removeObject:o];
            }
        }
    }else if ([o isKindOfClass:[UIImage class]]) {
        
    }else if (MAKA_isDicionary(o)) {
        if (self.likeButton.selected) {
            [[ShareInstance shareInstance].myLikeArray addObject:NSDictionary_String_ForKey(o, @"url")];
        }else {
            [[ShareInstance shareInstance].myLikeArray removeObject:NSDictionary_String_ForKey(o, @"url")];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ShareInstance shareInstance] save];
}


-(void)buttonAction:(UIButton*)btn
{
    NSInteger i = btn.tag - BEGIN_TAG;
    NSArray* arr = [ShareInstance shareInstance].shareItems;
    ShareUtilType type = [NSArray_ObjectAt_Index(arr, i) integerValue];
    [self ShareUtil:nil selectedType:type];
}

-(void)ShareUtil:(MakaShareUtil *)util selectedType:(ShareUtilType)type
{
    id o = [self.dataSource objectAtIndex:self.currentIndex];
    
    if ([o isKindOfClass:[NSDictionary class]]) {
        o = [o objectForKey:@"url"];
    }
    
    switch (type) {
        case ShareUtilTypeQQ:
        {
            [self sendToWhatsApp:o];
//            [self sendToQQ:o];
            return;
        }
        case ShareUtilTypeWechat:
        {
            [self sendToWechat:WXSceneSession obj:o];
            return;
        }
        case ShareUtilTypeWechatSession:
        {
            [self sendToWechat:WXSceneTimeline obj:o];
            return;
        }
        case ShareUtilTypeWechatCollection:
        {
            [self sendToWechat:WXSceneFavorite obj:o];
            return;
        }
        case ShareUtilTypeWhatsApp:
        {
            [self sendToWhatsApp:o];
            return;
        }
        default:
            break;
    }
}


-(void)sendToFacebook:(id)obj
{
    {
        NSData* data = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:obj];
            }
        }else if ([obj isKindOfClass:[FLAnimatedImage class]]) {
            data = ((FLAnimatedImage*)obj).data;
        }else if ([obj isKindOfClass:[UIImage class]]) {
            data = UIImageJPEGRepresentation(obj, 1);
        }
        
        FLAnimatedImage* gif = [[FLAnimatedImage alloc]initWithAnimatedGIFData:data];
        if (gif) {
            [FBSDKMessengerSharer shareAnimatedGIF:data withOptions:nil];
        }else {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [FBSDKMessengerSharer shareImage:image withOptions:nil];
        }
    }
}

-(void)sendToQQ:(id)obj
{
    {
        NSData* data = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:obj];
            }
        }else if ([obj isKindOfClass:[FLAnimatedImage class]]) {
            data = ((FLAnimatedImage*)obj).data;
        }else if ([obj isKindOfClass:[UIImage class]]) {
            data = UIImageJPEGRepresentation(obj, 1);
        }
        
        
        QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:@" " description:@" "];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }

}

-(void)sendToLine:(id)obj
{
    NSData* data = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj hasPrefix:@"http://"]) {
            NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
            data = [[NSData alloc]initWithContentsOfFile:path];
        }else {
            data = [[NSData alloc]initWithContentsOfFile:obj];
        }
    }else if ([obj isKindOfClass:[FLAnimatedImage class]]) {
        data = ((FLAnimatedImage*)obj).data;
    }else if ([obj isKindOfClass:[UIImage class]]) {
        data = UIImageJPEGRepresentation(obj, 1);
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]]) {
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
        NSString *pasteboardName = pasteboard.name;
        
        FLAnimatedImage* gif =  [FLAnimatedImage animatedImageWithGIFData:data];
        if (gif) {
            [pasteboard setData:data forPasteboardType:@"public.gif"];
        }else {
            [pasteboard setData:data forPasteboardType:@"public.png"];
        }
        
        NSString *contentType = @"image";
        NSString *contentKey = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                    (CFStringRef)pasteboardName,
                                                                                                    NULL,
                                                                                                    CFSTR(":/?=,!$&'()*+;[]@#"),
                                                                                                    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",
                               contentType, contentKey];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


-(void)sendToWhatsApp:(id)obj
{
    NSData* data = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj hasPrefix:@"http://"]) {
            NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
            data = [[NSData alloc]initWithContentsOfFile:path];
        }else {
            data = [[NSData alloc]initWithContentsOfFile:obj];
        }
    }else if ([obj isKindOfClass:[FLAnimatedImage class]]) {
        data = ((FLAnimatedImage*)obj).data;
    }else if ([obj isKindOfClass:[UIImage class]]) {
        data = UIImageJPEGRepresentation(obj, 1);
    }
    
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
        NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
        
        [data writeToFile:savePath atomically:YES];
        
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        _documentInteractionController.UTI = @"net.whatsapp.image";
        _documentInteractionController.delegate = self;
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)sendToWechat:(int)scene obj:(id)obj
{
    UIImage* image = nil;
    NSData* data = nil;
    if ([obj isKindOfClass:[UIImage class]]) {
        image = obj;
        data = UIImageJPEGRepresentation(obj, 1);
    }else if([obj isKindOfClass:[NSString class]]) {
        if ([obj hasPrefix:@"http://"]) {
            NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:obj];
            data = [[NSData alloc]initWithContentsOfFile:path];
        }else {
            data = [[NSData alloc]initWithContentsOfFile:obj];
        }
    }else if ([obj isKindOfClass:[FLAnimatedImage class]]){
        data = [obj data];
    }else if ([obj isKindOfClass:[NSData class]]) {
        data = obj;
    }else {
        return;
    }

    UIImage* sourceImage = [[UIImage alloc] initWithData:data];
    NSData* thumbData = UIImageJPEGRepresentation([MakaShareUtil thumbnailWithImageWithoutScale:sourceImage size:CGSizeMake(80, (80/(sourceImage.size.width/sourceImage.size.height)))], 1) ;
    
    WXMediaMessage* message = [WXMediaMessage message];
    [message setThumbData:thumbData];
    
    FLAnimatedImage* animateImage = [[FLAnimatedImage alloc]initWithAnimatedGIFData:data];
    if (animateImage && scene != WXSceneSession) {
        WXImageObject* obj = [WXImageObject object];
        obj.imageData = data;
        message.mediaObject = obj;
        [self showSendTimeLineWarnning:^(BOOL shouldSend) {
            if (shouldSend) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = scene;
                [WXApi sendReq:req];
            }
        }];
        return;
    }else {
        if (!animateImage && scene != WXSceneSession) {
            WXImageObject* obj = [WXImageObject object];
            obj.imageData = data;
            message.mediaObject = obj;
        }else {
            WXEmoticonObject* obj = [WXEmoticonObject object];
            obj.emoticonData = data;
            message.mediaObject = obj;
        }
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

-(void)showSendTimeLineWarnning:(void (^)(BOOL shouldSend))block
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FirstShowGifSendToTimeLine]) {
        block(YES);
        return;
    }
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(NSLocalizedString(@"continue", @"继续发送"), ^{
        block(YES);
    });
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Warning)
    .title(NSLocalizedString(@"Notice(Last Time)", @"注意(只会显示一次)"))
    .subTitle(NSLocalizedString(@"Cannot Send Animated Image To Wechat TimeLine And Wechat Collection , This Image Will Convert To Static", @"由于微信限制,动态图发送到朋友圈和收藏时,会自动变成静态图,是否继续发送?"))
    .duration(0);
    
    [builder.alertView addButton:NSLocalizedString(@"Cancel", @"取消发送") actionBlock:^{
        block(NO);
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, [UIApplication sharedApplication].keyWindow.rootViewController);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FirstShowGifSendToTimeLine];
}



#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        if (!self.isLoadComplete) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.index, 0)];
            self.currentIndex = self.index;
            self.isLoadComplete = YES;
        }
    }
    return self.dataSource.count;
}

- (SubListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SubListCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    id obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[FLAnimatedImage class]]) {
        cell.imageView.animatedImage = self.dataSource[indexPath.row];
    }else if ([obj isKindOfClass:[NSString class]]){
        if ([obj hasPrefix:@"http://"]) {
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:ImageNamed(@"img_default")];
        }else {
            NSData* data = [[NSData alloc]initWithContentsOfFile:obj];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                cell.imageView.animatedImage = animatedImage;
            }else {
                cell.imageView.image  =[[UIImage alloc]initWithData:data];
            }
        }
    }else if ([obj isKindOfClass:[UIImage class]]) {
        cell.imageView.image = obj;
        CGSize size = [ShareInstance suitSizeForMaxWidth:self.collectionView.bounds.size.width MaxHeight:self.collectionView.bounds.size.height WithImage:cell.imageView.image];
        if (size.width < self.collectionView.bounds.size.width-10 && size.height < self.collectionView.bounds.size.height-10) {
            cell.imageView.contentMode = UIViewContentModeCenter;
        }else {
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }else if (MAKA_isDicionary(obj)) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(obj, @"url")] placeholderImage:ImageNamed(@"img_default")];
    }
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)scrollView.contentOffset.x/(NSInteger)scrollView.bounds.size.width;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",page+1,(unsigned long)self.dataSource.count];
    NSInteger i = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.currentIndex = i;
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0 || currentIndex >self.dataSource.count) {
        return;
    }
    _currentIndex = currentIndex;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.dataSource.count];
    
    self.likeButton.hidden = YES;
    
    id o = NSArray_ObjectAt_Index(self.dataSource, currentIndex);
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        
    }else if ([o isKindOfClass:[NSString class]]){
        if ([o hasPrefix:@"http://"]) {
            self.likeButton.hidden = NO;
            BOOL show = [[ShareInstance shareInstance].myLikeArray containsObject:o];
            self.likeButton.selected = show;
        }
    }else if ([o isKindOfClass:[UIImage class]]) {
        
        
    }else if (MAKA_isDicionary(o)) {
        self.likeButton.hidden = NO;
        BOOL show = [[ShareInstance shareInstance].myLikeArray containsObject:NSDictionary_String_ForKey(o, @"url")];
        self.likeButton.selected = show;
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.bounds.size;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)editImage:(id)sender {
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    id o = [self.dataSource objectAtIndex:index];
    
    
    NSData* data = nil;
    
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        {
            data = [o data];
            if (!data) {
                return;
            }
        }
        
    }else if ([o isKindOfClass:[NSString class]]){
        
        {
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:o];
            }
            
            if (!data) {
                return;
            }
            
        }
        
    }else if ([o isKindOfClass:[UIImage class]]) {
        {
            data = UIImageJPEGRepresentation(o, 1);
            if (!data) {
                return;
            }
        }
        
    }else if (MAKA_isDicionary(o)) {
        {
            o = NSDictionary_String_ForKey(o, @"url");
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:o];
            }
            
            if (!data) {
                return;
            }
        }
    }
    FactoryJotViewController* jot = [[FactoryJotViewController alloc]init];
    
    FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    if (animatedImage) {
        jot.image = [[UIImage alloc]initWithData:data];
    }else {
        jot.image = [[UIImage alloc]initWithData:data];
    }
    jot.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:jot animated:YES completion:nil];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    return;
}

-(void)fullscreenAction
{
    id o = [self.dataSource objectAtIndex:self.currentIndex];
    
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        [FullScreenImageView showWithData:[o data]];
    }else if ([o isKindOfClass:[NSString class]]){
        [FullScreenImageView showWithImageURL:o];
    }else if ([o isKindOfClass:[UIImage class]]) {
        [FullScreenImageView showWithData:UIImageJPEGRepresentation(o, 1)];
    }else if (MAKA_isDicionary(o)) {
        [FullScreenImageView showWithImageURL:NSDictionary_String_ForKey(o, @"url")];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{

}


@end
