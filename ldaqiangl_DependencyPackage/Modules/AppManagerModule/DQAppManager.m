//
//  DQAppManager.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQAppManager.h"
#import <StoreKit/StoreKit.h>

#import "DQAppFirResult.h"

#import "DQAppManagerConst.h"           // 常量
#import "DQAppChannelPlatformConfig.h"  // 平台配置
#import "DQAppFirResult.h"              // FIR
#import "DQAppStoreResult.h"            // AppStore

#import "DQNetWorkHelper.h"             // 网络操作

@interface DQAppManager()
<SKStoreProductViewControllerDelegate>

/** 平台配置 */
@property (nonatomic, strong) DQAppChannelPlatformConfig *platformConfig;
/** App 下载地址 */
@property (nonatomic, copy) NSString *appDownloadPageURL;
/** App 最新版本 */
@property (nonatomic, copy) NSString *appLastestVersion;

@end

@implementation DQAppManager


#pragma mark - -> LazyLoading
- (DQAppChannelPlatformConfig *)platformConfig
{
    if (nil == _platformConfig)
    {
        _platformConfig = [[DQAppChannelPlatformConfig alloc] init];
    }
    
    return _platformConfig;
}

#pragma mark - -> Public
/** 唯一实例 */
+ (instancetype)sharedAppManager
{
    static DQAppManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{ _instance = [[DQAppManager alloc] init]; });
    
    return _instance;
}

/** 用于统一配置 */
- (void)config:(DQAppChannelPlatformConfig *)platformConfig
{
    self.platformConfig = platformConfig;
}

/** 版本更新 */
- (void)checkVersionFromPlatform:(DQAppChannelPlatformConfig *)platformConfig
                      completion:(DQCheckVersionCompletionBlock)completion
{
    platformConfig = platformConfig ? platformConfig : self.platformConfig;
    self.platformConfig = platformConfig;
    DQAppChannelPlatform platform = platformConfig.platform;
    switch (platform)
    {
        case DQAppFirPlatformChannel:
            [self checkVersionFromFir:platformConfig
                           completion:completion];
            break;
        case DQAppAppStorePlatformChannel:
            [self checkVersionFromAppStore:platformConfig
                                completion:completion];
            break;
        default:
            break;
    }
}

/** 应用外跳转到升级页面 */
- (void)jumpToDownloadPageFromViewController:(UIViewController *)viewController
{
    DQAppChannelPlatform platform = self.platformConfig.platform;
    NSString *prefix = platform == DQAppAppStorePlatformChannel ? @"Version " : @"Build ";
    NSString *title = [NSString stringWithFormat:@"有新版本(%@%@)",
                       prefix, self.appLastestVersion];
    UIAlertController *alertCtr = [UIAlertController
                                   alertControllerWithTitle:title
                                   message:@"新的版本中有重大更新,请及时升级至最新版本!"
                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action)
                             {}];
    if (platform != DQAppAppStorePlatformChannel) [alertCtr addAction:cancel];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"前往更新"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action)
                           {
                               [weakSelf openURL:weakSelf.appDownloadPageURL];
                           }];
    [alertCtr addAction:sure];
    
    viewController = [self presentingViewController:viewController];
    [viewController presentViewController:alertCtr animated:YES completion:^{}];
}

/** 应用内跳转到 AppStore 的指定 App 页面 */
- (void)jumpToAppStorePage:(DQAppChannelPlatformConfig *)platformConfig
        fromViewController:(UIViewController *)fromViewController
{
    platformConfig = platformConfig ? platformConfig : self.platformConfig;
    SKStoreProductViewController *storeProCtr = [[SKStoreProductViewController alloc] init];
    storeProCtr.delegate = self;
    NSDictionary *parasDict = [NSDictionary
                               dictionaryWithObjects:@[@(platformConfig.appID.integerValue)]
                               forKeys:@[SKStoreProductParameterITunesItemIdentifier]];
    __block UIViewController *presentingCtr = fromViewController;
    __block typeof(self) weakSelf = self;
    [storeProCtr loadProductWithParameters:parasDict
                           completionBlock:^(BOOL result, NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"加载 AppStore 页面失败:%@", error.localizedDescription);
             return ;
         }
         
         // 模态弹出 Appstore
         presentingCtr = [weakSelf presentingViewController:presentingCtr];
         [presentingCtr presentViewController:storeProCtr
                                     animated:YES
                                   completion:^{}];
     }];
}

/** 应用外跳转到 AppStore 的指定 App 评论页面 */
- (void)jumpToAppStoreReviewPage:(DQAppChannelPlatformConfig *)platformConfig
              fromViewController:(UIViewController *)fromViewController
{
    platformConfig = platformConfig ? platformConfig : self.platformConfig;
    NSString *reviewAddress = [NSString stringWithFormat:@"%@&id=%@", KEY_URL_APPSTORE_REVIEW, platformConfig.appID];
    [self openURL:reviewAddress];
}

