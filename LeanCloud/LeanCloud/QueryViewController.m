//
//  QueryViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/25.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "QueryViewController.h"
#import "CompanyListViewController.h"
#import "DetailViewController.h"
#import "QRViewController.h"


@interface QueryViewController () <UITextFieldDelegate>
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;



@end

@implementation QueryViewController {

    __weak IBOutlet UITextField *_orderNUM;

    __weak IBOutlet UITextField *_company;
    
    __weak IBOutlet UIButton *_queryBtn;
    NSString *_companyCode; //当前公司代码
    NSDictionary *_companyDic;
    
}

- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    return _sessionManager;
}


#pragma mark - xib拉出事件

- (IBAction)scanCode:(UIButton *)sender {
    
    QRViewController *vc = [[QRViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)textChangedAction:(UITextField *)sender {
    //控制按钮变色
    [self changeColor]; //加一个结束时触发退出的方法
}

- (IBAction)numDidEnd:(UITextField *)sender {
    [sender resignFirstResponder];
    
}


- (IBAction)companyChanged:(UITextField *)sender {
    [self changeColor];
    
}


- (IBAction)choseCompany:(UITextField *)sender {
    //点击事件（一点击就触发）,推出公司列表视图
    
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    CompanyListViewController *companyVC = [[CompanyListViewController alloc]init];
    [self.navigationController pushViewController:companyVC animated:YES];
}


- (void)changeColor {
    if ([_orderNUM.text isEqualToString:@""] || [_company.text isEqualToString:@""]) {
        
        [_queryBtn setBackgroundColor:[UIColor grayColor]];
        _queryBtn.enabled = NO;
    }else {
        [_queryBtn setBackgroundColor:[UIColor colorWithRed:0.40 green:0.86 blue:0.42 alpha:1.00]];
        _queryBtn.enabled = YES;
    }
}

- (IBAction)doQuery:(UIButton *)sender {
    //发起网络请求
    //加上一个过渡的等待动画
    [self.view endEditing:YES];
    
    NSDictionary *para = @{@"key":@"f93ec36d1330a6ef1d4fae73a1d5de0b", @"com":_companyCode, @"no":_orderNUM.text};
    
    
    [self.sessionManager POST:@"http://v.juhe.cn/exp/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"resultcode"] isEqualToString:@"200"]) {
            
            DetailViewController *detailVC = [[DetailViewController alloc]init];
            detailVC.expressDic = responseObject;
            
            [[DataManager getSharedInstance].dataArray yb_addObject:responseObject];

            [self.navigationController pushViewController:detailVC animated:YES];
        }else {
            NSString *reason = responseObject[@"reason"];
            [UILabel showStats:reason atView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UILabel showStats:[NSString stringWithFormat:@"%@",error] atView:self.view];
        
    }];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    
    [_queryBtn setBackgroundColor:[UIColor grayColor]];
    _queryBtn.enabled = NO;
    

}

- (void)saveDataToLocal {

    NSDictionary *para = @{@"key":@"f93ec36d1330a6ef1d4fae73a1d5de0b"};
    [self.sessionManager POST:@"http://v.juhe.cn/exp/com" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _companyDic = responseObject;   //随后把这个数据放在本地
        
        NSString *path = [NSString stringWithFormat:@"%@/Documents/companyData.archiver", NSHomeDirectory()];
        BOOL flag = [NSKeyedArchiver archiveRootObject:_companyDic toFile:path];
        
        if (flag) {
            NSLog(@"写入成功");
        }
    } failure:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishCompany:) name:@"whichcompany" object:nil];
}

- (void)finishCompany:(NSNotification *)noti {

    _company.text = noti.userInfo[@"com"];
    
    [self changeColor];
    
    _companyCode = noti.userInfo[@"no"];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fillOrder:) name:@"codeResult" object:nil];

}

- (void)fillOrder:(NSNotification *)noti {

    _orderNUM.text = noti.userInfo[@"code"];

}



@end
