//
//  ExpressDetailTableViewCell.h
//  LeanCloud
//
//  Created by yuebin on 16/8/28.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressModel.h"

@interface ExpressDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *datetime;
@property (weak, nonatomic) IBOutlet UILabel *zone;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (nonatomic, strong)ExpressModel *model;

@end
