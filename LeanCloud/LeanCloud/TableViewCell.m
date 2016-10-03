//
//  TableViewCell.m
//  LeanCloud
//
//  Created by yuebin on 16/8/15.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell {

    __weak IBOutlet UIImageView *_icon;

    __weak IBOutlet UILabel *_orderLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MainModel *)model {

    if ([model.company isKindOfClass:[NSNull class]] || [model.no isKindOfClass:[NSNull class] ]) { }else {
    
        _orderLabel.text = [model.company stringByAppendingString:model.no];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