#pragma mark - -> Delegate
#pragma mark <SKStoreProductViewControllerDelegate>
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - -> Private
/**
 @author daqiang
 
 @brief 打开指定的 URL
 
 @param urlString NSString
 */
- (void)openURL:(NSString *)urlString
{
    NSURL *URL = [NSURL URLWithString:urlString];
    UIApplication *application = [UIApplication sharedApplication];
    if (![application canOpenURL:URL]) return;
    if ([[[UIDevice currentDevice] systemVersion]
         compare:@"10" options:NSNumericSearch] == NSOrderedDescending)
        [application openURL:URL
                     options:@{}
           completionHandler:^(BOOL success)
         {
             NSLog(@"打开地址%@:%@", success ? @"成功" : @"失败", urlString);
         }];
    else [application openURL:URL];
}

/**
 获取当前正在展示的控制器
 
 @param viewController 当前控制器
 @return UIViewController
 */
- (UIViewController *)presentingViewController:(UIViewController *)viewController
{
    if (nil == viewController ||
        nil == viewController.view.window ||
        !viewController.isViewLoaded)
    {
        UIApplication *application = [UIApplication sharedApplication];
        viewController = application.keyWindow.rootViewController;
    }
    
    return viewController;
}

/**
 @author daqiang
 
 @brief 通过当前与最新 Version 号比较，判断是否是最新版本
 
 @return YES:是最新版本;NO:不是最新版本
 */
- (BOOL)isLastestVersion:(NSString *)lastestVersion
{
    NSString *buildVersionKey = @"CFBundleShortVersionString";
    NSString *curVersion = [[NSBundle mainBundle].infoDictionary
                            objectForKey:buildVersionKey];
    
    NSComparisonResult result = [curVersion compare:lastestVersion
                                            options:NSNumericSearch];
    
    return result == NSOrderedAscending ? YES : NO;
}

/**
 @author daqiang
 
 @brief 通过当前与最新 Build 号比较，判断是否是最新版本
 
 @return YES:是最新版本;NO:不是最新版本
 */
- (BOOL)isLastestBuild:(NSString *)lastestBuild
{
    NSString *buildVersionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *curBuild = [[NSBundle mainBundle].infoDictionary
                          objectForKey:buildVersionKey];
    
    NSComparisonResult result = [curBuild compare:lastestBuild
                                          options:NSNumericSearch];
    
    return result == NSOrderedAscending ? YES : NO;
}

/**
 @author daqiang
 
 @brief 从 AppStore 检查版本
 
 @param platformConfig 配置
 @param completion 完成回调
 */
- (void)checkVersionFromAppStore:(DQAppChannelPlatformConfig *)platformConfig
                      completion:(DQCheckVersionCompletionBlock)completion
{
    NSDictionary *para = [NSDictionary dictionaryWithObject:platformConfig.appID
                                                     forKey:@"id"];
    __weak typeof(self) weakSelf = self;
    DQNetWork.timeoutInterval = 5.0;
    [DQNetWork requestWithHttpMethod:eHttpMethodTypeGET
                                 url:KEY_URL_APPSTORE_LOOKUP
                              params:para
                             success:^(id responseObject)
     {
         NSDictionary *rspDict = [NSJSONSerialization
                                  JSONObjectWithData:responseObject
                                  options:NSJSONReadingAllowFragments
                                  error:NULL];
         NSString *resultCount = [rspDict objectForKey:@"resultCount"];
         if (resultCount.integerValue <= 0)
         {
             if (completion) completion(NO, nil, nil);
             return ;
         }
         
         NSArray *results = [rspDict objectForKey:@"results"];
         NSDictionary *appInfo = [results firstObject];
         weakSelf.appDownloadPageURL = [appInfo objectForKey:@"trackViewUrl"];
         weakSelf.appLastestVersion = [appInfo objectForKey:@"version"];
         BOOL isLastest = [weakSelf isLastestVersion:weakSelf.appLastestVersion];
         if (completion) completion(isLastest, appInfo, nil);
     }
                             failure:^(NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"AppStore版本检查失败:\n%@", error.localizedDescription);
     }];
}

/**
 @author daqiang
 
 @brief 从 FIR 检查版本
 
 @param platformConfig 配置
 @param completion 完成回调
 */
