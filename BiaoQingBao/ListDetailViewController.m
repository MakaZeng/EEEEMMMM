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
#import "DetailCollectionViewCell.h"
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

#define FirstShowGifSendToTimeLine @"FirstShowGifSendToTimeLine"

@interface ListDetailViewController ()<ShareUtilDelegate>

@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSArray* imageArray;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation ListDetailViewController

-(instancetype)initWitImage:(UIImage *)image
{
    ListDetailViewController* vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
    vc.image = image;
    return vc;
}

-(instancetype)initWithImageArray:(NSArray *)array index:(NSInteger)index
{
    ListDetailViewController* vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
    vc.index = index;
    vc.imageArray = array;
    return vc;
}

- (IBAction)tapAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveAction:(id)sender {
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
        [ShareInstance statusBarToastWithMessage:@"保存成功"];
    }else {
        [ShareInstance statusBarToastWithMessage:@"保存失败"];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MODEL_VIEW_BACK_COLOR;
    self.contentView.backgroundColor = BASE_BACK_COLOR;
    Layer_View(self.contentView);
    Layer_View(self.collectionView);
    Layer_View(self.editButton);
    Layer_View(self.saveButton);
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

-(void)firstLoadUserInterface
{
    UIView* shareView = [MakaShareUtil instanceViewForItems:@[[NSNumber numberWithInteger:ShareUtilTypeQQ],
                                                          [NSNumber numberWithInteger:ShareUtilTypeWechat],
                                                          [NSNumber numberWithInteger:ShareUtilTypeWechatSession],
                                                          [NSNumber numberWithInteger:ShareUtilTypeWechatCollection]] delegate:self];
    [self.contentView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.mas_equalTo(60*4);
        make.height.mas_equalTo(60);
    }];
    
    [self.collectionView reloadData];
}

-(void)buttonAction:(UIButton*)btn
{
    NSInteger i = btn.tag - BEGIN_TAG;
    NSArray* arr = @[[NSNumber numberWithInteger:ShareUtilTypeQQ],
      [NSNumber numberWithInteger:ShareUtilTypeWechat],
      [NSNumber numberWithInteger:ShareUtilTypeWechatSession],
                     [NSNumber numberWithInteger:ShareUtilTypeWechatCollection]];
    ShareUtilType type = [arr[i] integerValue];
    [self ShareUtil:nil selectedType:type];
}

-(void)ShareUtil:(MakaShareUtil *)util selectedType:(ShareUtilType)type
{
    id o = [self.dataSource objectAtIndex:self.currentIndex];
    
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        switch (type) {
            case ShareUtilTypeQQ:
            {
                [self sendToQQ:o];
                return;
            }
            case ShareUtilTypeWechat:
            {
                [self sendGifImageDirection:o scence:WXSceneSession];
                return;
            }
            case ShareUtilTypeWechatSession:
            {
                [self sendGifImageDirection:o scence:WXSceneTimeline];
                return;
            }
            case ShareUtilTypeWechatCollection:
            {
                
                [self sendGifImageDirection:o scence:WXSceneFavorite];
                return;
            }
            default:
                break;
        }
    }else if ([o isKindOfClass:[NSString class]]){
        switch (type) {
            case ShareUtilTypeQQ:
            {
                [self sendToQQ:o];
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
            default:
                break;
        }
    }else if ([o isKindOfClass:[UIImage class]]) {
        
        switch (type) {
            case ShareUtilTypeQQ:
            {
                [self sendToQQ:o];
                return;
            }
            case ShareUtilTypeWechat:
            {
                [self sendImageDirection:o scence:WXSceneSession];
                return;
            }
            case ShareUtilTypeWechatSession:
            {
                [self sendImageDirection:o scence:WXSceneTimeline];
                return;
            }
            case ShareUtilTypeWechatCollection:
            {
                
                [self sendImageDirection:o scence:WXSceneFavorite];
                return;
            }
            default:
                break;
        }
        
    }else if (MAKA_isDicionary(o)) {
        o = NSDictionary_String_ForKey(o, @"url");
        switch (type) {
            case ShareUtilTypeQQ:
            {
                [self sendToQQ:o];
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
            default:
                break;
        }
    }
    
}

- (IBAction)selectAction:(id)sender {
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ShareInstance shareInstance] save];
    onceToken = 0;
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

-(void)sendToWechat:(int)scene obj:(id)o
{
    NSData* data = nil;
    //link
    if ([o hasPrefix:@"http://"]) {
        NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
        data = [[NSData alloc]initWithContentsOfFile:path];
    }else {
        data = [[NSData alloc]initWithContentsOfFile:o];
    }
    
    if (!data) {
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
    .addButtonWithActionBlock(@"继续发送", ^{
        block(YES);
    });
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Warning)
    .title(@"注意(只会显示一次)")
    .subTitle(@"由于微信限制,动态图发送到朋友圈和收藏时,会自动变成静态图,是否继续发送?")
    .duration(0);
    
    [builder.alertView addButton:@"取消发送" actionBlock:^{
        block(NO);
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, self);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FirstShowGifSendToTimeLine];
}

