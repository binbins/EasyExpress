//
//  ResetViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/22.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "ResetViewController.h"

@interface ResetViewController ()
@property (nonatomic, strong)UIBarButtonItem *submitBtn;

@end

@implementation ResetViewController {

    __weak IBOutlet UITextField *_phone;

    __weak IBOutlet UITextField *_verify;
    
    __weak IBOutlet UITextField *_newPassword;
    __weak IBOutlet UITextField *_secondPassword;
}

- (UIBarButtonItem *)submitBtn {

    if (!_submitBtn) {
        
//        _submitBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitNewPassword)];
        _submitBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitNewPassword)];
    }
    
    return _submitBtn;
}


- (IBAction)getVerifyNumber:(id)sender {
    
    [AVUser requestPasswordResetWithPhoneNumber:_phone.text block:^(BOOL succeeded, NSError *error) {
        
        if (!succeeded) {
            NSLog(@"%@",error);
        }
    }];
    
}


- (void)submitNewPassword {
    [AVUser resetPasswordWithSmsCode:_verify.text newPassword:_newPassword.text block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [UILabel showStats:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] atView:self.view];
        }
    }];

}





#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"找回密码";
    self.navigationItem.rightBarButtonItem = self.submitBtn;
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
