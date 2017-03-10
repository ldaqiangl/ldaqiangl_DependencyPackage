//
//  DQFunction.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 业务环境 */
typedef enum : NSUInteger {
    AppEnvTypeDev,                     // 开发
    AppEnvTypeTest,                    // 测试
    AppEnvTypeStage,                   // 准生产
    AppEnvTypePreview,                 // 演示
    AppEnvTypeProd,                    // 生产
    AppEnvTypeUnknow                   // 未知
} AppEnvType;

@interface DQFunction : NSObject

/**
 *  警告
 *
 *  @param title   标题
 *  @param message 内容
 */
void DQAlert(NSString *title ,NSString *message);

/**
 *  计算各型号设备对应的尺寸
 *
 *  @param value 标注尺寸
 *
 *  @return 实际尺寸
 */
CGFloat DQCalculateUISize(CGFloat value);

/**
 *  计算各型号设备对应的字体大小
 *
 *  @param value 标注字体大小
 *
 *  @return 实际字体大小
 */
UIFont * DQCalculateUIFontSize(CGFloat value);

/**
 *  强制关闭APP
 */
void DQExitApplication();

/**
 *  获取当前应用名称
 */
NSString * DQAppName();

/**
 *  获取当前应用 Bundle ID
 */
NSString * DQAppBundleIdentifier();

/**
 *  获取当前应用版本号
 */
NSString * DQAppLastestVersion();

/**
 *  获取当前应用bundle版本号
 */
NSString * DQAppLastestBundleVersion();

/**
 *  获取当前应用的业务环境
 */
NSUInteger DQAppBelongToEnV();

/**
 *  比较build号
 *
 *  @param currentBuild 当前build号
 *  @param lastestBuild 最新build号
 *
 *  @return 是否是最新版本(YES : 是最新版本 ; NO : 不是最新版本)
 */
bool DQCompareBuildVersion(NSString *currentBuild, NSString *lastestBuild);

/**
 *  比较版本号
 *
 *  @param currentVersion 当前version
 *  @param lastestVersion 最新version
 *
 *  @return 是否是最新版本(YES : 是最新版本 ; NO : 不是最新版本)
 */
bool DQCompareVersion(NSString *currentVersion, NSString *lastestVersion);

/**
 ＊  过滤字符串比如来自QQ的\u0014这种不支持的字符
 **/
NSString * DQFilterString(NSString *string);


@end
