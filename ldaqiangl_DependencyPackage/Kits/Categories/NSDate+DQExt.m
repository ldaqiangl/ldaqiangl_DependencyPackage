//
//  NSDate+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "NSDate+DQExt.h"

@implementation NSDate (DQExt)
    
#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar {
    
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [dictionary objectForKey:@"AZ_currentCalendar"];
    if (currentCalendar == nil) {
        
        currentCalendar = [NSCalendar currentCalendar];
        [dictionary setObject:currentCalendar forKey:@"AZ_currentCalendar"];
    }
    return currentCalendar;
}

#pragma mark -----------------------------------------

#pragma mark - -> 一、判断
//是否为今天
- (BOOL)isToday_DQExt {
    
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    // 1.获得当前时间的年、月、日
    NSDateComponents *nowComponents = [canlendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年、月、日
    NSDateComponents *selfComponents = [canlendar components:unit fromDate:self];
    
    return (selfComponents.year == nowComponents.year)
    && (selfComponents.month == nowComponents.month)
    && (selfComponents.day == nowComponents.day);
}

//是否为昨天
- (BOOL)isYesterday_DQExt {
    
    // 获取当前日期的年月日
    NSDate *nowDate = [[NSDate date] dateWithYMD_DQExt];
    
    // 获取self的年月日
    NSDate *selfDate = [self dateWithYMD_DQExt];
    
    // 计算nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return dateComponents.day == 1;
}

//是否为今年
- (BOOL)isThisYear_DQExt {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前日期的年
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self时间的年
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    
    return nowComponents.year == selfComponents.year;
}

#pragma mark -----------------------------------------
    
#pragma mark - -> 二、转化
    
#pragma mark - --> 1、NSDate、时间表达字符串转化成毫秒值（NSString类型、13位）
    
/**
 获取当前时间戳
 */
+ (NSString *)getNowTimestamp_DQExt {
    
    // 获取当前时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hant"];
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss.SSS Z";
    NSString *date = [fmt stringFromDate:[NSDate date]];
    
    // 将当前时间转时间戳
    NSString *timeStamp =
    [NSString stringWithFormat:@"%f",[[fmt dateFromString:date] timeIntervalSince1970] *1000];
    
    // 截取字符串
    NSRange range = [timeStamp rangeOfString:@"."];
    return [timeStamp substringToIndex:range.location];
}

/**
 得到目标日期（字符串表示）对应的毫秒值
 
 @param targetDate 要转化的日期字符串，如：|2017-03-3|
 @param formateStyle 目标日期的格式，如上述的日期格式为：|YYYY-MM-d|
 @return targetDate所表表示的毫秒值
 */
+ (NSString *)getMillisecondValue_DQExt:(NSString *)targetDate
                        andFormateStyle:(NSString *)formateStyle {
    
    NSString *targetTimeStamp = nil;
    
    // 1.将服务器返回的时间格式化为NSDate
    NSDateFormatter *DateF = [[NSDateFormatter alloc] init];
    DateF.locale = [NSLocale currentLocale];
    DateF.dateFormat = formateStyle;
    NSDate *createdTime = [DateF dateFromString:targetDate];
    
    targetTimeStamp =
    [NSString stringWithFormat:@"%lld",(long long)[createdTime timeIntervalSince1970] *1000];
    
    return targetTimeStamp;
}
    
#pragma mark - --> 2、毫秒值（NSString类型、13位）转化成NSDate、时间表达字符串
    
#pragma mark - --> 3、时间表达字符串转化为NSDate
    
#pragma mark - --> 4、友好表达日期


#pragma mark -----------------------------------------

#pragma mark - -> 三、提取

#pragma mark - --> 0、通用方法
    
/**
 得到13位毫秒值中 相应格式的时间表达字符串
 
 @param millisecond 13位毫秒值
 @param formateStyle 格式字符串，如：|YYYY-M-d|
 @return 返回传入格式字符传格式的日期表达，如：|2017-3-4|
 */
+ (NSString *)getMillisecondValue_DQExt:(NSString *)millisecond
                           formateStyle:(NSString *)formateStyle {
    
    NSString *displayTime = @"";
    
    NSString *dateStr = millisecond;
    
    long long int exchangedTime = dateStr.doubleValue/1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:exchangedTime];
    
    // 1.将服务器返回的时间格式化为NSDate
    NSDateFormatter *DateF = [[NSDateFormatter alloc] init];
    DateF.locale = [NSLocale currentLocale];
    DateF.dateFormat = @"YYYY-MM-dd HH:mm:ss Z";
    NSDate *createdTime = [DateF dateFromString:[DateF stringFromDate:confromTimesp]];
    
    DateF.dateFormat = formateStyle;
    displayTime = [DateF stringFromDate:createdTime];
    
    return displayTime;
}
    
