//
//  DataManager.m
//  LeanCloud
//
//  Created by yuebin on 16/8/31.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static dispatch_once_t predict;
static DataManager *manager = nil;

+ (DataManager *)getSharedInstance {
    
    //括号里的内容在启动中只执行一次
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
    
        
        AVUser *user = [AVUser currentUser];
        if (!user) {    //要求没有登录也可以正常使用
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myexpress.archiver"];
            BOOL flag = [[NSFileManager defaultManager]fileExistsAtPath:path];
            if (flag) { //本地获取
                manager.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            }else { //重新创建
                manager.dataArray = [[NSMutableArray alloc]init];
            }
        }else { //用户已经登录过了(从网上获取一个object，然后从中取出字典)
            //或者尝试关联，存id的方法获取
            
            NSMutableArray *expressList = [[AVUser currentUser] objectForKey:@"MyExpressList"];
            if (expressList) {   //用户该字段有数据
                manager.dataArray = expressList;
                
            }else {
                manager.dataArray = [[NSMutableArray alloc]init];

            }
        
        
        }
        
        
    });
    return manager;
}


@end
