//
//  DQAppManager.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DQAppChannelPlatformConfig;
#define DQApp [DQAppManager sharedAppManager]

/** 检查版本完成回调 */
typedef void(^DQCheckVersionCompletionBlock)(BOOL needUpdate, NSDictionary *appInfo, NSError *error);

/**
 @author daqiang
 
 @brief App 管理
 */
@interface DQAppManager : NSObject

/**
 @author daqiang
 
 @brief 唯一实例
 
 @return DQAppManager
 */
+ (instancetype)sharedAppManager;

/**
 @author daqiang
 
 @brief 用于统一配置
 
 @param platformConfig 平台配置
 @remark 统一配置后，其它方法不用再传相应的配置。
 @code
 [DQApp checkVersionFromPlatform:nil
 completion:^(BOOL needUpdate, NSDictionary *appInfo){}]
 */
- (void)config:(DQAppChannelPlatformConfig *)platformConfig;

/**
 @author daqiang
 
 @brief 从指定平台检查版本
 
 @param platformConfig 平台配置
 @param completion 完成回调
 */
- (void)checkVersionFromPlatform:(DQAppChannelPlatformConfig *)platformConfig
                      completion:(DQCheckVersionCompletionBlock)completion;

/**
 @author daqiang
 
 @brief 跳转到应用下载页面
 
 @param fromViewController 从指定的控制器跳转
 @remark 应用外跳转，依赖于 checkVersionFromPlatform:completion: 方法
 @code
 __weak typeof (self) weakSelf = self;
 [DQApp checkVersionFromPlatform:config
 completion:^(BOOL isLastest, NSDictionary *appInfo)
 {
 if (isLastest) [DQApp jumpToDownloadPageFromViewController:weakSelf];
 }];
 */
- (void)jumpToDownloadPageFromViewController:(UIViewController *)fromViewController;

/**
 @author daqiang
 
 @brief 跳转到 AppStore 的指定 App 页面
 
 @param platformConfig 平台配置
 @param fromViewController 从指定的控制器跳转
 @remark 应用内跳转
 */
- (void)jumpToAppStorePage:(DQAppChannelPlatformConfig *)platformConfig
        fromViewController:(UIViewController *)fromViewController;

/**
 @author daqiang
 
 @brief 跳转到 AppStore 的指定 App 评论页面
 
 @param platformConfig 平台配置
 @param fromViewController 从指定的控制器跳转
 @remark 应用外跳转
 */
- (void)jumpToAppStoreReviewPage:(DQAppChannelPlatformConfig *)platformConfig
              fromViewController:(UIViewController *)fromViewController;


@end














