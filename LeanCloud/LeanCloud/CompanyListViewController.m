//
//  CompanyListViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/25.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "CompanyListViewController.h"

 @interface CompanyListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *table;
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation CompanyListViewController

#pragma mark - 懒加载

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSC_W, KSC_H-20) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSArray *)dataList {

    if (!_dataList) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"companyData.archiver" ofType:nil];
        
        if (path) {
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            _dataList = dic[@"result"];
        }
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快递公司";
    [self.view addSubview:self.table];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"companycell"];
    }
    NSDictionary *d = self.dataList[indexPath.row];
    cell.textLabel.text = d[@"com"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //发出通知传过去
    [[NSNotificationCenter defaultCenter]postNotificationName:@"whichcompany" object:nil userInfo:self.dataList[indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
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
