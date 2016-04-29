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
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"back_icon") style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    UIBarButtonItem* closeItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"close_icon") style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction)];
    UIBarButtonItem* storeItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"unlike_icon") style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];
    
    UIBarButtonItem* padding = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[backItem,storeItem,padding,closeItem];
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

-(void)rightAction
{
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Edit)
    .title(@"标题")
    .subTitle(@"给这个网址取个名字吧")
    .duration(0);
    
    __block SCLTextView* textView;
    
    @weakify(self);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"添加", ^{
        @strongify(self);
        [self addKeyWithString:textView.text];
    });
    
    textView = [builder.alertView addTextField:@"输入标题"];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, self);
}

-(void)addKeyWithString:(NSString*)title
{
    [[ShareInstance shareInstance].webSiteArray addObject:@{@"title":title,@"url":self.webView.request.URL.absoluteString}];
    
    [ShareInstance statusBarToastWithMessage:@"网址收藏成功"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MyWebViewControllerRefreshNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
