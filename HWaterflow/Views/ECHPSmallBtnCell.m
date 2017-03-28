//
//  ECHPSmallBtnCell.m
//  ECCustomer
//
//  Created by yellowei on 16/8/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECHPSmallBtnCell.h"

@implementation ECHPSmallBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setBtnModel:(ECHPSmallBtnModel *)btnModel
{
    _btnModel = btnModel;
    
    self.btnImageView.image = [UIImage imageNamed:btnModel.img];
    
    self.btnTitleLabel.text = btnModel.title;
}

@end
