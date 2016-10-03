//
//  NSMutableArray+sync.h
//  LeanCloud
//
//  Created by yuebin on 16/9/2.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (sync)


- (void)yb_addObject:(id)object;

- (void)yb_removeObjectAtIndex:(NSInteger)index;

- (void)clearLocalInfo;

@end
