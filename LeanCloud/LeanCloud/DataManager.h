//
//  DataManager.h
//  LeanCloud
//
//  Created by yuebin on 16/8/31.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, strong)NSMutableArray *dataArray;

+ (DataManager *)getSharedInstance;

@end
