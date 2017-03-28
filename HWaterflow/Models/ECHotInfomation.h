//
//  ECHotInfomation.h
//  ECCustomer
//
//  Created by yellowei on 16/9/30.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECHotInfomation : NSObject

/**
 *	@brief	资讯主键ID
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *informationID;

/**
 *	@brief	标题
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *title;

/**
 *	@brief	发布时间
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString * datetime;

/**
 *	@brief	更新时间
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *updatetime;

/**
 *	@brief	发布人
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *publisher;

/**
 *	@brief	资讯链接
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *url;

/**
 *	@brief	资讯图片
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *pciture;



/**
 *	@brief	摘要
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *summary;

/**
 *	@brief	省
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *province;

/**
 *	@brief	市
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *city;

/**
 *	@brief	排序
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *displayorder;

/**
 *	@brief	类型
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *type;

/**
 *	@brief	标签
 *
 *	Created by mac on 2015-08-18 13:53
 */
@property (nonatomic, copy)NSString *className;



@end
