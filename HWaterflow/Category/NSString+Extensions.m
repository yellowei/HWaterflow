//
//  NSString+Extensions.m
//  Networking+Cache
//
//  Created by linsen on 15/8/18.
//  Copyright © 2015年 yellowei. All rights reserved.
//

#import "NSString+Extensions.h"


static NSDateFormatter *dateFormatter;
@implementation NSString (ECExtensions)
#pragma mark 判断字符串是否为空
- (BOOL)isEmpty
{
    if ([self length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

#pragma mark 判断是否不为空字符串
- (BOOL)isValid
{
    return (self == nil || ![self isKindOfClass:[NSString class]] || [[self removeWhiteSpacesFromString] isEqualToString:@""] || [self isEqualToString:@"(null)"]) ? NO :YES;
}

- (BOOL)isValidMoblieNum
{
    if ([self isValid])
    {
        NSString *phoneRegex = @"^((13)|(14)|(15)|(16)|(17)|(18))\\d{9}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:self];
    }
    return NO;
}

- (NSString *)stringEmptyTransform
{
    if (self == nil || self == (id)[NSNull null])
    {
        return @"";
    }
    if (![self isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@", self];
    }
    return self;
}

+ (NSString *)stringEmptyTransform:(NSString *)originalStr
{
    if (originalStr == nil || originalStr == (id)[NSNull null])
    {
        return @"";
    }
    if (![originalStr isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@", originalStr];
    }
    return originalStr;
}

- (NSComparisonResult)dateStrCompare:(NSString *)dateStr
{
    if ([self isValid] && [dateStr isValid])
    {
        NSString *selfStr = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
        selfStr = [selfStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        selfStr = [selfStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        if (selfStr.length > 14)
        {
            selfStr = [selfStr substringToIndex:14];
        }
        
        while (selfStr.length < 14)
        {
            selfStr = [selfStr stringByAppendingString:@"0"];
        }
        
        NSString *compareStr = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        compareStr = [compareStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        compareStr = [compareStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        if (compareStr.length > 14)
        {
            compareStr = [compareStr substringToIndex:14];
        }
        
        while (compareStr.length < 14)
        {
            compareStr = [compareStr stringByAppendingString:@"0"];
        }
        
        if ([selfStr longLongValue] > [compareStr longLongValue])
        {
            return NSOrderedDescending;
        }
        else if ([selfStr longLongValue] == [compareStr longLongValue])
        {
            return NSOrderedSame;
        }
        else
        {
            return NSOrderedAscending;
        }
        
    }
    return NSOrderedAscending;
}

- (NSString *)URLEncodedString
{
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@":/?&=;+!@#$()',*", kCFStringEncodingUTF8);
    //return (NSString *)CFBridgingRelease(encodedString);
}

+ (NSString *)getPinyinWithStr:(NSString *)str
{
  str = [NSString stringEmptyTransform:str];
  if (str.length > 0)
  {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
      NSLog(@"pinyin: %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
      NSLog(@"pinyin: %@", ms);
    }
    NSString *tempStr = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempStr = [tempStr uppercaseString];
    return tempStr;
  }
  return str;
}

#pragma mark 移除字符串两边空格
- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

#pragma mark 检测字符串是否包含某字符串
- (BOOL)containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

#pragma mark 替换字符串
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

#pragma mark 移除子字符串
- (NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString])
    {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

#pragma mark 根据字典替换字符串
- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict
{
    NSMutableString *string = [self mutableCopy];
    for (NSString *target in dict)
    {
        [string replaceOccurrencesOfString:target
                                withString:[dict objectForKey:target]
                                   options:0
                                     range:NSMakeRange(0, [string length])];
    }
    return string;
}

#pragma mark 预定义的HTML实体转换为字符
- (NSString *)specialCharsDecode
{
    NSString *string = self;
    NSArray *strings = [NSArray arrayWithObjects:@"&nbsp;",@"&amp;",@"&lt;",@"&gt;",@"&quot;",@"&#39;", nil];
    for (NSString *stringName in strings)
    {
        NSRange foundObj = [string rangeOfString:stringName options:NSCaseInsensitiveSearch];
        if (foundObj.length > 0)
        {
            if ([stringName isEqualToString:@"&nbsp;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@" "];
            }
            if ([stringName isEqualToString:@"&amp;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@"&"];
            }
            if ([stringName isEqualToString:@"&lt;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@"<"];
            }
            if ([stringName isEqualToString:@"&gt;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@">"];
            }
            if ([stringName isEqualToString:@"&quot;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@""];
            }
            if ([stringName isEqualToString:@"&#39;"]) {
                string = [string stringByReplacingOccurrencesOfString:stringName withString:@"'"];
            }
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        }
    }
    return string;
}

#pragma mark 格式化文件大小单位
+ (NSString *)converseUnitK:(long long)size
{
    long GSize = 1 * 1024 * 1024 * 1024; //1G等于这么多B
    long MBSize = 1 * 1024 * 1024;       //1MB等于这么多B
    long KBSize = 1 * 1024;
    
    NSString *sizeString = @"";
    if (size >= GSize) {
        //说明大小已经到G以上了
        unsigned long long kb = size / 1024;
        unsigned long long mb = kb / 1024;
        unsigned long long G = mb / 1024;
        sizeString = [[NSString alloc] initWithFormat:@"%lldG",G];
    }
    else if (size > MBSize) {
        //说明大小在M 和 G 之间
        unsigned long long kb = size / 1024;
        unsigned long long mb = kb / 1024;
        sizeString = [[NSString alloc] initWithFormat:@"%lldMB",mb];
    }
    else if (size > KBSize) {
        unsigned long long kb = size / 1024;
        sizeString = [[NSString alloc] initWithFormat:@"%lldKB",kb];
    }
    else if (size <= KBSize){
        unsigned long long kb = size;
        sizeString = [[NSString alloc] initWithFormat:@"%lldB",kb];
    }
    return sizeString;
}

#pragma mark 格式化时间
+ (NSString *)timeFormat:(NSInteger)time
{
    NSString *result = @"00:00";
    if (time >= 3600) {
        NSInteger hour = time/3600;
        NSInteger minute = (time-hour*3600)/60;
        NSInteger second = time-hour*3600-minute*60;
        
        NSString *hourString = [[NSString alloc] initWithFormat:@"%zd",hour];
        if(hour < 10) {
            hourString = [[NSString alloc] initWithFormat:@"0%zd",hour];
        }
        
        NSString *minString = [[NSString alloc] initWithFormat:@"%zd",minute];
        if(minute < 10) {
            minString = [[NSString alloc] initWithFormat:@"0%zd",minute];
        }
        
        NSString *secondString = [[NSString alloc] initWithFormat:@"%zd",second];
        if(second < 10) {
            secondString = [[NSString alloc] initWithFormat:@"0%zd",second];
        }
        result = [[NSString alloc] initWithFormat:@"%@:%@:%@",hourString,minString,secondString];
    }
    else if (time < 3600 && time > 0) {
        NSInteger minute = time/60;
        NSInteger second = time-minute*60;;
        NSString *minString = [[NSString alloc] initWithFormat:@"%zd",minute];
        if(minute < 10) {
            minString = [[NSString alloc] initWithFormat:@"0%zd",minute];
        }
        
        NSString *secondString = [[NSString alloc] initWithFormat:@"%zd",second];
        if(second < 10) {
            secondString = [[NSString alloc] initWithFormat:@"0%zd",second];
        }
        result = [[NSString alloc] initWithFormat:@"%@:%@",minString,secondString];
    }
    return result;
}

+ (NSString *)stringFromDateSpec:(NSString *)dateStr
{
    if (dateStr == nil || dateStr.length < 10) {
        return dateStr;
    }
    
    //时间标签设置
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [NSDate date];
    NSString *timeString = @"";
    unsigned unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekdayCalendarUnit;
    
    NSCalendar *theCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; //[NSCalendar currentCalendar];
    [theCalendar setTimeZone:timeZone];
    NSDateComponents *comps = [theCalendar components:unitFlags fromDate:date];
    int nowmonth = (int)[comps month];
    int nowday = (int)[comps day];
    int nowyear = (int)[comps year];
    int nowWeekday = (int)[comps weekday];
    
    NSString *strToday = [NSString stringWithFormat:@"%d/%.2d/%.2d 00:00:00", nowyear, nowmonth, nowday];
    
    if (!dateFormatter)
    {
      dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *dateToday = [dateFormatter dateFromString:strToday];
    NSDate *dateMessage = [dateFormatter dateFromString:dateStr];
    
    comps = [theCalendar components:unitFlags fromDate:dateMessage];
    int showYear = (int)[comps year];
    int showHour = (int)[comps hour];
    int showMinute = (int)[comps minute];
    int showMonth = (int)[comps month];
    int showDay = (int)[comps day];
    int weekDay = (int)[comps weekday];
    int inWeek = [dateToday timeIntervalSinceDate:dateMessage]/(3600 * 24);
    
    if ([[dateMessage earlierDate:dateToday] isEqualToDate:dateToday] ) {
        timeString = [NSString stringWithFormat:@"%.2d:%.2d", showHour, showMinute] ;
    }
    else if(0 == inWeek) {
        timeString = @"昨天";
    }
    // Modify by Mark 2014-02-13
    //    else if(1 == inWeek) {
    //        timeString = @"前天";
    //    }
    //    else if (inWeek < 7) {
    // nowWeekday本来就要减一，再要减掉周日，所以减2了
    // 中国日历，星期一起，我操！！！
    else if((inWeek < nowWeekday-2) && (nowWeekday-weekDay > 0)) {
        NSArray *weekName = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        timeString = [NSString stringWithFormat:@"星期%@", [weekName objectAtIndex:weekDay-1]];
    }
    // 本年度内只显示月日
    // Add by Mark 2014-02-12
    else if (showYear == nowyear) {
        timeString = [NSString stringWithFormat:@"%.2d/%.2d", showMonth, showDay];
    }
    // End Add
    else {
        // 年数两位数
        // Modify by Mark 2014-03-17
        timeString = [NSString stringWithFormat:@"%d/%.2d/%.2d", showYear, showMonth, showDay] ;
    }
    
    return timeString;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    if (!date || ![date isKindOfClass:[NSDate class]])
    {
        date = [NSDate date];
        
    }
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *)getWeekDayWith:(NSDateComponents *)dateComponent
{
    NSString *strWeek = @"";
    if (dateComponent && [dateComponent isKindOfClass:[NSDateComponents class]])
    {
        NSInteger nWeekend = ([dateComponent weekday]-1)%7;
        switch (nWeekend) {
            case 0:
                strWeek = @"周日";
                break;
            case 1:
                strWeek = @"周一";
                break;
            case 2:
                strWeek = @"周二";
                break;
            case 3:
                strWeek = @"周三";
                break;
            case 4:
                strWeek = @"周四";
                break;
            case 5:
                strWeek = @"周五";
                break;
            case 6:
                strWeek = @"周六";
                break;
            default:
                break;
        }
    }
    return strWeek;
}

+ (NSInteger)getColorValueWithTreatment:(NSString *)treatmentStr
{
  treatmentStr = [NSString stringEmptyTransform:treatmentStr];
  treatmentStr = [treatmentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([treatmentStr hasPrefix:@"治疗"])
    {
        return 0x00c5b5;
    }
    else if ([treatmentStr hasPrefix:@"修复"])
    {
      return 0xea82c4;
    }
    else if ([treatmentStr hasPrefix:@"种植"])
    {
        return 0x8cb839;
    }
    else if ([treatmentStr hasPrefix:@"正畸"])
    {
        return 0xf86d5a;
    }
    else if ([treatmentStr hasPrefix:@"检查"])
    {
        return 0x9282ea;
    }
    else if ([treatmentStr hasPrefix:@"洗牙"])
    {
        return 0x72b0e5;
    }
    else if ([treatmentStr hasPrefix:@"其他"])
    {
        return 0x9ac66a;
    }
    else
    {
      NSInteger randNum = rand()/3;
      switch (randNum)
      {
        case 0:
          return 0xffaa29;
          break;
        case 1:
          return 0x65c4df;
          break;
        case 2:
        default:
          return 0x59c997;
          break;
      }
    }
    return 0x59c997;
}


#pragma mark 时间戳转文件列表时间
- (NSString *)timestampFormat
{
    NSString *timestamp = self;
    if (nil == timestamp) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; // zh_CN en_US
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

#pragma mark 讨论信息列表时间戳转换
- (NSString *)discussionTimestampFormat
{
    NSString *timestamp = [self timestampFormat];
    if (nil == timestamp) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSDate *date = [formatter dateFromString:timestamp];
    NSDate *now = [NSDate date];
    
    // 比较发送时间和当前时间
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    if (delta < 60) {
        // 1分钟以内
        return @"刚刚";
    }
    else if (delta < 60 * 60) {
        // 60分钟以内
        return [[NSString alloc] initWithFormat:@"%.f分钟前", delta/60];
    }
    else if (delta < 60 * 60 * 24) {
        // 24小时内
        return [[NSString alloc] initWithFormat:@"%.f小时前", delta/(60 * 60)];
    }
    
    return timestamp;
}

#pragma mark 根据显示内容匹配高度
+ (CGSize)contentAutoHeightWithText:(NSString *)text textWidth:(NSUInteger)width font:(UIFont *)font
{
    if (![text isValid])
    {
        text = @"";
    }
    if (font == nil)
    {
        font = [UIFont systemFontOfSize:15];
    }
    CGSize size = CGSizeMake(width, MAXFLOAT);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }
    else
    {
      size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

#pragma mark 根据显示文字内容匹配文字size
+ (CGSize)contentAutoSizeWithText:(NSString *)text boundSize:(CGSize)boundSize font:(UIFont *)font
{
  CGSize size = CGSizeZero;
  text = [NSString stringEmptyTransform:text];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
  {
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:boundSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
  }
  return size;
}

+ (CGSize)contentAutoWidhttWithText:(NSString *)text textHeight:(NSUInteger)height fontSize:(CGFloat)fontSize
{
    CGSize Size;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
         Size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        
        
    }
    else
    {
         Size = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(MAXFLOAT, height)
                           lineBreakMode:NSLineBreakByWordWrapping];
    }
    return Size;
}

+ (BOOL)isFutureWithTimeStr:(NSString *)timeStr
{
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
  
  NSDate* dateGet = [formatter dateFromString:timeStr];
  NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
  NSInteger interval1 = [zone1 secondsFromGMTForDate:dateGet];
  NSDate *inputDate = [dateGet dateByAddingTimeInterval:interval1];
  
  //本地当前时间
  NSDate *datenow = [NSDate date];
  NSTimeZone *zone = [NSTimeZone systemTimeZone];
  NSInteger interval = [zone secondsFromGMTForDate:datenow];
  NSDate *localDate = [datenow dateByAddingTimeInterval:interval];
  
  if ((long)[inputDate timeIntervalSince1970]>(long)[localDate timeIntervalSince1970]) {
    return YES;
  }else{
    return NO;
  }
}

+(NSString*)getTimeDetailInfo:(NSString*)strDate
{
    if (nil==strDate || strDate.length==0) {
        return @"";
    }
    
    static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strDate];
    
    if (nil == date)
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [formatter dateFromString:strDate];
    }
    
    if (nil==date) {
        return @"";
    }
    
    NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
    NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
    NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
    compsYesterday.day -= 1;
    NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
    compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
    
    long lInterval = 0-date.timeIntervalSinceNow;   // 秒
    
    if (lInterval < 0){
        NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsTomorrow.day += 1;
        NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
        compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
        
        NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsAfterTomorrow.day += 2;
        NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
        compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
        
        if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
            return [NSString stringWithFormat:@"今天 %zd:%02zd:%02zd", compsDate.hour, compsDate.minute, compsDate.second];
        }
        else
        {
            return [NSString stringWithFormat:@"%zd/%zd/%zd %zd:%zd:%zd", compsDate.year, compsDate.month, compsDate.day, compsDate.hour, compsDate.minute, compsDate.second];
        }
    }
    //    else if (lInterval < (hour/12))
    //    {
    //        return @"刚刚";
    //    }
    //    else if (lInterval < hour) {
    //        return [NSString stringWithFormat:@"%02zd分钟前", lInterval/(hour/60)];
    //    }
    else if (compsNow.year==compsDate.year && compsNow.month==compsDate.month &&compsDate.day == compsNow.day){
        NSInteger nHour = compsDate.hour;
        //凌晨
        if (0<=nHour && nHour<6) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute,compsDate.second];
        }
        //早上
        else if (6<=nHour && nHour<8) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute, compsDate.second];
        }
        //上午
        else if (8<=nHour && nHour<12) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute,compsDate.second];
        }
        //中午
        else if (12<=nHour && nHour<13) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute, compsDate.second];
        }
        //下午
        else if (13<=nHour && nHour<18) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute, compsDate.second];
        }
        //晚上
        else if (18<=nHour && nHour<24) {
            return [NSString stringWithFormat:@"%zd:%02zd:%02zd", compsDate.hour, compsDate.minute, compsDate.second];
        }
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day)
    {
        return [NSString stringWithFormat:@"昨天 %zd:%02zd:%02zd", compsDate.hour, compsDate.minute,compsDate.second];
    }
    else if (compsNow.year==compsDate.year)
    {
        return [NSString stringWithFormat:@"%zd月%zd日 %zd:%02zd:%02zd", compsDate.month, compsDate.day, compsDate.hour, compsDate.minute, compsDate.second];
    }
    else
    {
        return [NSString stringWithFormat:@"%zd/%zd/%zd %zd:%02zd:%02zd", compsDate.year, compsDate.month, compsDate.day, compsDate.hour, compsDate.minute, compsDate.second];
    }
    
    return strDate;
}

+(NSString*)getTimeInfo:(NSString*)strDate
{
    if (nil==strDate || strDate.length==0) {
        return @"";
    }
  
    static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strDate];
    
    if (nil == date)
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [formatter dateFromString:strDate];
    }
    
    if (nil==date) {
        return @"";
    }
    
    NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
    NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
    NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
    compsYesterday.day -= 1;
    NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
    compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
    
    long lInterval = 0-date.timeIntervalSinceNow;   // 秒
    
    if (lInterval < 0){
        NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsTomorrow.day += 1;
        NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
        compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
        
        NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsAfterTomorrow.day += 2;
        NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
        compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
        
        if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
            return [NSString stringWithFormat:@"今天 %zd:%02zd", compsDate.hour, compsDate.minute];
        }
        else
        {
            return [NSString stringWithFormat:@"%zd/%zd/%zd %zd:%zd:%zd", compsDate.year, compsDate.month, compsDate.day, compsDate.hour, compsDate.minute, compsDate.minute];
        }
    }
