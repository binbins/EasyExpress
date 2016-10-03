//
//  RegisterViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/15.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {

    __weak IBOutlet UIButton *_nextBtn;
    
    NSString *_lastFieldText;
    
    NSInteger _sec;
    
    NSTimer *_verifyTimer;
    
    __weak IBOutlet UITextField *_phoneNumber;
    
    __weak IBOutlet UITextField *_password;

    __weak IBOutlet UITextField *_verify;
    
    __weak IBOutlet UIButton *_getBtn;
    
}

#pragma mark - 限制文本框输入和输入过程的响应事件
- (IBAction)phoneChanged:(UITextField *)sender {
    
    NSString * regexNum = @"^\\d*$";
    NSPredicate *regexNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexNum];
    //大于11或出现数字之外的情况。
    //小瑕疵，光标的位置
    if ([regexNumPredicate evaluateWithObject:sender.text]==NO || sender.text.length > 11) {
        sender.text = _lastFieldText;
    }
    //获取验证码的按钮
    if (_phoneNumber.text.length != 11) {
        _getBtn.userInteractionEnabled = NO;
    }else {
        _getBtn.userInteractionEnabled = YES;
    }
    
    [self changeColor];//判断提交按钮要不要变色
    
    _lastFieldText = sender.text;
}

- (IBAction)passwordChanged:(UITextField *)sender {
    [self changeColor];
}

- (IBAction)verifyChanged:(UITextField *)sender {
    [self changeColor];
}

- (void)changeColor {
    if (_phoneNumber.text.length !=11 || [_password.text isEqualToString:@""] || [_verify.text isEqualToString:@""]) {
        [_nextBtn setBackgroundColor:[UIColor grayColor]];
        _nextBtn.userInteractionEnabled = NO;
    }else {
        
        [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.40 green:0.86 blue:0.42 alpha:1.00]];
        _nextBtn.userInteractionEnabled = YES ;
    }
    
}

#pragma mark - buttonAction

//还要考虑手机注册过的情况
- (IBAction)doGetVerify:(UIButton *)sender {    //只要能执行按钮事件，说明输入合乎要求
    
    [AVOSCloud requestSmsCodeWithPhoneNumber:_phoneNumber.text callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self setTimer];    //获取成功后进行计时
        }else {
            NSLog(@"%@",error);
        }
    }];
   
//    [self setTimer];
}

- (void)setTimer {

    _getBtn.userInteractionEnabled = NO;
    [_getBtn setBackgroundColor:[UIColor redColor]];
    _sec = 59;
    [_getBtn setTitle:[NSString stringWithFormat:@"60s"] forState:UIControlStateNormal];
    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dojishi) userInfo:nil repeats:YES];
}

- (void)dojishi {
    if (_sec >= 1) {
//        [UIView animateWithDuration:.1 animations:^{}];
        
            [_getBtn setTitle:[NSString stringWithFormat:@"%lds", (long)_sec] forState:UIControlStateNormal];
        _sec--;
    }else {
        [_getBtn setBackgroundColor:[UIColor orangeColor]];
        [_getBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_verifyTimer invalidate];
        
        if (_phoneNumber.text.length == 11) {   //再嵌套一个生效的条件
            _getBtn.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - 进行注册
- (IBAction)goNext:(id)sender {//进行注册，成功后引导用户登录


    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phoneNumber.text smsCode:_verify.text block:^(AVUser *user, NSError *error) {
        //根据error执行不同的事件
        if (error == nil) {
            
            [user updatePassword:user.password newPassword:_password.text block:^(id object, NSError *error) {
                NSLog(@"更改密码%@",error);
                if (error == nil) {
                    [UILabel showStats:@"注册成功" atView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                    //发送通知，进行预填写
                    NSDictionary *accountInfo = @{@"phone":_phoneNumber.text, @"password":_password.text};
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"preEdit" object:nil userInfo:accountInfo];
                }
                //注册过的手机也会出现，估计是当成登录了，还是把这两个方法分开写好
            }];
        }else {
        
            [UILabel showStats:[NSString stringWithFormat:@"%@",error] atView:self.view];   //分几种类型的，已经知道的是注册过的手机会出现 code-201
        }
        
        
    }];

    
}




//    [AVUser logOut]; //登出，从SDK里边清除
//    AVUser *user = [AVUser currentUser];
//
//    if (user != nil) {
//        NSLog(@"%@", user.username);
//    }else {
//        [UILabel showStats:@"为空" atView:self.view];
//    }
#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //提示信息
//    self.navigationItem.prompt = @"请根据要求进行注册";
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dePrompt) userInfo:nil repeats:NO];
    
    self.title = @"注册";
    _nextBtn.userInteractionEnabled = NO;
    _getBtn.userInteractionEnabled = NO;
}
- (void)dePrompt {
    self.navigationItem.prompt = nil;
}

#pragma mark - 一般
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

//    [_verifyTimer invalidate];
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
