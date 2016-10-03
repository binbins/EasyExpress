//
//  LeftDrawerViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/12.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"

@interface LeftDrawerViewController ()
//@property (nonatomic, strong)UIImageView *icon;


@end

@implementation LeftDrawerViewController {

   
    __weak IBOutlet UIImageView *_userIcon;

    __weak IBOutlet UILabel *_userName;
    
    BOOL _isInLog;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bg = [UIImage imageNamed:@"i_2bg@2x.jpg"];
    self.view.layer.contents = (id)bg.CGImage;
    
//    [self.view addSubview:self.icon];
    
    AVUser *user = [AVUser currentUser];
    
    if (user) {
        _isInLog = YES;
    }
    
    [self showCurrentPage];  //根据是否登录显示当前页面
    [self setTapAction];   //根据是否登录响应不同的事件
    
    
}
- (void)showCurrentPage {
    if (_isInLog) {
        _userName.text = [AVUser currentUser].username;
        //还有图标,分两种
        if ([AVUser currentUser][@"avatarFileID"] != nil) {
            [AVFile getFileWithObjectId:[AVUser currentUser][@"avatarFileID"] withBlock:^(AVFile *file, NSError *error) {
                
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [_userIcon setImage:[UIImage imageWithData:data]];
                }];
            }];
        }else {
            [_userIcon setImage:[UIImage imageNamed:@"ico-touxiang@3x.png"]];
        }
        
    }else {
        _userName.text = @"登录轻松快递";
        [_userIcon setImage:[UIImage imageNamed:@"ico-touxiang@3x.png"]];
        
    }
}

- (void)setTapAction {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoginOrShowUser)];
    [_userIcon addGestureRecognizer:tap];

}

- (void)LoginOrShowUser {
    UIViewController *vc;
    if (_isInLog) {     //推出用户视图
        vc = [[UserViewController alloc]init];
        
    }else { //推出登录视图
        vc = [[LoginViewController alloc]init];
    }
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - 登入登出通知
- (void)viewDidAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exchangeToOut) name:@"logout" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exchangeToIn) name:@"userinfochanged" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doMoreThingAfterLoginWhenFirst) name:@"login" object:nil];
}

- (void)exchangeToOut {

    _isInLog = NO;
    [self showCurrentPage];
}

- (void)doMoreThingAfterLoginWhenFirst {

    BOOL isFirst = [[AVUser currentUser][@"IsNewUser"] boolValue];
    if (isFirst) {
        [UILabel showStats:@"欢迎使用轻松快递" atView:[UIApplication sharedApplication].keyWindow];
        [[AVUser currentUser]setObject:@NO forKey:@"IsNewUser"];
        [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"保存云端失败");
            }
        }];
    }else {
        NSString *tip = [[AVUser currentUser].username stringByAppendingString:@" 欢迎回来"];
        [UILabel showStats:tip atView:[UIApplication sharedApplication].keyWindow];
    }
    _isInLog = YES;
    [self exchangeToIn];
}
- (void)exchangeToIn {

    _isInLog = YES;
    [self showCurrentPage];
    
   
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
