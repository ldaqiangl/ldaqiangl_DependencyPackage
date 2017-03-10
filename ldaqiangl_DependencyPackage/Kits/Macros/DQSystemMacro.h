//
//  DQSystemMacro.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#ifndef DQSystemMacro_h
#define DQSystemMacro_h


#pragma mark 获取版本
#define DQiOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define DQCurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#pragma mark 获取当前语言
#define DQCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark 屏幕宽高
#define DQSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DQSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define DQSCREEN_MAX_LENGTH (MAX(DQSCREEN_WIDTH, DQSCREEN_HEIGHT))
#define DQSCREEN_MIN_LENGTH (MIN(DQSCREEN_WIDTH, DQSCREEN_HEIGHT))

#pragma mark 判断设备类型
#define DQIS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DQIS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DQIS_TV (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV;
#define DQIS_CARPLAY (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomCarPlay;

#pragma mark 判断手机型号 Retina屏 4、5、6、6P
#define DQIS_RETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define DQIS_IPHONE_4_OR_LESS (DQIS_PHONE && DQSCREEN_MAX_LENGTH < 568.0)
#define DQIS_IPHONE_5 (DQIS_PHONE && DQSCREEN_MAX_LENGTH == 568.0)
#define DQIS_IPHONE_6 (DQIS_PHONE && DQSCREEN_MAX_LENGTH == 667.0)
#define DQIS_IPHONE_6P (DQIS_PHONE && DQSCREEN_MAX_LENGTH == 736.0)

#pragma mark 判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

#pragma mark 检查系统版本
/** == */
#define DQSYSTEM_VERSION_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

/** > */
#define DQSYSTEM_VERSION_GREATER_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/** >= */
#define DQSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/** < */
#define DQSYSTEM_VERSION_LESS_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/** <= */
#define DQSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#endif /* DQSystemMacro_h */




