- (void)checkVersionFromFir:(DQAppChannelPlatformConfig *)platformConfig
                 completion:(DQCheckVersionCompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",
                     KEY_URL_FIR_CHECKVERSION, platformConfig.appID];
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                           platformConfig.apiToken, @"apiToken",
                           @"ios", @"type", nil];
    
    __weak typeof(self) weakSelf = self;
    DQNetWork.timeoutInterval = 5.0;
    [DQNetWork requestWithHttpMethod:eHttpMethodTypeGET
                                 url:url
                              params:paras
                             success:^(id responseObject)
     {
         NSDictionary *rspDict = [NSJSONSerialization
                                  JSONObjectWithData:responseObject
                                  options:NSJSONReadingAllowFragments
                                  error:NULL];
         weakSelf.appLastestVersion = [rspDict objectForKey:@"build"];
         BOOL isLastest = [weakSelf isLastestBuild:weakSelf.appLastestVersion];;
         if (!isLastest)
         {
             if (completion) completion(isLastest, rspDict, nil);
             return ;
         }
         [weakSelf downloadURLFromFir:platformConfig
                           completion:^(NSString *download_URL, NSError *error)
          {
              if (completion) completion(isLastest, rspDict, error);
          }];
     } failure:^(NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"FIR版本检查失败:\n%@", error.localizedDescription);
         if (completion) completion(NO, error.userInfo, error);
     }];
}

/**
 @author daqiang
 
 @brief 从 FIR 获取下载 Token
 
 @param platformConfig 配置
 @param completion 完成回调
 */
- (void)downloadURLFromFir:(DQAppChannelPlatformConfig *)platformConfig
                completion:(void (^)(NSString *download_URL, NSError *error))completion
{
    __weak typeof(self) weakSelf = self;
    [self downloadTokenFromFir:platformConfig
                    completion:^(NSString *download_token, NSError *error)
     {
         if (nil == download_token)
         {
             if (completion) completion(nil, error);
             return ;
         }
         [weakSelf downloadPlistIdFromFir:platformConfig
                            downloadToken:download_token
                               completion:^(NSString *plist_id, NSError *error)
          {
              if (nil == plist_id)
              {
                  if (completion) completion(nil, error);
                  return ;
              }
              NSString *downloadURL = [NSString stringWithFormat:KEY_URL_FIR_DOWNLOADURL,
                                       plist_id];
              weakSelf.appDownloadPageURL = downloadURL;
              if (completion) completion(downloadURL, error);
          }];
     }];
}

/**
 @author daqiang
 
 @brief 从 FIR 获取下载 Token
 
 @param platformConfig 配置
 @param completion 完成回调
 */
- (void)downloadTokenFromFir:(DQAppChannelPlatformConfig *)platformConfig
                  completion:(void (^)(NSString *download_token, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:KEY_URL_FIR_DOWNLOADTOKEN, platformConfig.appID];
    NSDictionary *para = [NSDictionary dictionaryWithObject:platformConfig.apiToken
                                                     forKey:@"api_token"];
    
    DQNetWork.timeoutInterval = 5.0;
    [DQNetWork requestWithHttpMethod:eHttpMethodTypeGET
                                 url:url
                              params:para
                             success:^(id responseObject)
     {
         NSDictionary *resultDict = [NSJSONSerialization
                                     JSONObjectWithData:responseObject
                                     options:NSJSONReadingMutableLeaves
                                     error:NULL];
         NSString *downloadToken = [resultDict objectForKey:@"download_token"];
         if (completion) completion(downloadToken, nil);
     }
                             failure:^(NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"FIR下载 Token 获取失败:\n%@", error.localizedDescription);
         if (completion) completion(nil, error);
     }];
}

/**
 @author daqiang
 
 @brief 从 FIR 获取下载 URL
 
 @param platformConfig 配置
 @param downloadToken Token
 @param completion 完成回调
 */
- (void)downloadPlistIdFromFir:(DQAppChannelPlatformConfig *)platformConfig
                 downloadToken:(NSString *)downloadToken
                    completion:(void (^)(NSString *plist_id, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:KEY_URL_FIR_DOWNLOADPLISTID,
                     platformConfig.appID];
    NSDictionary *para = [NSDictionary dictionaryWithObject:downloadToken
                                                     forKey:@"download_token"];
    
    DQNetWork.timeoutInterval = 5.0;
    [DQNetWork requestWithHttpMethod:eHttpMethodTypePOST
                                 url:url params:para
                             success:^(id responseObject)
     {
         NSDictionary *resultDict = [NSJSONSerialization
                                     JSONObjectWithData:responseObject
                                     options:NSJSONReadingMutableLeaves
                                     error:NULL];
         NSString *plistId = [resultDict objectForKey:@"url"];
         if (completion) completion(plistId, nil);
     } failure:^(NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"FIR下载 PlistId 获取失败:\n%@", error.localizedDescription);
         if (completion) completion(nil, error);
     }];
}



@end































