//
//  NSDate+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//毫秒值：millisecond value

#define SECONDS_IN_MINUTE_DQExt 60
#define MINUTES_IN_HOUR_DQExt 60
#define DAYS_IN_WEEK_DQExt 7
#define SECONDS_IN_HOUR_DQExt (SECONDS_IN_MINUTE_DQExt * MINUTES_IN_HOUR_DQExt)
#define HOURS_IN_DAY_DQExt 24
#define SECONDS_IN_DAY_DQExt (HOURS_IN_DAY_DQExt * SECONDS_IN_HOUR_DQExt)

@interface NSDate (DQExt)

#pragma mark -----------------------------------------

#pragma mark - -> 一、判断

/**
 *  是否为今天
 */
- (BOOL)isToday_DQExt;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday_DQExt;
/**
 *  是否为今年
 */
- (BOOL)isThisYear_DQExt;


#pragma mark -----------------------------------------

#pragma mark - -> 二、转化

#pragma mark - --> 1、NSDate、时间表达字符串转化成毫秒值（NSString类型、13位）

/**
 获取当前时间戳
 */
+ (NSString *)getNowTimestamp_DQExt;

/**
 得到目标日期（字符串表示）对应的毫秒值
 
 @param targetDate 要转化的日期字符串，如：|2017-03-3|
 @param formateStyle 目标日期的格式，如上述的日期格式为：|YYYY-MM-d|
 @return targetDate所表表示的毫秒值
 */
+ (NSString *)getMillisecondValue_DQExt:(NSString *)targetDate
                        andFormateStyle:(NSString *)formateStyle;

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
                           formateStyle:(NSString *)formateStyle;

#pragma mark - --> 1、NSDate中提取时间表达字符串

#pragma mark - --> 2、毫秒值（NSString类型、13位）中提取时间表达字符串

/**
 从时间戳中 得到 星期？

 @param millisecond 毫秒值
 @return 星期表达，如|星期一|
 */
+ (NSString *)getWeekDayFromMillisecond_DQExt:(NSString *)millisecond;


#pragma mark -----------------------------------------

#pragma mark - -> 四、计算

- (NSDate *)dateByAddingYears_DQExt:(NSInteger) dYears;

- (NSDate *)dateBySubtractingYears_DQExt:(NSInteger) dYears;

- (NSDate *)dateByAddingMonths_DQExt:(NSInteger) dMonths;

- (NSDate *)dateBySubtractingMonths_DQExt:(NSInteger) dMonths;

- (NSDate *)dateByAddingDays_DQExt:(NSInteger) dDays;

- (NSDate *)dateBySubtractingDays_DQExt:(NSInteger) dDays;

- (NSDate *)dateByAddingHours_DQExt:(NSInteger) dHours;

- (NSDate *)dateBySubtractingHours_DQExt:(NSInteger) dHours;

- (NSDate *)dateByAddingMinutes_DQExt:(NSInteger) dMinutes;

- (NSDate *)dateBySubtractingMinutes_DQExt:(NSInteger) dMinutes;

- (NSDate *)dateAtStartOfDay_DQExt;

- (NSDate *)dateAtEndOfDay_DQExt;

- (NSDate *)dateAtStartOfWeek_DQExt;

- (NSDate *)dateAtEndOfWeek_DQExt;

- (NSDate *)dateAtStartOfMonth_DQExt;

- (NSDate *)dateAtEndOfMonth_DQExt;

- (NSDate *)dateAtStartOfYear_DQExt;

- (NSDate *)dateAtEndOfYear_DQExt;

    
@end




























































