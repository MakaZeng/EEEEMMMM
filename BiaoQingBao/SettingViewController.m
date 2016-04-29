//
//  SettingViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/21.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "ServiceManager.h"
#import "CommonHeader.h"
#import <ReactiveCocoa.h>
#import "UserInfoManager.h"
#import "RateTableViewCell.h"
#import "ReferenceTableViewCell.h"
#import "SettingViewController.h"
#import "MyWebViewController.h"
#import "RateManager.h"
#import "MyCollectionViewController.h"

@interface SettingViewController ()
@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic,strong) NSMutableArray * serviceArray;

@property (nonatomic,strong) NSDictionary* dic;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    
    NSDictionary* dic = @{@"title":@"我的收藏",
                          @"class":@"MyCollectionViewController",
                          @"localImage":@"my_collection",
                          };
    
    [self.dataSource addObject:dic];
    
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"RateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RateTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReferenceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReferenceTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

-(void)updateData
{
    
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.serviceArray.count;
    }else {
        return self.dataSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic;
    if (indexPath.section == 0) {
        dic = self.serviceArray[indexPath.row];
    }else {
        dic = self.dataSource[indexPath.row];
    }
    if ([NSDictionary_String_ForKey(dic, @"rateURL") length]) {
        return 80;
    }else {
        return 50;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    NSDictionary* dic;
    
    if (indexPath.section == 0) {
        dic = self.serviceArray[indexPath.row];
    }else {
        dic = self.dataSource[indexPath.row];
    }
    
    {
        ReferenceTableViewCell* c = [tableView dequeueReusableCellWithIdentifier:@"ReferenceTableViewCell" forIndexPath:indexPath];
        c.leftImageView.image = ImageNamed(NSDictionary_String_ForKey(dic, @"localImage"));
        if (!c.leftImageView.image) {
            [c.leftImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"headImage")]];
            [c.backImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"backImage")]];
            [c.statusImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"rightImage")]];
        }
        c.rightLabel.text = NSDictionary_String_ForKey(dic, @"title");
        cell = c;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dic;
    
    if (indexPath.section == 0) {
        dic = self.serviceArray[indexPath.row];
    }else {
        dic = self.dataSource[indexPath.row];
    }
    
    if ( [NSDictionary_String_ForKey(dic, @"class") length] > 0) {
        NSString* className = NSDictionary_String_ForKey(dic, @"class");
        UIViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:className];
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
