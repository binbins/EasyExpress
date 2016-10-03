//
//  NSMutableArray+sync.m
//  LeanCloud
//
//  Created by yuebin on 16/9/2.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "NSMutableArray+sync.h"

@implementation NSMutableArray (sync)

- (void)yb_addObject:(id)object {
    [self addObject:object];
    [self syncCloud];
    [self syncLocal];

}

- (void)yb_removeObjectAtIndex:(NSInteger)index {
    [self removeObjectAtIndex:index];
    [self syncCloud];
    [self syncLocal];
}

- (void)clearLocalInfo {
    [self removeAllObjects]; //会出问题吗，有待商榷 /不然用再次定义的方法
    
    
}

#pragma mark - 子方法

- (void)syncCloud {
    if ([AVUser currentUser]) { //重新创建应该没有问题，获取修改也可以
//        NSDictionary *d = @{@"ExpressList":self};
//        AVObject *object = [AVObject objectWithClassName:@"MyExpress" dictionary:d];
        [[AVUser currentUser]setObject:self forKey:@"MyExpressList"];
        [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"云端同步失败");
            }
        }];
        
    }
  
}

- (void)syncLocal { //覆盖式写入

    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myexpress.archiver"];
    BOOL flag = [NSKeyedArchiver archiveRootObject:self toFile:path];
    if (flag) {
        NSLog(@"保存本地成功");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"datachanged" object:nil];
    }
}
@end
