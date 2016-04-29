//
//  FactoryIndexViewController.m
//  BiaoQingBao
//
//  Created by maka.zeng on 16/4/11.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "CommonHeader.h"
#import <Masonry.h>
#import "FactoryIndexViewController.h"
#import "FactoryJotViewController.h"
#import "FactoryIndexTableViewCell.h"

@interface FactoryIndexViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@end

@implementation FactoryIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Factory";
    [self firstLoadData];
}

-(void)firstLoadData
{
    self.dataSource = [NSMutableArray array];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"camera" forKey:@"imageURL"];
    [dic setObject:@"camera" forKey:@"localImage"];
    [dic setObject:@"使用相机选取图片" forKey:@"title"];
    [dic setObject:@"生成动态表情" forKey:@"subTitle"];
    [dic setObject:@"http://www.baidu.com" forKey:@"jumpURL"];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self.dataSource addObject:dic];
    [self firstLoadUserInterface];
}

-(void)firstLoadUserInterface
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FactoryIndexTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FactoryIndexTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(FactoryIndexTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.dataSource[indexPath.row];
    
    FactoryIndexTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FactoryIndexTableViewCell" forIndexPath:indexPath];
    
    NSString* str = NSDictionary_String_ForKey(dic, @"localImage");
    
    if (str.length > 0) {
        cell.mImageView.image = [UIImage imageNamed:str];
    }else {
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:NSDictionary_String_ForKey(dic, @"imageURL")]];
    }
    
    cell.mTitleLabel.text = NSDictionary_String_ForKey(dic, @"title");
    cell.mSubTitleLabel.text = NSDictionary_String_ForKey(dic, @"subTitle");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)updateData
{
    
}

-(void)updateUserInterface
{
    
}


-(void)tapAction
{
    FactoryJotViewController* jot = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FactoryJotViewController"];
    [self presentViewController:jot animated:YES completion:nil];
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
