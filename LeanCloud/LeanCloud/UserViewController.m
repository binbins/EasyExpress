//
//  UserViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/22.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIBarButtonItem *leftItem;

@end

@implementation UserViewController {

    __weak IBOutlet UIImageView *_userIcon;

    __weak IBOutlet UILabel *_nickName;
    
    __weak IBOutlet UILabel *_phoneNumber;
}

#pragma mark- 懒加载

- (UIImageView *)icon {
    if (!_icon) {
        _icon = _userIcon;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIcon)];
        [_userIcon addGestureRecognizer:tap];
    }
    return _icon;
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



- (UILabel *)name {
    if (!_name) {
        _name = _nickName;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeName)];
//        [_name addGestureRecognizer:tap];
    }

    return _name;
}

- (UILabel *)phone {
    if (!_phone) {
        _phone = _phoneNumber;
    }
    return _phone;
}

#pragma mark - 点击事件
- (void)dismissSelf{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)postNotiAfterUserInfoChanged {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"userinfochanged" object:nil];

}

#pragma mark - UIAlertControllerStyleSheet
//先调用ActionSheet，再用UIImagePickcontroller,
- (void)changeIcon {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"更改用户头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //创建动作
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]; //取消
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
        [self jumpToCameraOrAlbumBy:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //我的相册
        [self jumpToCameraOrAlbumBy:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    //添加动作
    [sheet addAction:cancle];
    [sheet addAction:camera];
    [sheet addAction:album];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)jumpToCameraOrAlbumBy:(NSUInteger )sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:^{
        //跳转后有什么想做的，写在这里
    }];
    
}

#pragma mark - UIAlertControllerStyleAlert
- (IBAction)changeNameAction:(id)sender {
    UIAlertController *alart = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入新昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alart addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.text = [AVUser currentUser].username;
    }];
    
    //添加action
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //在这里进行更改用户数据
        UITextField *nameField = alart.textFields.firstObject;
        [[AVUser currentUser]setObject:nameField.text forKey:@"username"];
        [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                _name.text = [NSString stringWithFormat:@"昵称：%@",nameField.text];   //更改当前页面
                [self postNotiAfterUserInfoChanged];
            }else {
                [UILabel showStats:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] atView:self.view];   //改名不成功就打印错误
            }
        }];
        
    }];
    [alart addAction:cancleAction];
    [alart addAction:confirmAction];
    [self presentViewController:alart animated:YES completion:nil];
}


- (IBAction)logOut:(UIButton *)sender {
    
    UIAlertController *alartController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要退出吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消后执行的操作
    }];
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [AVUser logOut];
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];;
    }];
    
    [alartController addAction:cancleAction];
    [alartController addAction:logoutAction];
    
    //显示，类似于show
    [self presentViewController:alartController animated:YES completion:^{
        //弹出后执行的事件
    }];
}



#pragma mark- viewdidload
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"个人资料";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    //这一页暂时只要一个头像、昵称和绑定的手机号
    AVUser *user = [AVUser currentUser];
    self.name.text = [NSString stringWithFormat:@"昵称：%@",user.username];
    self.phone.text = [NSString stringWithFormat:@"绑定手机号：%@",user.mobilePhoneNumber];
    
    //先判断用户是否已经设置头像
    NSString *avatarFileID = [AVUser currentUser][@"avatarFileID"];
    if (avatarFileID != nil) {  //这一步可以优化
        [AVFile getFileWithObjectId:avatarFileID withBlock:^(AVFile *file, NSError *error) {
            
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [self.icon setImage:[UIImage imageWithData:data]];
            }];
        }];
        
    }else {
        [self.icon setImage:[UIImage imageNamed:@"ico-touxiang@3x.png"]];
        
    }

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField selectAll:self];
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *touxiang = info[@"UIImagePickerControllerEditedImage"];
    [_userIcon setImage:touxiang];
    
    //使用AVFile上传到云端，并需要关联一下
    NSData *imageData = UIImageJPEGRepresentation(touxiang, 0.5);
    
    //官方不建议对AVFile进行更新
    AVFile *file = [AVFile fileWithName:@"avatar.png" data:imageData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [UILabel showStats:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] atView:self.view];
        }else {
            
            //不能像关联objiect那样关联，就用user去存储file的id
            [[AVUser currentUser]setObject:file.objectId forKey:@"avatarFileID"];
            [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (!succeeded) {
                    [UILabel showStats:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] atView:self.view];
                }else {
                    [self postNotiAfterUserInfoChanged];
                }
            }];
            
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
