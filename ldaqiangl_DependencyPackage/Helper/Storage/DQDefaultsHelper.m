//
//  DQDefaultsHelper.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQDefaultsHelper.h"

@interface DQDefaultsHelper ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end
@implementation DQDefaultsHelper

#pragma mark - -> LazyLoading
- (NSUserDefaults *)userDefaults
{
    if (nil == _userDefaults)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

#pragma mark - -> Initialization
+ (instancetype)sharedDefaultsHelper
{
    static DQDefaultsHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{ _instance = [[DQDefaultsHelper alloc] init]; });
    
    return _instance;
}

#pragma mark - -> Public
/** 保存用户偏好设置 */
- (void)setValue:(id)value forKey:(NSString *)defaultName
{
    [self.userDefaults setObject:value forKey:defaultName];
    [self.userDefaults synchronize];
}

/** 将 NSInteger 转换成 NSNumber，保存到用户偏好设置 */
- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [self.userDefaults setInteger:value forKey:defaultName];
    [self.userDefaults synchronize];
}

/** 将 float 转换成 NSNumber，保存到用户偏好设置 */
- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    [self.userDefaults setFloat:value forKey:defaultName];
    [self.userDefaults synchronize];
}

/** 将 double 转换成 NSNumber，保存到用户偏好设置 */
- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    [self.userDefaults setDouble:value forKey:defaultName];
    [self.userDefaults synchronize];
}

/** 将 BOOL 转换成 NSString，保存到用户偏好设置 */
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [self setValue:value ? @"1" : @"0"
            forKey:defaultName];
}

/** 将 NSUR 归档成 NSData，保存到用户偏好设置 */
- (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName
{
    [self.userDefaults setURL:url forKey:defaultName];
    [self.userDefaults synchronize];
}

/** 获取用户偏好设置 */
- (id)valueForKey:(NSString *)defaultName
{
    id  object = [self.userDefaults objectForKey:defaultName];
    
    return object;
}

/** 将用户偏好号 defaultName 对应的值转为 NSInteger 类型 */
- (NSInteger)integerForKey:(NSString *)defaultName
{
    return [self.userDefaults integerForKey:defaultName];
}

/** 将用户偏好号 defaultName 对应的值转为 float 类型 */
- (float)floatForKey:(NSString *)defaultName
{
    return [self.userDefaults floatForKey:defaultName];
}

/** 将用户偏好号 defaultName 对应的值转为 double 类型 */
- (double)doubleForKey:(NSString *)defaultName
{
    return [self.userDefaults doubleForKey:defaultName];
}

/** 将用户偏好号 defaultName 对应的值转为 BOOL 类型 */
- (BOOL)boolForKey:(NSString *)defaultName
{
    return [self.userDefaults boolForKey:defaultName];
}

/**  获取 setURL:forKey 保存的 URL */
- (NSURL *)URLForKey:(NSString *)defaultName
{
    return [self.userDefaults URLForKey:defaultName];
}

/** 移除用户设置中 defaultName 项 */
- (void)removeValueForKey:(NSString *)defaultName
{
    [self.userDefaults removeObjectForKey:defaultName];
}

/** 移除用户设置中 defaultName 项 */
- (void)removeValuesForKeys:(NSArray *)defaultNames
{
    __weak typeof(self) weakSelf = self;
    [defaultNames enumerateObjectsUsingBlock:^(NSString *key,
                                               NSUInteger idx,
                                               BOOL * _Nonnull stop)
     {
         [weakSelf removeValueForKey:key];
     }];
}

/** 设置UserDefautls的默认值 */
- (void)registerDefaults:(NSDictionary<NSString *,id> *)registrationDictionary
{
    NSAssert(registrationDictionary && [registrationDictionary isKindOfClass:[NSDictionary class]], @"registrationDictionary 不能为nil或非字典类型");
    [self.userDefaults registerDefaults:registrationDictionary];
}

@end




























