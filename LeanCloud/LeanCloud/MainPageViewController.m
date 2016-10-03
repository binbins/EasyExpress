//
//  MainPageViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/12.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "MainPageViewController.h"
#import "LeftDrawerViewController.h"
#import "MMDrawerController.h"
#import "TableViewCell.h"
#import "QueryViewController.h"
#import "MainModel.h"
#import "DetailViewController.h"

@interface MainPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIBarButtonItem *queryItem;
@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation MainPageViewController {

    __weak IBOutlet UITableView *_table;

}

- (UIBarButtonItem *)queryItem {
    if (!_queryItem) {
        _queryItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushQueryView)];
    }
    return _queryItem;
}

- (void)pushQueryView {
    
    QueryViewController *queryVC = [[QueryViewController alloc]init];
    [self.navigationController pushViewController:queryVC animated:YES];
    
}


- (NSMutableArray *)models {

    if (!_models) {
        _models = [[NSMutableArray alloc]init];
        for (NSDictionary *d in [DataManager getSharedInstance].dataArray) {
            //安全写法
            MainModel *model = [[MainModel alloc]init];
            NSDictionary *resultDic = d[@"result"];
            model.no = resultDic[@"no"];
            model.company = resultDic[@"company"];
            [_models addObject:model];
        }
        
    }
    return _models;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"轻松快递";
    self.navigationItem.rightBarButtonItem = self.queryItem;
    [self changeRootView];
    
    
}

- (void)testZiZeng{
    if ([AVUser currentUser]) {
        NSInteger i = [[AVUser currentUser][@"LoginTimes"] integerValue];
        NSLog(@"登录次数%d",i);
    }
}
- (void)getCloudPointer {
    if ([AVUser currentUser]) {
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"companyData.archiver" ofType:nil];
//        NSDictionary * d = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        [[AVUser currentUser]setObject:@[@{@"name":@"大笨蛋"}, @{@"name":@"大聪明蛋"}] forKey:@"testa"];
        [[AVUser currentUser]saveInBackground];

        
        //读取
//        NSDictionary *d = [AVUser currentUser][@"testd"];
//        NSLog(@"%@",d[@"reason"]);
    }
    
}

- (void)changeRootView { //更改window的根视图
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:self];  //这个方法自创的，会不会有什么问题
    
    LeftDrawerViewController *leftDrawer = [[LeftDrawerViewController alloc]init];
    
    MMDrawerController *mm = [[MMDrawerController alloc]initWithCenterViewController:nvc leftDrawerViewController:leftDrawer];
    mm.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    mm.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    mm.maximumLeftDrawerWidth = 4*KSC_W/5;
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mm;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellMark = @"tableCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil]firstObject];

    }
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.expressDic = [DataManager getSharedInstance].dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 接受通知
- (void)viewDidAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataChangeAction) name:@"datachanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserDataAfterLogin) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearUserDataAfterLogout) name:@"logout" object:nil];
    
}
- (void)getUserDataAfterLogin { //是否首次登录
    BOOL isFirst = [[AVUser currentUser][@"IsNewUser"] boolValue];
    
    if (isFirst) {  //首次登录的话，把用户当前的信息上传
        
        if ([DataManager getSharedInstance].dataArray.count > 0) {
//            [UILabel showStats:@"正在上传当前数据" atView:[UIApplication sharedApplication].keyWindow];
            
            [[AVUser currentUser]setObject:[DataManager getSharedInstance].dataArray forKey:@"MyExpressList"];
            [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    NSLog(@"云端同步失败");
                }
            }];
        }
        
    }else { //不是首次登录
        NSMutableArray *expressList = [[AVUser currentUser] objectForKey:@"MyExpressList"];
        
        if (expressList) { //肯定有字段
            
            [DataManager getSharedInstance].dataArray = expressList;
            [self dataChangeAction];
            
        }else { //等同于清除信息
            [self clearUserDataAfterLogout];
        }
    }


}

- (void)clearUserDataAfterLogout {

    [[DataManager getSharedInstance].dataArray clearLocalInfo];
//    [DataManager getSharedInstance].dataArray = [[NSMutableArray alloc]init]; //removeAllObjects之后怕出问题
    self.models = [[NSMutableArray alloc]init];
    [_table reloadData];
}

- (void)dataChangeAction {  //更新一下数组、表视图

    self.models = nil;
    self.models = [[NSMutableArray alloc]init];
    for (NSDictionary *d in [DataManager getSharedInstance].dataArray) {
        //安全写法
        MainModel *model = [[MainModel alloc]init];
        model.no = d[@"result"][@"no"];
        model.company = d [@"result"][@"company"];
        [self.models addObject:model];
    }
    
    [_table reloadData];
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