#pragma mark - --> 1、NSDate中提取时间表达字符串、日期

//返回一个只有年月日的日期
- (NSDate *)dateWithYMD_DQExt {
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [dateFmt stringFromDate:self];
    return [dateFmt dateFromString:selfStr];
}

#pragma mark - --> 2、毫秒值（NSString类型、13位）中提取时间表达字符串

/**
 从时间戳中 得到 星期？
 
 @param millisecond 毫秒值
 @return 星期表达，如|星期一|
 */
+ (NSString *)getWeekDayFromMillisecond_DQExt:(NSString *)millisecond {
    
    NSString *dateStr = millisecond;
    
    long long int exchangedTime = dateStr.doubleValue/1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:exchangedTime];
    
    // 1.将服务器返回的时间格式化为NSDate
    NSDateFormatter *DateF = [[NSDateFormatter alloc] init];
    DateF.locale = [NSLocale currentLocale];
    DateF.dateFormat = @"YYYY-MM-dd HH:mm:ss Z";
    NSDate *createdTime = [DateF dateFromString:[DateF stringFromDate:confromTimesp]];
    
    NSArray *weekday =
    [NSArray arrayWithObjects:[NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:createdTime];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    
    return [NSString stringWithFormat:@"星期%@",weekStr];
}


#pragma mark -----------------------------------------

#pragma mark - -> 四、计算

- (NSDate *)dateByAddingYears_DQExt:(NSInteger) dYears {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = dYears;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingYears_DQExt:(NSInteger) dYears {
    return [self dateByAddingYears_DQExt:-dYears];
}

- (NSDate *)dateByAddingMonths_DQExt:(NSInteger) dMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = dMonths;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMonths_DQExt:(NSInteger) dMonths {
    return [self dateByAddingMonths_DQExt:-dMonths];
}

- (NSDate *)dateByAddingDays_DQExt:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingDays_DQExt:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
    
}

- (NSDate *)dateByAddingHours_DQExt:(NSInteger) dHours {
    
    return [self dateByAddingTimeInterval:(SECONDS_IN_HOUR_DQExt * dHours)];
}

- (NSDate *)dateBySubtractingHours_DQExt:(NSInteger) dHours {
    
    return [self dateByAddingTimeInterval:-(SECONDS_IN_HOUR_DQExt * dHours)];
}

- (NSDate *)dateByAddingMinutes_DQExt:(NSInteger) dMinutes {
    return [self dateByAddingTimeInterval:(SECONDS_IN_MINUTE_DQExt * dMinutes)];
}

- (NSDate *)dateBySubtractingMinutes_DQExt:(NSInteger) dMinutes {
    
    return [self dateByAddingTimeInterval:-(SECONDS_IN_MINUTE_DQExt * dMinutes)];
}

- (NSDate *)dateAtStartOfDay_DQExt {
    
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay_DQExt {
    
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfWeek_DQExt {
    
    NSDate *startOfWeek = nil;
    [[NSDate AZ_currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&startOfWeek interval:NULL forDate:self];
    return startOfWeek;
}

- (NSDate *)dateAtEndOfWeek_DQExt
{
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:self];
    components.weekday = range.length;
    return [calendar dateFromComponents:components];
}
- (NSDate *)dateAtStartOfMonth_DQExt {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.location;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfMonth_DQExt {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.length;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfYear_DQExt {
    
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.location;
    components.month = monthRange.location;
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return startOfYear;
}

- (NSDate *)dateAtEndOfYear_DQExt {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.length;
    components.month = monthRange.length;
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return endOfYear;
}


@end
































