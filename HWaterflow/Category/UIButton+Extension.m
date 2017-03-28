//
//  UIButton+Extension.m
//  HWaterflow
//
//  Created by yellowei on 17/3/28.
//  Copyright © 2017年 yellowei. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIView+General.h"
#import "NSString+Extensions.h"

@implementation UIButton (Extension)

+ (UIButton *)imageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition buttonType:(UIButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    [btn setImageTitleButtonWithFrame:btnFrame image:image showImageSize:imageSize title:title titleFont:titleFont imagePosition:imagePosition];
    return btn;
}

- (void)setImageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition
{
    UIButton *btn = self;
    btn.frame = btnFrame;
    [btn setImage:image forState:UIControlStateNormal];
    [btn.titleLabel setFont:titleFont];
    [btn setTitle:title forState:UIControlStateNormal];
    
    if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationDown || imagePosition == UIImageOrientationUpMirrored || imagePosition == UIImageOrientationDownMirrored)
    {
        CGFloat titleHeight = ceil(titleFont.lineHeight);
        CGFloat contentHeight = imageSize.height + 3 + titleHeight;
        if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationUpMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0, btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - titleHeight, -image.size.width, (btn.height - contentHeight)/2.0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0, (btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0)];
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, -image.size.width, btn.height - (btn.height - contentHeight)/2.0 - titleHeight, 0)];
        }
    }
    else
    {
        CGSize titleSize = [NSString contentAutoSizeWithText:title boundSize:CGSizeMake(MAXFLOAT, 20) font:titleFont];
        CGFloat contentWidth = imageSize.width + 5 + titleSize.width;
        if (imagePosition == UIImageOrientationLeft || imagePosition == UIImageOrientationLeftMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0, (btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width + imageSize.width + 5, 0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width, (btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width - imageSize.width - 5, 0, 0)];
        }
    }
}

@end

