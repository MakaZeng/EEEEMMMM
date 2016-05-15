//
//  ShareUtil.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <Masonry.h>
#import "CommonHeader.h"
#import "MakaShareItemView.h"
#import "MakaShareUtil.h"
#import <ReactiveCocoa.h>

@implementation MakaShareUtil

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}


+(UIView*)instanceViewForItems:(NSArray *)items delegate:(id<ShareUtilDelegate>)delegate
{
    UIView* v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    MakaShareItemView* ttt =nil;
    MakaShareItemView* latTtt = nil;
    
    CGFloat itemWidth = 70;
    
    NSInteger limit = items.count;
    
    if (itemWidth*items.count >= SCREEN_WIDTH - 20) {
        limit = 4;
    }
    
    @weakify(self);
    for (NSInteger i = 0 ; i < limit;  i ++) {
        @strongify(self);
        NSInteger item = [items[i] integerValue];
        ttt = [MakaShareItemView instance];
        [v addSubview:ttt];
        [ttt mas_makeConstraints:^(MASConstraintMaker *make) {
            if (latTtt) {
                make.left.equalTo(latTtt.mas_right);
            }else {
                make.left.mas_equalTo((SCREEN_WIDTH - itemWidth*limit)/2);
            }
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(itemWidth);
        }];
        
        ttt.btn.tag = BEGIN_TAG+i;
        [ttt.btn addTarget:delegate action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary* dic = [self infoForType:item];
        ttt.imageView.image = ImageNamed(NSDictionary_String_ForKey(dic, @"imageName"));
        ttt.titleLabel.text = NSDictionary_String_ForKey(dic, @"title");
        latTtt = ttt;
    }
    return v;
}

-(void)buttonAction:(UIButton*)btn
{
    
}

+(NSDictionary*)infoForType:(ShareUtilType)type
{
    NSString* title;
    NSString* imageName;
    switch (type) {
        case ShareUtilTypeQQ:
        {
            title = NSLocalizedString(@"QQ", @"QQ");
            imageName=@"ShareUtilTypeQQ";
            break;
        }
        case ShareUtilTypeWechat:
        {
            title = NSLocalizedString(@"Wechat", @"Wechat");
            imageName=@"ShareUtilTypeWechat";
            break;
        }
        case ShareUtilTypeWechatCollection:
        {
            title = NSLocalizedString(@"WechatCollection", @"WechatCollection");
            imageName=@"ShareUtilTypeWechatCollection";
            break;
        }
        case ShareUtilTypeWechatSession:
        {
            title = NSLocalizedString(@"WechatSession", @"WechatSession");
            imageName=@"ShareUtilTypeWechatSession";
            break;
        }
        case ShareUtilTypeWhatsApp:
        {
            title = NSLocalizedString(@"WhatsApp", @"WhatsApp");
            imageName=@"ShareUtilTypeWhatsApp";
            break;
        }
        case ShareUtilTypeLine:
        {
            title = NSLocalizedString(@"Line", @"Line");
            imageName=@"ShareUtilTypeLine";
            break;
        }
        case ShareUtilTypeFacebook:
        {
            title = NSLocalizedString(@"Facebook", @"Facebook");
            imageName=@"ShareUtilTypeFacebook";
            break;
        }
        default:
            break;
    }
    return @{@"title":title,@"imageName":imageName};
}

@end
