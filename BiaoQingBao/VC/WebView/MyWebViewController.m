//
//  MyWebViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "MyWebViewController.h"
#import "ShareInstance.h"
#import <SCLAlertView.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface MyWebViewController ()

@end

@implementation MyWebViewController

-(void)backAction
{
    [self.webView goBack];
}

-(void)closeAction
{
    [self.webView stopLoading];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIToolbar* toolbar = [[UIToolbar alloc]init];
    [self.view addSubview:toolbar];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"back_icon") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIBarButtonItem* closeItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"tab_close_icon") style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    UIBarButtonItem* storeItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"unlike_icon") style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    UIBarButtonItem* padding = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[backItem,storeItem,padding,closeItem];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
        .style(Edit)
        .title(NSLocalizedString(@"Tips", @"添加收藏"))
        .subTitle(NSLocalizedString(@"Long Press To Save Image ; ❤ To Make a Bookmark", @"请不要收集或传播非法网站的动态图"))
        .duration(0);
        
        SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
        .addButtonWithActionBlock(NSLocalizedString(@"OK", @"添加"), ^{


        });
        
        [showBuilder showAlertView:builder.alertView onViewController:self];
        // or even
        showBuilder.show(builder.alertView, [UIApplication sharedApplication].keyWindow.rootViewController);
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ShareInstance shareInstance] save];
}

-(void)rightAction
{
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Edit)
    .title(NSLocalizedString(@"Title", @"标题"))
    .subTitle(NSLocalizedString(@"Nice Name For This Website", @"Na"))
    .duration(0);
    
    __block SCLTextView* textView;
    
    @weakify(self);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(NSLocalizedString(@"Add", @"Add"), ^{
        @strongify(self);
        [self addKeyWithString:textView.text];
    });
    
    textView = [builder.alertView addTextField:NSLocalizedString(@"Input Title", @"Input Title")];
    
    [builder.alertView addButton:NSLocalizedString(@"Cancel", @"Cancel") actionBlock:^{
        
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, [UIApplication sharedApplication].keyWindow.rootViewController);
}

-(void)addKeyWithString:(NSString*)title
{
    [[ShareInstance shareInstance].webSiteArray addObject:@{@"title":title,@"url":self.webView.request.URL.absoluteString}];
    
    [ShareInstance statusBarToastWithMessage:NSLocalizedString(@"Collect Success", @"Collect Success")];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MyWebViewControllerRefreshNotification object:nil];
}

@end
