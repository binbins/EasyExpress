//
//  DetailViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/25.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "DetailViewController.h"
#import "ExpressModel.h"
#import "ExpressDetailTableViewCell.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table;
@property (nonatomic, strong)NSMutableArray *Models;

@end

@implementation DetailViewController

#pragma mark - 懒加载
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSC_W, KSC_H) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSMutableArray *)Models {
    if (!_Models) {
        _Models = [[NSMutableArray alloc]init];
        
        //for循环解析字典
        NSDictionary *wholeInfo = _expressDic[@"result"];//头视图的信息
        
        NSArray *list = wholeInfo[@"list"];
        if (list) {
            for (int i = 0; i<list.count; i++) {
                NSDictionary *d = list[i];
                ExpressModel *model = [[ExpressModel alloc]init];
                model.datetime = d[@"datetime"];
                model.remark = d[@"remark"];
                model.zone = d[@"zone"];
                [_Models addObject:model];
            }
        }//安全判断结束
        
    }
    return _Models;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快递详情";
    [self.view addSubview:self.table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.Models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ExpressDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ExpressDetailTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.model = self.Models[indexPath.row];
    return cell;
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
