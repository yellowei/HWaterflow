//
//  ECHPSmallBtnCell.h
//  ECCustomer
//
//  Created by yellowei on 16/8/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECHPSmallBtnModel.h"

@interface ECHPSmallBtnCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *btnImageView;

@property (weak, nonatomic) IBOutlet UILabel *btnTitleLabel;

@property (nonatomic, strong) ECHPSmallBtnModel * btnModel;

@end
