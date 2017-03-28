//
//  NSString+Extensions.h
//  Networking+Cache
//
//  Created by linsen on 15/8/18.
//  Copyright © 2015年 yellowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface NSString (ECExtensions)
/**
 *  判断字符串是否为空
 *
 *  @return YES为空 NO则否
 */
- (BOOL)isEmpty;

/**
 *  判断是否不为空字符串
 *
 *  @return YES是不为空字符串 NO则否
 */
- (BOOL)isValid;

- (BOOL)isValidMoblieNum;

/**
 *	@brief	字符串空处理
 *
 *	@return	处理后字符串
 *
 *	Created by mac on 2015-08-21 10:16
 */
- (NSString *)stringEmptyTransform;

+ (NSString *)stringEmptyTransform:(NSString *)originalStr;

- (NSComparisonResult)dateStrCompare:(NSString *)dateStr;

- (NSString *)URLEncodedString;

+ (NSString *)getPinyinWithStr:(NSString *)str;

/**
 *  移除字符串两边空格
 *
 *  @return 返回过滤后的字符串
 */
- (NSString *)removeWhiteSpacesFromString;

/**
 *  检测字符串是否包含某字符串
 *
 *  @param subString 被包含字符串
 *
 *  @return YES包含 NO则否
 */
- (BOOL)containsString:(NSString *)subString;

/**
 *  替换字符串
 *
 *  @param olderChar 被替换字符串
 *  @param newerChar 替换新的字符串
 *
 *  @return 被替换过的字符串
 */
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;

/**
 *  移除子字符串
 *
 *  @param subString 被移除的字符串
 *
 *  @return 移除后的字符串
 */
- (NSString *)removeSubString:(NSString *)subString;

/**
 *  根据字典替换字符串
 *
 *  @param dict 替换字典
 *
 *  @return 替换过的字符串
 */
- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict;

/**
 *  预定义的HTML实体转换为字符
 *
 *  @return 处理过的字符
 */
- (NSString *)specialCharsDecode;

/**
 *  格式化文件大小单位
 *
 *  @param size 文件大小(字节)
 *
 *  @return 包含大小单位的字符串
 */
+ (NSString *)converseUnitK:(long long)size;

/**
 *  格式化时间
 *
 *  @param time 秒
 *
 *  @return 格式化时间
 */
+ (NSString *)timeFormat:(NSInteger)time;

/**
 *	@brief	时间字符串转换
 *
 *	@param 	dateStr 	原始时间字符串
 *
 *	@return	转换后的字符串
 *
 *	Created by mac on 2015-08-27 11:44
 */
+ (NSString *)stringFromDateSpec:(NSString *)dateStr;

/**
 *	@brief	时间字符串转换
 *
 *	@param 	date 	时间
 *
 *	@return	转换后的字符串
 *
 *	Created by mac on 2015-09-09 17:24
 */
+ (NSString *)stringFromDate:(NSDate *)date;


/**
 *	@brief	获取周几
 *
 *	@param 	dateComponent 	时间
 *
 *	@return 周几
 *
 *	Created by mac on 2015-08-27 11:43
 */
+ (NSString *)getWeekDayWith:(NSDateComponents *)dateComponent;

/**
 *	@brief	获取颜色值
 *
 *	@param 	treatmentStr 	治疗类型
 *
 *	@return	颜色值
 *
 *	Created by mac on 2015-08-27 11:43
 */
+ (NSInteger)getColorValueWithTreatment:(NSString *)treatmentStr;

/**
 *  时间戳转文件列表时间
 *
 *  @return 格式化时间
 */
- (NSString *)timestampFormat;

/**
 *  讨论信息列表时间戳转换
 *
 *  @return 格式化时间
 */
- (NSString *)discussionTimestampFormat;

/**
 *  根据显示内容匹配高度
 *
 *  @param text     显示内容
 *  @param width    内容宽度
 *  @param fontSize 字体大小
 *
 *  @return 内容实际大小
 */