//    else if (lInterval < (hour/12))
//    {
//        return @"刚刚";
//    }
//    else if (lInterval < hour) {
//        return [NSString stringWithFormat:@"%02zd分钟前", lInterval/(hour/60)];
//    }
    else if (compsNow.year==compsDate.year && compsNow.month==compsDate.month &&compsDate.day == compsNow.day){
        NSInteger nHour = compsDate.hour;
        //凌晨 
        if (0<=nHour && nHour<6) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
        //早上
        else if (6<=nHour && nHour<8) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
        //上午
        else if (8<=nHour && nHour<12) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
        //中午
        else if (12<=nHour && nHour<13) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
        //下午
        else if (13<=nHour && nHour<18) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
        //晚上
        else if (18<=nHour && nHour<24) {
            return [NSString stringWithFormat:@"%zd:%02zd", compsDate.hour, compsDate.minute];
        }
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day)
    {
        return [NSString stringWithFormat:@"昨天 %zd:%02zd", compsDate.hour, compsDate.minute];
    }
    else if (compsNow.year==compsDate.year)
    {
      return [NSString stringWithFormat:@"%zd月%zd日 %zd:%02zd", compsDate.month, compsDate.day, compsDate.hour, compsDate.minute];
    }
    else
    {
        return [NSString stringWithFormat:@"%zd/%zd/%zd %zd:%02zd", compsDate.year, compsDate.month, compsDate.day, compsDate.hour, compsDate.minute];
    }
    
    return strDate;
}

