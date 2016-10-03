//
//  InitialPageViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/12.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "InitialPageViewController.h"
#import "MainPageViewController.h"



@interface InitialPageViewController ()

@end

@implementation InitialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeRootVC:(UIButton *)sender {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MainPageViewController alloc]init];
    
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
