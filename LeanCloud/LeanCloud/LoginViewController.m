//
//  LoginViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/14.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserViewController.h"
#import "ResetViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property(nonatomic, strong)UIBarButtonItem *leftItem;
@property(nonatomic, strong)UILabel *lostPassword;

@end

@implementation LoginViewController {

    __weak IBOutlet UITextField *_phoneNumber;

    __weak IBOutlet UITextField *_passWord;
    
    __weak IBOutlet UIButton * _loginBtn;
    
    __weak IBOutlet UILabel *_lostPW;
    
    __weak IBOutlet UILabel *_register;
    
    NSString *_lastFieldText;
    
    
}

- (UIBarButtonItem *)leftItem {
    if (!_leftItem) {
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, 30, 30)];
        [backBtn setImage:[UIImage imageNamed:@"icon_result_left_enable@2x"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    }
    return _leftItem;
}

- (UILabel *)lostPassword {
    if (!_lostPassword) {
        _lostPassword = _lostPW;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushResetView)];
        [_lostPassword addGestureRecognizer:tap];
    }
    return _lostPassword;
}

- (void)pushResetView {
    ResetViewController *resetVC = [[ResetViewController alloc]init];
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (void)dismissSelf{
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark- 监听文本框的变化
- (IBAction)phoneChanged:(UITextField *)sender {
    [self changeColor];
    
    NSString * regexNum = @"^\\d*$";
    NSPredicate *regexNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexNum];
    //大于11或出现数字之外的情况。
    //小瑕疵，光标的位置
    if ([regexNumPredicate evaluateWithObject:sender.text]==NO || sender.text.length > 11) {
        sender.text = _lastFieldText;   //超出字数或输入非指定字符时不做改变
    }
    
    
    _lastFieldText = sender.text;
}
- (IBAction)passwordChanged:(UITextField *)sender {
    [self changeColor];
}

- (void)changeColor {
    if ([_phoneNumber.text isEqualToString:@""] || [_passWord.text isEqualToString:@""]) {
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundColor:[UIColor grayColor]];
        _loginBtn.userInteractionEnabled = NO;;
    }else {
        
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:0.40 green:0.86 blue:0.42 alpha:1.00]];
        _loginBtn.userInteractionEnabled = YES;
    }

}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录轻松快递";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    NSLog(@"通过打印来走一下这个方法%@",self.lostPassword);
    _loginBtn.userInteractionEnabled = NO;
    [self setRegister];
}

- (void)setRegister {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushRegister)];
    [_register addGestureRecognizer:tap];
}
- (void)pushRegister {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate



- (void)textFieldDidBeginEditing:(UITextField *)textField {

  
    
    //点击输入框的时候才会触发
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    //在这个方法中，当前文本框里的内容应该是textfiled加上string
    //优势可以记录当前光标的位置
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doPreEdit:) name:@"preEdit" object:nil];
}

- (void)doPreEdit:(NSNotification *)noti {

    _phoneNumber.text = noti.userInfo[@"phone"];
    _passWord.text = noti.userInfo[@"password"];
    _loginBtn.userInteractionEnabled = YES;
    [_loginBtn setBackgroundColor:[UIColor colorWithRed:0.40 green:0.86 blue:0.42 alpha:1.00]];
}


#pragma mark- 登录
- (IBAction)doLog:(UIButton *)sender {
    
    [AVUser logInWithMobilePhoneNumberInBackground:_phoneNumber.text password:_passWord.text block:^(AVUser *user, NSError *error) {
        
        
        if (error == nil) {
            [UILabel showStats:@"登录成功" atView:self.view];
            UserViewController *userView = [[UserViewController alloc]init];
            [self.navigationController pushViewController:userView animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            
        }else { //都是有错误的
            
            switch (error.code) {
                case 210: [UILabel showStats:@"用户名或密码错误" atView:self.view];
                    break;
                case 211: [UILabel showStats:@"该手机号尚未注册" atView:self.view];
                    break;
                default: [UILabel showStats:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] atView:self.view];
                    break;
            }
            

        }
    }];
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
