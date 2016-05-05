//
//  BrowserViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/24.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import "ServiceManager.h"
#import "ShareInstance.h"
#import "BrowserTableViewCell.h"
#import "BrowserViewController.h"
#import <ReactiveCocoa.h>
#import "BrowserSuggestTableViewCell.h"
#import "MyWebViewController.h"

@interface BrowserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray* serviceArray;

@property (nonatomic,strong) NSMutableArray* webSiteArray;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshList
{
    self.webSiteArray = [ShareInstance shareInstance].webSiteArray;
    if (self.webSiteArray.count == 0) {
        [self.webSiteArray addObject:@{@"title":@"Baidu",@"url":@"http://www.baidu.com"}];
    }
    [self.tableView reloadData];
}

-(void)EditAction
{
    self.tableView.editing = !self.tableView.isEditing;
//    if (self.tableView.isEditing) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"停止" style:UIBarButtonItemStyleBordered target:self action:@selector(EditAction)];
//    }else {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditAction)];
//    }
}

-(void)addAction
{
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Edit)
    .title(@"添加收藏")
    .subTitle(@"请不要收集或传播非法网站的动态图")
    .duration(0);
    
    __block SCLTextView* textView;
    
    __block SCLTextView* titleTextView;
    
    @weakify(self);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"添加", ^{
        @strongify(self);
        [self addKeyWithString:textView.text title:titleTextView.text];
    });
    
    titleTextView = [builder.alertView addTextField:@"标题"];
    
    textView = [builder.alertView addTextField:@"输入网址"];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
    // or even
    showBuilder.show(builder.alertView, self);
}

-(void)addKeyWithString:(NSString*)text title:(NSString*)title
{
    if ([text hasPrefix:@"http://"]) {
        [[ShareInstance shareInstance].webSiteArray addObject:@{@"title":title,@"url":text}];
    }else {
        text = [NSString stringWithFormat:@"http://%@",text];
        [[ShareInstance shareInstance].webSiteArray addObject:@{@"title":title,@"url":text}];
    }
    [[ShareInstance shareInstance] save];
    [self updateData];
}

-(void)firstLoadData
{
    self.title = @"Browser";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:MyWebViewControllerRefreshNotification object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"BrowserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BrowserTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BrowserSuggestTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BrowserSuggestTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.webSiteArray = [ShareInstance shareInstance].webSiteArray;
    if (self.webSiteArray.count == 0) {
        [self.webSiteArray addObject:@{@"title":@"百度",@"url":@"http://www.baidu.com"}];
    }
    @weakify(self);
    [ServiceManager queryBrowserPageCongfigWithDic:nil callBack:^(id result) {
        @strongify(self);
        if (MAKA_isArray(result)) {
            self.serviceArray = [result mutableCopy];
        }
        [self.tableView reloadData];
    }];
}

-(void)firstLoadUserInterface
{
    
}

-(void)updateData
{
    self.webSiteArray = [ShareInstance shareInstance].webSiteArray;
    [self.tableView reloadData];
}

-(void)updateUserInterface
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"今日推荐";
    }else{
        return @"我的收藏";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.serviceArray.count;
    }
    return self.webSiteArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary* dic = self.serviceArray[indexPath.row];
        
        BrowserSuggestTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserSuggestTableViewCell" forIndexPath:indexPath];
        
        cell.suggestLabel.text = NSDictionary_String_ForKey(dic, @"title");
        
        cell.htmlLbabel.text = NSDictionary_String_ForKey(dic, @"url");
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"headImage")] placeholderImage:ImageNamed(@"img_default")];
        
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"backImage")] ];
        
        return cell;
    }else {
        NSDictionary* dic = self.webSiteArray[indexPath.row];
        
        BrowserTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserTableViewCell" forIndexPath:indexPath];
        
        cell.htmlLabel.text = NSDictionary_String_ForKey(dic, @"url");
        
        cell.contentLabel.text = NSDictionary_String_ForKey(dic, @"title");
        
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        //        通过获取的索引值删除数组中的值
        [self.webSiteArray removeObjectAtIndex:row];
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [ShareInstance shareInstance].webSiteArray = self.webSiteArray;
        [[ShareInstance shareInstance] save];
    }  
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (destinationIndexPath.section == 0) {
        [tableView moveRowAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
        return;
    }
    [self.webSiteArray insertObject:self.webSiteArray[sourceIndexPath.row] atIndex:destinationIndexPath.row];
    [self.webSiteArray removeObjectAtIndex:sourceIndexPath.row];
    [ShareInstance shareInstance].webSiteArray = self.webSiteArray;
    [[ShareInstance shareInstance] save];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        NSDictionary* dic = self.serviceArray[indexPath.row];
        NSString* urlStr = NSDictionary_String_ForKey(dic, @"url");
        MyWebViewController *qrweb = [[MyWebViewController alloc]initWithURLString:urlStr];
        qrweb.navigationButtonsHidden = YES;
        qrweb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrweb animated:YES];
    }else {
        NSDictionary* dic = self.webSiteArray[indexPath.row];
        NSString* urlStr = NSDictionary_String_ForKey(dic, @"url");
        MyWebViewController *qrweb = [[MyWebViewController alloc]initWithURLString:urlStr];
        qrweb.navigationButtonsHidden = YES;
        qrweb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrweb animated:YES];
        
    }
}


@end
