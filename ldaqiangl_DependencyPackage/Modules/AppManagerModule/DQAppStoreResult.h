//
//  DQAppStoreResult.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 @author daqiang
 
 @brief AppStore 平台 App 信息模型
 */

@interface DQAppStoreResult : NSObject

/** 个数 */
@property (nonatomic, copy) NSString *resultCount;
/** App 信息 */
@property (nonatomic, strong) NSArray *results;

@end


@interface DQAppStoreInfo : NSObject

/** advisories */
@property (nonatomic, strong) NSArray *advisories;
/** features */
@property (nonatomic, strong) NSArray *features;
/** kind */
@property (nonatomic, copy) NSString *kind;
/** wrapperType */
@property (nonatomic, copy) NSString *wrapperType;
/** isVppDeviceBasedLicensingEnabled */
@property (nonatomic, copy) NSString *isVppDeviceBasedLicensingEnabled;

/** 开发者 ID */
@property (nonatomic, copy) NSString *artistId;
/** 开发者名称 */
@property (nonatomic, copy) NSString *artistName;
/** 开发者 App List */
@property (nonatomic, copy) NSString *artistViewUrl;
/** App Icon */
@property (nonatomic, copy) NSString *artworkUrl60;
/** App Icon */
@property (nonatomic, copy) NSString *artworkUrl100;
/** App Icon */
@property (nonatomic, copy) NSString *artworkUrl512;
/** iPhone 屏幕截图 */
@property (nonatomic, strong) NSArray *screenshotUrls;
/** iPad 屏幕截图 */
@property (nonatomic, strong) NSArray *ipadScreenshotUrls;
/** Apple TV 屏幕截图 */
@property (nonatomic, strong) NSArray *appletvScreenshotUrls;
/** 支持的语言 */
@property (nonatomic, strong) NSArray *languageCodesISO2A;
/** 支持最低系统的版本 */
@property (nonatomic, copy) NSString *minimumOsVersion;
/** 支持的设备 */
@property (nonatomic, strong) NSArray *supportedDevices;
/** 类别 ID 列表 */
@property (nonatomic, strong) NSArray *genreIds;
/** 类别名称列表 */
@property (nonatomic, strong) NSArray *genres;
/** 主要类别 ID */
@property (nonatomic, copy) NSString *primaryGenreId;
/** 主类别名称 */
@property (nonatomic, copy) NSString *primaryGenreName;
/** 游戏中心开关 */
@property (nonatomic, copy) NSString *isGameCenterEnabled;
/** 销售方名称 */
@property (nonatomic, copy) NSString *sellerName;

/** Bundle ID */
@property (nonatomic, copy) NSString *bundleId;
/** App 审核评级 */
@property (nonatomic, copy) NSString *contentAdvisoryRating;
/** App ID */
@property (nonatomic, copy) NSString *trackId;
/** App 名称*/
@property (nonatomic, copy) NSString *trackName;
/** 审查名称 */
@property (nonatomic, copy) NSString *trackCensoredName;
/** App 评级 */
@property (nonatomic, copy) NSString *trackContentRating;
/** App 下载网址 */
@property (nonatomic, copy) NSString *trackViewUrl;
/** App 大小,单位：Byte */
@property (nonatomic, copy) NSString *fileSizeBytes;
/** 描述 */
@property (nonatomic, copy) NSString *describe;
/** 版本 */
@property (nonatomic, copy) NSString *version;
/** 价格格式 */
@property (nonatomic, copy) NSString *formattedPrice;
/** 销售范围 */
@property (nonatomic, copy) NSString *currency;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 第一次上线日期 */
@property (nonatomic, copy) NSString *releaseDate;
/** 当前版本上线日期 */
@property (nonatomic, copy) NSString *currentVersionReleaseDate;
/** 当前版本信息 */
@property (nonatomic, copy) NSString *releaseNotes;

@end


