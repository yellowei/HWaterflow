//
//  UIButton+Extension.h
//  HWaterflow
//
//  Created by yellowei on 17/3/28.
//  Copyright © 2017年 yellowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)imageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition buttonType:(UIButtonType)buttonType;

- (void)setImageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition;

@end