+(NSString*)getTimeString:(NSString*)strDate
{
    if (nil==strDate || strDate.length==0) {
        return @"";
    }
    
    static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strDate];
    
    if (nil==date) {
        return @"";
    }
    
    NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
    NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
    NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
    compsYesterday.day -= 1;
    NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
    compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
    
    long lInterval = 0-date.timeIntervalSinceNow;   // 秒
    
    if (lInterval < 0){
        NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsTomorrow.day += 1;
        NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
        compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
        
        NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsAfterTomorrow.day += 2;
        NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
        compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
        
        if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
            return @"今天";
        }
        else
        {
            return [NSString stringWithFormat:@"%02zd/%02zd/%02zd", compsDate.year, compsDate.month, compsDate.day];
        }
    }
    else if (compsNow.year==compsDate.year && compsNow.month==compsDate.month &&compsDate.day == compsNow.day){
       return @"今天";
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
        return @"昨天";
    }
    else if (compsNow.year==compsDate.year) {
        return [NSString stringWithFormat:@"%02zd/%02zd", compsDate.month, compsDate.day];
    }
    else {
        return [NSString stringWithFormat:@"%02zd/%02zd/%02zd", compsDate.year, compsDate.month, compsDate.day];
    }
    
    return strDate;
}

+(NSString*)getDateDayInfo:(NSString*)strDate
{
  if (nil==strDate || strDate.length==0) {
    return @"";
  }
  
  static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
  
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSDate* date = [formatter dateFromString:strDate];
  
  if (nil==date) {
    return @"";
  }
  
  NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
  NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
  NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
  compsYesterday.day -= 1;
  NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
  compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
  
  long lInterval = 0-date.timeIntervalSinceNow;   // 秒
  
  if (lInterval < 0)
  {
    NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
    compsTomorrow.day += 1;
    NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
    compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
    
    NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
    compsAfterTomorrow.day += 2;
    NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
    compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
    
    if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
      return @"今天";
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
      return @"明天";
    }
    else if (compsAfterTomorrow.year==compsDate.year && compsAfterTomorrow.month==compsDate.month && compsAfterTomorrow.day==compsDate.day) {
      return @"后天";
    }
    else
    {
      return [NSString stringWithFormat:@"%d-%d-%d", (int)compsDate.year, (int)compsDate.month, (int)compsDate.day];
    }
  }
  else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month &&compsDate.day == compsNow.day){
    return @"今天";
  }
  else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
    return @"昨天";
  }
  else if (compsYesterday.year==compsDate.year)
  {
    return [NSString stringWithFormat:@"%02zd-%02zd", compsDate.month, compsDate.day];
  }
  else
  {
    return [NSString stringWithFormat:@"%zd-%02zd-%02zd", compsDate.year, compsDate.month, compsDate.day];
  }
  return strDate;
}

