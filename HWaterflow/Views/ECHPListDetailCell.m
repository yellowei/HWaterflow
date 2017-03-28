//
//  ECHPListDetailCell.m
//  ECCustomer
//
//  Created by yellowei on 16/8/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECHPListDetailCell.h"
//#import <UIImageView+WebCache.h>

@implementation ECHPListDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setHotInfo:(ECHotInfomation *)hotInfo
{
    _hotInfo = hotInfo;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:hotInfo.pciture]];
    self.titleLabel.text = hotInfo.title;
    self.dateLabel.text = hotInfo.datetime;
    self.contentLabel.text = hotInfo.summary;
}

@end
