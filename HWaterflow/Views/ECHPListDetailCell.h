//
//  ECHPListDetailCell.h
//  ECCustomer
//
//  Created by yellowei on 16/8/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECHotInfomation.h"

@interface ECHPListDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) ECHotInfomation * hotInfo;

@end