+(NSString*)getDateInfo:(NSString*)strDate
{
    if (nil==strDate || strDate.length==0) {
        return @"";
    }
    
    static int hour = 60*60;
    static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strDate];
    
    if (nil==date) {
        return @"";
    }
    
    NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
    NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
    NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
    compsYesterday.day -= 1;
    NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
    compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
    
    long lInterval = 0-date.timeIntervalSinceNow;   // 秒
    
    if (lInterval < 0)
    {
        NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsTomorrow.day += 1;
        NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
        compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
        
        NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
        compsAfterTomorrow.day += 2;
        NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
        compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
        
        if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
            return [NSString stringWithFormat:@"今天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
            return [NSString stringWithFormat:@"明天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (compsAfterTomorrow.year==compsDate.year && compsAfterTomorrow.month==compsDate.month && compsAfterTomorrow.day==compsDate.day) {
            return [NSString stringWithFormat:@"后天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else
        {
            return [NSString stringWithFormat:@"%d/%d/%d", (int)compsDate.year, (int)compsDate.month, (int)compsDate.day];
        }
    }
    else if (lInterval < (hour/12)) {
        return @"刚刚";
    }
    else if (lInterval < hour) {
        return [NSString stringWithFormat:@"%d分钟前", (int)lInterval/(hour/60)];
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month &&compsDate.day == compsNow.day){
        NSInteger nHour = compsDate.hour;
        if (0<=nHour && nHour<6) {
            return [NSString stringWithFormat:@"凌晨 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (6<=nHour && nHour<8) {
            return [NSString stringWithFormat:@"早上 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (8<=nHour && nHour<12) {
            return [NSString stringWithFormat:@"上午 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (12<=nHour && nHour<13) {
            return [NSString stringWithFormat:@"中午 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (13<=nHour && nHour<18) {
            return [NSString stringWithFormat:@"下午 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
        else if (18<=nHour && nHour<24) {
            return [NSString stringWithFormat:@"晚上 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
        }
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
        return [NSString stringWithFormat:@"昨天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
    }
    else {
        return [NSString stringWithFormat:@"%d/%d/%d", (int)compsDate.year, (int)compsDate.month, (int)compsDate.day];
    }
    
    return strDate;
}

+(NSString*)getDateOfDebt:(NSString*)strDate
{
  if (nil==strDate || strDate.length==0) {
    return @"";
  }
  
//  static int hour = 60*60;
  static NSUInteger uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
  
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  NSDate* date = [formatter dateFromString:strDate];
  
  if (nil==date) {
    return @"";
  }
  
  NSDateComponents* compsDate = [calendar components:uintFlags fromDate:date];
  NSDateComponents* compsNow = [calendar components:uintFlags fromDate:[NSDate date]];
  NSDateComponents* compsYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
  compsYesterday.day -= 1;
  NSDate* dateYesterday= [calendar dateFromComponents:compsYesterday];
  compsYesterday = [calendar components:uintFlags fromDate:dateYesterday];
  
  NSDateComponents* compsBeforeYesterday = [calendar components:uintFlags fromDate:[NSDate date]];
  compsBeforeYesterday.day -= 2;
  NSDate* dateBeforeYesterday= [calendar dateFromComponents:compsBeforeYesterday];
  compsBeforeYesterday = [calendar components:uintFlags fromDate:dateBeforeYesterday];
  
  long lInterval = 0-date.timeIntervalSinceNow;   // 秒
  
  if (lInterval < 0)
  {
    NSDateComponents* compsTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
    compsTomorrow.day += 1;
    NSDate* dateTomorrow= [calendar dateFromComponents:compsTomorrow];
    compsYesterday = [calendar components:uintFlags fromDate:dateTomorrow];
    
    NSDateComponents* compsAfterTomorrow = [calendar components:uintFlags fromDate:[NSDate date]];
    compsAfterTomorrow.day += 2;
    NSDate* dateAfterTomorrow = [calendar dateFromComponents:compsAfterTomorrow];
    compsAfterTomorrow = [calendar components:uintFlags fromDate:dateAfterTomorrow];
    
    if (compsNow.year==compsDate.year && compsNow.month==compsDate.month && compsNow.day==compsDate.day) {
      return [NSString stringWithFormat:@"今天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
    }
    else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
      return [NSString stringWithFormat:@"明天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
    }
    else if (compsAfterTomorrow.year==compsDate.year && compsAfterTomorrow.month==compsDate.month && compsAfterTomorrow.day==compsDate.day) {
      return [NSString stringWithFormat:@"后天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
    }
    else
    {
      if (compsNow.year == compsDate.year) {
        return [NSString stringWithFormat:@"%d/%d %d:%02d", (int)compsDate.month, (int)compsDate.day, (int)compsDate.hour, (int)compsDate.minute];
      }else{
      return [NSString stringWithFormat:@"%d/%d/%d %d:%02d", (int)compsDate.year, (int)compsDate.month, (int)compsDate.day, (int)compsDate.hour, (int)compsDate.minute];
      }
    }
  
  }
  else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month &&compsDate.day == compsNow.day){
      return [NSString stringWithFormat:@"今天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
  }
  else if (compsYesterday.year==compsDate.year && compsYesterday.month==compsDate.month && compsYesterday.day==compsDate.day) {
    return [NSString stringWithFormat:@"昨天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
  }
  else if (compsBeforeYesterday.year==compsDate.year && compsBeforeYesterday.month==compsDate.month && compsBeforeYesterday.day==compsDate.day) {
    return [NSString stringWithFormat:@"前天 %d:%02d", (int)compsDate.hour, (int)compsDate.minute];
  }
  else {
    if (compsNow.year == compsDate.year) {
      return [NSString stringWithFormat:@"%d/%d %d:%02d",(int)compsDate.month, (int)compsDate.day, (int)compsDate.hour, (int)compsDate.minute];
    }else{
      return [NSString stringWithFormat:@"%d/%d/%d %d:%02d", (int)compsDate.year, (int)compsDate.month, (int)compsDate.day, (int)compsDate.hour, (int)compsDate.minute];
    }
    
  }
  
  return strDate;
}




+(NSString*)strmethodComma:(NSString *)string
{
  string = [NSString stringEmptyTransform:string];
    if (![string isValid])
    {
        return @"0.00";
    }
  double floatValue = [string doubleValue];
  floatValue = nearbyint(floatValue*100);
  floatValue = floatValue/100.00;
  string = [NSString stringWithFormat:@"%f", floatValue];
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"])
    {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    NSArray *array = [string componentsSeparatedByString:@"."];
    if ([array count] > 0)
    {
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *tempStr = array[0];
        NSInteger i = tempStr.length;
        NSInteger j = tempStr.length;
        while (j > 0) {
            j--;
            if (i - j == 3 || j == 0)
            {
                [values insertObject:[tempStr substringWithRange:NSMakeRange(j, i-j)] atIndex:0];
                i = j;
            }
        }
        if ([values count] > 0)
        {
            string = [values componentsJoinedByString:@","];
        }
        else
        {
            string = @"0";
        }
        if ([array count] > 1)
        {
            tempStr = array[1];
        }
        else
        {
            tempStr = @"";
        }
        if (tempStr.length > 2)
        {
            tempStr = [tempStr substringWithRange:NSMakeRange(0, 2)];
        }
        while (tempStr.length < 2)
        {
            tempStr = [tempStr stringByAppendingString:@"0"];
        }
        string = [string stringByAppendingFormat:@".%@", tempStr];
        
    }
    else
    {
        string = @"0.00";
    }
    if (sign)
    {
        string = [NSString stringWithFormat:@"%@%@", sign, string];
        //string = [NSString stringWithFormat:@"%@", string];
    }
    return string;
}

+ (NSString *)getAgeWithBirthday:(NSString *)birthday
{
    if (birthday.length > 4)
    {
        NSString *str1 = [birthday substringToIndex:4];
        NSString *now = [NSString stringFromDate:nil];
        NSString *str2 = [now substringToIndex:4];
        NSInteger value = [str2 integerValue] - [str1 integerValue];
        if (value > 0)
        {
            return [NSString stringWithFormat:@"%zd", value];
        }
    }
    return @"";
}

+ (NSString *)getGUID
{
    NSString* strGUID = nil;
    unsigned   unTime = (unsigned)time(0);
    unsigned   num1 = arc4random() % 100;
    unsigned   num2 = arc4random() % 100;
    unsigned   num3 = arc4random() % 100;
    unsigned   num4 = arc4random() % 10;
    //unsigned   num5 = arc4random() % 100;
    strGUID = [NSString stringWithFormat:@"%d%02d%02d%02d%d", unTime, num1, num2, num3, num4];
  //strGUID = [NSString stringWithFormat:@"%d%02d%02d%02d%02d%02d", unTime, num1, num2, num3, num4, num5];
    return strGUID;
}

+(NSString *)filtrateStringContainTransformSubstring:(NSString *)targetStr
{
  if (![targetStr isValid]) {
    return @"";
  }
  targetStr = [[targetStr stringByReplacingOccurrencesOfString:@"\t" withString:@""] mutableCopy];
  targetStr = [[targetStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "] mutableCopy];
  NSString *overViewStr = targetStr;
  NSInteger index = 0;
  while (overViewStr.length  > index) {
    NSString *tempStr = [overViewStr substringWithRange:NSMakeRange(index, 1)];
    if ([tempStr isEqualToString:@" "]) {
      index++;
    }else if([tempStr isEqualToString:@"\t"]||[tempStr isEqualToString:@"\n"]||[tempStr isEqualToString:@"\r"]){
      index++;
    }else{
      break;
    }
  }
  if (index > 0) {
    overViewStr = [overViewStr stringByReplacingCharactersInRange:NSMakeRange(0, index) withString:@""];
  }

  return overViewStr;
}

//截取url中参数
+ (NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName
{
  if (![paramName hasSuffix:@"="]) {
    paramName = [NSString stringWithFormat:@"%@=", paramName];
  }
  
  NSString *str = nil;
  NSRange   start = [url rangeOfString:paramName];
  if (start.location != NSNotFound) {
    // confirm that the parameter is not a partial name match
    unichar  c = '?';
    if (start.location != 0) {
      c = [url characterAtIndex:start.location - 1];
    }
    if (c == '?' || c == '&' || c == '#') {
      NSRange     end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
      NSUInteger  offset = start.location + start.length;
      str = end.location == NSNotFound ?
      [url substringFromIndex:offset] :
      [url substringWithRange:NSMakeRange(offset, end.location)];
      str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
  }
  return str;
}

+ (NSString *)textWithFont:(UIFont *)font width:(CGFloat)actualWidth text:(NSString *)text rate:(CGFloat)targetRate
{
  if (!font) {
    font = [UIFont systemFontOfSize:15.0f];
  }
  if (!actualWidth ||actualWidth == 0) {
    actualWidth = 10;
  }
  if (!text||text.length == 0) {
    text = @"";
  }
  if (!targetRate||targetRate == 0) {
    targetRate = 1.0f;
  }
  
  CGFloat targetWidth = actualWidth * targetRate;
  targetWidth = floor(targetWidth);
  
  CGFloat index         = floorf(text.length / 2.0f);
  CGFloat currentLength = text.length;
  NSString *finalText   = [text substringToIndex:index];
  CGFloat width         = 0.0f;
  CGFloat lastIndex     = 0.0f;
  
  do {
    
    CGSize textSize = [finalText sizeWithAttributes:@{NSFontAttributeName :font}];
    
    width = ceil(textSize.width);
    
    currentLength = floorf(currentLength / 2.0f);
    
    if (width < targetWidth) {
      
      index = index + 0.5 * currentLength;
      finalText = [text substringToIndex:index];
      
    } else if (width > targetWidth) {
      
      index = index - 0.5f * currentLength;
      finalText = [text substringToIndex:index];
    }
    
    if (fabs(lastIndex - index) < 2) {
      
      break;
    }
    
    lastIndex = index;
    
  } while (width != targetWidth);
  
  if (finalText.length < text.length) {
    finalText = [finalText stringByAppendingString:@"..."];
  }
  
  return [finalText stringByAppendingString:@"\n "];
}

+ (NSMutableString *)calculateFinalStrWithStr:(NSString *)contentStr tatgetWidth:(CGFloat )width targetHeight:(CGFloat)height font:(UIFont *)font{
  if (!contentStr) {
    contentStr = @"";
  }
  if (!width&&width < 0) {
    width = 0;
  }
  if (!height&&height < 0) {
    height = 0;
  }
  if (!font) {
    font = [UIFont systemFontOfSize:14.0f];
  }
  NSMutableString *finalStr = [NSMutableString string];
  [finalStr appendString:contentStr];
  CGFloat actualWidth = 0;
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
  paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
  NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
  
  
  CGFloat strWidth = [contentStr boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
  if (strWidth < width) {
    [finalStr appendString:@"\n "];
  }else if (strWidth <= 1.5*width) {
    [finalStr appendString:@"\n "];
    return finalStr;
  }else{
    actualWidth = strWidth*2;
    while (actualWidth > 1.5 * width) {
      [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length - 1, 1)];
      actualWidth = [finalStr boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    }
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length - 1, 1)];
    [finalStr appendString:@"..."];
    return finalStr;
  }
  
  return finalStr;
}

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}




@end