-(void)sendImageDirection:(UIImage*)image scence:(int)scene
{
    UIImage* sourceImage = image;
    NSData* thumbData = UIImageJPEGRepresentation([MakaShareUtil thumbnailWithImageWithoutScale:sourceImage size:CGSizeMake(80, (80/(sourceImage.size.width/sourceImage.size.height)))], 1) ;
    
    WXMediaMessage* message = [WXMediaMessage message];
    [message setThumbData:thumbData];
    
    if (scene != WXSceneSession) {
        WXImageObject* obj = [WXImageObject object];
        obj.imageData = UIImageJPEGRepresentation(sourceImage, 1);
        message.mediaObject = obj;
    }else {
        WXEmoticonObject* obj = [WXEmoticonObject object];
        obj.emoticonData = UIImageJPEGRepresentation(sourceImage, 1);
        message.mediaObject = obj;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

-(void)sendGifImageDirection:(FLAnimatedImage*)image scence:(int)scene
{
    FLAnimatedImage* sourceImage = image;
    NSData* thumbData = UIImageJPEGRepresentation([MakaShareUtil thumbnailWithImageWithoutScale:[UIImage imageWithData:sourceImage.data] size:CGSizeMake(80, (80/(sourceImage.size.width/sourceImage.size.height)))], 1) ;
    
    WXMediaMessage* message = [WXMediaMessage message];
    [message setThumbData:thumbData];
    
    if (scene != WXSceneSession) {
        WXImageObject* obj = [WXImageObject object];
        obj.imageData = image.data;
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
        return;
    }else {
        WXEmoticonObject* obj = [WXEmoticonObject object];
        obj.emoticonData = image.data;
        message.mediaObject = obj;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


static dispatch_once_t onceToken;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.index, 0)];
            self.currentIndex = self.index;
        });
    });
}
#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (DetailCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DetailCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
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
    _currentIndex = currentIndex;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.dataSource.count];
    
    self.likeButton.hidden = YES;
    
    id o = [self.dataSource objectAtIndex:currentIndex];
    
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
- (IBAction)editImage:(id)sender {
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    id o = [self.dataSource objectAtIndex:index];
    
    if ([o isKindOfClass:[FLAnimatedImage class]]) {
        {
            NSData* data = [o data];
            
            if (!data) {
                return;
            }
            
            
            FactoryJotViewController* jot = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FactoryJotViewController"];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                jot.image = [[UIImage alloc]initWithData:data];
            }else {
                jot.image = [[UIImage alloc]initWithData:data];
            }
            
            [self presentViewController:jot animated:YES completion:nil];
        }
        
    }else if ([o isKindOfClass:[NSString class]]){
        
        {
            NSData* data = nil;
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:o];
            }
            
            if (!data) {
                return;
            }
            
            
            FactoryJotViewController* jot = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FactoryJotViewController"];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                jot.image = [[UIImage alloc]initWithData:data];
            }else {
                jot.image = [[UIImage alloc]initWithData:data];
            }
            
            [self presentViewController:jot animated:YES completion:nil];
        }
        
    }else if ([o isKindOfClass:[UIImage class]]) {
        {
            NSData* data = UIImageJPEGRepresentation(o, 1);
            if (!data) {
                return;
            }
            
            FactoryJotViewController* jot = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FactoryJotViewController"];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                jot.image = [[UIImage alloc]initWithData:data];
            }else {
                jot.image = [[UIImage alloc]initWithData:data];
            }
            
            [self presentViewController:jot animated:YES completion:nil];
        }
        
    }else if (MAKA_isDicionary(o)) {
        {
            o = NSDictionary_String_ForKey(o, @"url");
            NSData* data = nil;
            if ([o hasPrefix:@"http://"]) {
                NSString* path = [[SDImageCache sharedImageCache] defaultCachePathForKey:o];
                data = [[NSData alloc]initWithContentsOfFile:path];
            }else {
                data = [[NSData alloc]initWithContentsOfFile:o];
            }
            
            if (!data) {
                return;
            }
            
            
            FactoryJotViewController* jot = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FactoryJotViewController"];
            
            FLAnimatedImage* animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (animatedImage) {
                jot.image = [[UIImage alloc]initWithData:data];
            }else {
                jot.image = [[UIImage alloc]initWithData:data];
            }
            
            [self presentViewController:jot animated:YES completion:nil];
        }
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    return;
    id o = [self.dataSource objectAtIndex:indexPath.row];
    
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
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
