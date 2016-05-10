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
#import "BrowserViewController.h"
#import <ReactiveCocoa.h>
#import "BrowserSuggestTableViewCell.h"
#import "MyWebViewController.h"
#import "RateManager.h"
#import "UserInfoManager.h"
#import <Masonry.h>

@interface BrowserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray* serviceArray;

@property (nonatomic,strong) NSDictionary* dic;

@property (nonatomic,strong) NSMutableArray* webSiteArray;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"Browser", @"Browser");
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = addItem;
    [self firstLoadData];
}

-(void)addAction
{
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(Edit)
    .title(NSLocalizedString(@"添加收藏", @"添加收藏"))
    .subTitle(NSLocalizedString(@"请不要收集或传播非法网站的动态图", @"请不要收集或传播非法网站的动态图"))
    .duration(0);
    
    __block SCLTextView* textView;
    
    __block SCLTextView* titleTextView;
    
    @weakify(self);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(NSLocalizedString(@"添加", @"添加"), ^{
        @strongify(self);
        [self addKeyWithString:textView.text title:titleTextView.text];
    });
    
    titleTextView = [builder.alertView addTextField:NSLocalizedString(@"标题", @"标题")];
    
    textView = [builder.alertView addTextField:NSLocalizedString(@"输入网址", @"输入网址")];
    
    [builder.alertView addButton:NSLocalizedString(@"取消", @"取消") actionBlock:^{
        
    }];
    
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
    self.webSiteArray = [ShareInstance shareInstance].webSiteArray;
    if (self.webSiteArray.count == 0) {
        [self.webSiteArray addObject:@{@"title":NSLocalizedString(@"百度", @"百度"),@"url":@"http://www.baidu.com"}];
    }
    @weakify(self);
    [ServiceManager querySettingWithDic:nil callBack:^(id result) {
        @strongify(self);
        if (MAKA_isArray(result)) {
            self.serviceArray = [result mutableCopy];
        }
        [self.tableView reloadData];
        NSDictionary* dic = self.serviceArray.lastObject;
        if (dic) {
            NSInteger type = [[dic objectForKey:@"type"] integerValue];
            if (type == 4) {
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:MAKA_UserDefault_RatedDictionaryKey];
            }
        }
        [RateManager showRateView];
    }];
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"BrowserSuggestTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BrowserSuggestTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
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
        return NSLocalizedString(@"今日推荐", @"今日推荐");
    }else{
        return NSLocalizedString(@"收藏的网址", @"收藏的网址");
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
    UITableViewCell* cell = nil;
    
    NSDictionary* dic;
    
    if (indexPath.section == 0) {
        dic = self.serviceArray[indexPath.row];
    }else {
        dic = self.webSiteArray[indexPath.row];
    }
    
    {
        BrowserSuggestTableViewCell* c = [tableView dequeueReusableCellWithIdentifier:@"BrowserSuggestTableViewCell" forIndexPath:indexPath];
        c.headImageView.image = ImageNamed(NSDictionary_String_ForKey(dic, @"localImage"));
        if (indexPath.section == 1) {
            c.headImageView.image = ImageNamed(@"icon_cloud");
        }
        if (!c.headImageView.image) {
            [c.headImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"headImage")]];
            [c.backImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"backImage")]];
        }
        c.suggestLabel.text = NSDictionary_String_ForKey(dic, @"title");
        cell = c;
    }
    return cell;
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
    
    NSDictionary* dic;
    
    if (indexPath.section == 0) {
        dic = self.serviceArray[indexPath.row];
    }else {
        dic = self.webSiteArray[indexPath.row];
    }
    
    if ( [NSDictionary_String_ForKey(dic, @"class") length] > 0) {
        NSString* className = NSDictionary_String_ForKey(dic, @"class");
        UIViewController* vc = [[NSClassFromString(className) alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSString* url = NSDictionary_String_ForKey(dic, @"url");
    if (url.length > 0) {
        if ([url hasPrefix:@"http"] || [url hasPrefix:@"www"]) {
            MyWebViewController *qrweb = [[MyWebViewController alloc]initWithURLString:url];
            qrweb.navigationButtonsHidden = YES;
            qrweb.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:qrweb animated:YES];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}


@end
