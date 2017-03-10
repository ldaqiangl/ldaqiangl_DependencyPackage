//
//  DQFunction.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "DQFunction.h"

#import "DQSystemMacro.h"

@implementation DQFunction

#pragma mark - -> Public
/** 警告 */
void DQAlert(NSString *title ,NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - -> 计算各型号设备对应的尺寸
CGFloat DQCalculateUISize(CGFloat value)
{
    if (DQIS_IPHONE_6P) {
        value /= 2.0;
    } else if (DQIS_IPHONE_6) {
        value /= 2.5;
    } else {
        value /= 3.0;
    }
    
    return value;
}

#pragma mark - -> 计算各型号设备相对应的字体大小
UIFont * DQCalculateUIFontSize(CGFloat value)
{
    if (DQIS_IPHONE_6P) {
        value /= 2.0;
    } else if (DQIS_IPHONE_6) {
        value /= 2.5;
    } else {
        value /= 3.0;
    }
    
    return [UIFont systemFontOfSize:value];
}

#pragma mark - -> 强制关闭APP
void DQExitApplication()
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        //        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma mark - -> 获取当前应用名称
NSString * DQAppName()
{
    NSString *displayNameKey = @"CFBundleDisplayName";
    NSString *currentDisplayName = [[NSBundle mainBundle].infoDictionary objectForKey:displayNameKey];
    
    return currentDisplayName;
}

#pragma mark - -> 获取当前应用 Bundle ID
NSString * DQAppBundleIdentifier()
{
    NSString *bundleIdKey = (__bridge NSString *)kCFBundleIdentifierKey;
    NSString *currentBundelIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:bundleIdKey];
    
    return currentBundelIdentifier;
}

#pragma mark - -> 获取当前应用版本号
NSString * DQAppLastestVersion()
{
    NSString *versionKey = @"CFBundleShortVersionString";
    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
    
    return currentVersion;
}

#pragma mark - -> 获取当前应用版本号
NSString * DQAppLastestBundleVersion()
{
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
    
    return currentVersion;
}

#pragma mark - -> 获取当前应用的业务环境
NSUInteger DQAppBelongToEnV()
{
    NSString *bunldIDKey = (__bridge NSString *)kCFBundleIdentifierKey; //@"CFBundleIdentifier";
    NSString *currentBunldID = [[NSBundle mainBundle].infoDictionary
                                objectForKey:bunldIDKey];
    NSString *lastComponet = [[[currentBunldID componentsSeparatedByString:@"."]
                               lastObject] uppercaseString];
    if ([lastComponet isEqualToString:@"develop"]) {
        return AppEnvTypeDev;
    } else if ([lastComponet isEqualToString:@"test"]) {
        return AppEnvTypeTest;
    } else if ([lastComponet isEqualToString:@"release"]) {
        return AppEnvTypeStage;
    } else if ([lastComponet isEqualToString:@"preview"]) {
        return AppEnvTypePreview;
    } else if ([lastComponet isEqualToString:@""]) {
        return AppEnvTypeProd;
    }
    
    return AppEnvTypeUnknow;
}

#pragma mark - -> 比较build号
bool DQCompareBuildVersion(NSString *currentBuild, NSString *lastestBuild)
{
    NSComparisonResult comparisonResult = [currentBuild compare:lastestBuild options:NSNumericSearch];
    if (comparisonResult == NSOrderedAscending) return NO;
    
    return YES;
}

#pragma mark - -> 比较版本号
bool DQCompareVersion(NSString *currentVersion, NSString *lastestVersion)
{
    // 取出版本号中“.”号隔开的字符串
    NSArray *curVArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *lstVArr = [lastestVersion componentsSeparatedByString:@"."];
    
    // 比较版本号的位数:新版本号大于本地版本号,不是最新版本;新版本号小于本地版本号,是最新版本。
    if (lstVArr.count > curVArr.count) return NO;
    if (lstVArr.count < curVArr.count) return YES;
    
    // 按位比较,默认是最新版本
    __block BOOL isLastest = YES;
    [curVArr enumerateObjectsUsingBlock:^(NSString *curComponent, NSUInteger idx, BOOL * stop)
     {
         NSString *lstComponent = [lstVArr objectAtIndex:idx];
         NSComparisonResult comparisonResult = [curComponent compare:lstComponent options:NSNumericSearch];
         if (comparisonResult == NSOrderedSame) return;
         if (comparisonResult == NSOrderedAscending)
         {
             isLastest = NO;
         }
         else if (comparisonResult == NSOrderedDescending)
         {
             isLastest = YES;
         }
         *stop = YES;
     }];
    
    return isLastest;
}

#pragma mark --> 过滤字符
NSString * DQFilterString(NSString *string)
{
    if (string == nil) {
        return nil;
    }
    if ([string isEqualToString:@""]) {
        return @"";
    }
    NSError *error = nil;
    //根据正则表达式生成匹配规则对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\x00-\\x09\\x0b\\x0c\\x0e-\\x1f\\x7F\\x80-\\x9F]" options:NSRegularExpressionCaseInsensitive error:&error];
    //将string中匹配到到字符换为"" 空字符串
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@" "];
    //在interface中使用新的替换完成后的string
    return modifiedString;
    return string;
}
    
    
    
    
    
    
    

@end

