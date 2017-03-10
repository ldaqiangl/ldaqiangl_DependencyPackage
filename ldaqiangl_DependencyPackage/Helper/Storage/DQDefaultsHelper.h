//
//  DQDefaultsHelper.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DQDefaults [DQDefaultsHelper sharedDefaultsHelper]

#define DQDefaultsSetValueForKey(value, defaultsName) \
[DQDefaults setValue:value forKey:defaultsName]

#define DQDefaultsValueForKey(defaultsName) \
[DQDefaults valueForKey:defaultsName]

#define DQDefaultsRemoveValueKey(defaultsName) \
[DQDefaults removeValueForKey:defaultsName];

@interface DQDefaultsHelper : NSObject

/**
 实例
 
 @return DQDefaultsHelper
 */
+ (instancetype)sharedDefaultsHelper;

/**
 @author daqiang
 
 @brief 保存用户偏好设置
 
 @param value       NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary
 @param defaultName identifie
 */
- (void)setValue:(id)value forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将 NSInteger 转换成 NSNumber，保存到用户偏好设置
 
 @param value       BOOL
 @param defaultName identifie
 */
- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将 float 转换成 NSNumber，保存到用户偏好设置
 
 @param value       BOOL
 @param defaultName identifie
 */
- (void)setFloat:(float)value forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将 double 转换成 NSNumber，保存到用户偏好设置
 
 @param value       BOOL
 @param defaultName identifie
 */
- (void)setDouble:(double)value forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将 BOOL 转换成 NSString，保存到用户偏好设置
 
 @param value       BOOL
 @param defaultName identifie
 @remark            @"1" : YES; @"0" : NO.
 */
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将 NSUR 归档成 NSData，保存到用户偏好设置
 
 @param url         NSURL
 @param defaultName identifie
 */
- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 获取用户偏好设置中 defaultName 对应的值
 
 @param defaultName identifie
 
 @return NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary
 */
- (id)valueForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将用户偏好号 defaultName 对应的值转为 NSInteger 类型
 
 @param defaultName identifie
 
 @return NSInteger
 */
- (NSInteger)integerForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将用户偏好号 defaultName 对应的值转为 float 类型
 
 @param defaultName identifie
 
 @return float
 */
- (float)floatForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将用户偏好号 defaultName 对应的值转为 double 类型
 
 @param defaultName identifie
 
 @return double
 */
- (double)doubleForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 将用户偏好号 defaultName 对应的值转为 BOOL 类型
 
 @param defaultName identifie
 
 @return BOOL
 */
- (BOOL)boolForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 获取 setURL:forKey 保存的 URL
 
 @param defaultName identifie
 
 @return NSURL
 */
- (NSURL *)URLForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 移除用户设置中 defaultName 项
 
 @param defaultName identifie
 */
- (void)removeValueForKey:(NSString *)defaultName;

/**
 @author daqiang
 
 @brief 批量移除用户设置中 defaultName 项
 
 @param defaultNames defaultName 数组
 */
- (void)removeValuesForKeys:(NSArray *)defaultNames;

/**
 @author daqiang
 
 @brief 设置 UserDefautls 的默认值
 @remark 默认的数据是不会被保存到 plist 文件中的，我们需要手动变更这些数据然后保存。
 
 @param registrationDictionary 默认值为字典类型
 */
- (void)registerDefaults:(NSDictionary<NSString *, id> *)registrationDictionary;


@end




















