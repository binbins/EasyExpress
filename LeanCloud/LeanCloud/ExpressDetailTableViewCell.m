//
//  ExpressDetailTableViewCell.m
//  LeanCloud
//
//  Created by yuebin on 16/8/28.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "ExpressDetailTableViewCell.h"

@implementation ExpressDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ExpressModel *)model {

    if (![model.datetime isKindOfClass:[NSNull class]]) {
        
        _datetime.text = model.datetime;
    }
    if (![model.remark isKindOfClass:[NSNull class]]) {
        _remark.text = model.remark;
        
    }
    if (![model.zone isKindOfClass:[NSNull class]]) {
        
        _zone.text = model.zone;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
