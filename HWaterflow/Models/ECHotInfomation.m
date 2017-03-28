//
//  ECHotInfomation.m
//  ECCustomer
//
//  Created by yellowei on 16/9/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECHotInfomation.h"

@implementation ECHotInfomation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             @"className":@"class",
             };
}

@end