+ (CGSize)contentAutoHeightWithText:(NSString *)text textWidth:(NSUInteger)width font:(UIFont *)font;

#pragma mark 根据显示文字内容匹配文字size
+ (CGSize)contentAutoSizeWithText:(NSString *)text boundSize:(CGSize)boundSize font:(UIFont *)font NS_AVAILABLE(10_11, 7_0);

/**
 *  根据显示内容匹配宽度
 *
 *  @param text     显示内容
 *  @param height   内容高度
 *  @param font     字体
 *
 *  @return 内容实际大小
 */
+ (CGSize)contentAutoWidhttWithText:(NSString *)text textHeight:(NSUInteger)height fontSize:(CGFloat)fontSize;

/**
 *  判断输入时间是过去还是将来
 *
 *  @param timeStr 标准时间
 *
 *  @return 是否在将来
 */
+ (BOOL)isFutureWithTimeStr:(NSString *)timeStr;

/**
 *  时间样式转换
 *
 *  @param strDate 标准时间
 *
 *  @return 日期(今天明天)
 */
+(NSString*)getDateDayInfo:(NSString*)strDate;

/**
 *  时间样式转换
 *
 *  @param strDate 标准时间
 *
 *  @return 今天明天+时间
 */
+(NSString*)getDateInfo:(NSString*)strDate;
/**
 *  时间样式转换(包含了时间)
 *
 *  @param strDate 标准时间
 *
 *  @return 今天明天+时间
 */
+(NSString*)getTimeInfo:(NSString*)strDate;

/**
 *  时间样式转换(包含了时间), 显示秒
 *
 *  @param strDate 标准时间
 *
 *  @return 今天明天+时间
 */

+(NSString*)getTimeDetailInfo:(NSString*)strDate;

/**
 *  时间样式转换(历史欠款 预约)
 *
 *  @param strDate 标准时间
 *
 *  @return 今天明天+时间
 */
+(NSString*)getDateOfDebt:(NSString*)strDate;


+(NSString*)getTimeString:(NSString*)strDate;
/**
 *	@brief	金额转换
 *
 *	@param 	string 原始字符串
 *
 *	@return	处理后字符串（1,234,378.00）
 *
 *	Created by mac on 2015-09-15 20:57
 */
+(NSString*)strmethodComma:(NSString *)string;

/**
 *	@brief	年龄转换
 *
 *	@param 	birthday 	出生日期
 *
 *	@return	年龄
 *
 *	Created by mac on 2015-09-28 21:49
 */
+ (NSString *)getAgeWithBirthday:(NSString *)birthday;



/**
 *	@brief	获取随机GUID
 *
 *	@return	<#return value description#>
 *
 *	Created by mac on 2015-09-15 20:57
 */
+ (NSString *)getGUID;

/**
 *	@brief	过滤包含转义字符的字符串
 *
 *	@return	过滤后的字符串
 *
 *	Created by mac on 2015-09-15 20:57
 */
+(NSString *)filtrateStringContainTransformSubstring:(NSString *)targetStr;

/**
 *  截取url中参数
 *
 *  @param url       url
 *  @param paramName 参数key
 *
 *  @return 参数详情
 */
+ (NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName;

/**
 *  根据字体 宽度 算出换行后根据rate比例的子字符串
 *
 *  @param font        字体
 *  @param actualWidth 所占宽度
 *  @param text        输入字符串
 *  @param targetRate  宽度比例
 *
 *  @return 计算出最终字符串
 */
+ (NSString *)textWithFont:(UIFont *)font width:(CGFloat)actualWidth text:(NSString *)text rate:(CGFloat)targetRate;

+ (NSMutableString *)calculateFinalStrWithStr:(NSString *)contentStr tatgetWidth:(CGFloat )width targetHeight:(CGFloat)height font:(UIFont *)font;

/**
 *  字符串MD5加密
 */
+ (NSString *)md5HexDigest:(NSString*)input;

@end
