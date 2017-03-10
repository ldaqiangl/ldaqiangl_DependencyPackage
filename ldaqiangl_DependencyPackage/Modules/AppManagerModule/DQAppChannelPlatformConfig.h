//
//  DQAppChannelPlatformConfig.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>

/** App渠道 平台 */
typedef NS_ENUM(NSInteger, DQAppChannelPlatform)
{
    DQAppFirPlatformChannel,
    DQAppAppStorePlatformChannel,
    DQAppOtherPlatformChannel
};

@interface DQAppChannelPlatformConfig : NSObject

/** App ID */
@property (nonatomic, copy) NSString *appID;
/** Token */
@property (nonatomic, copy) NSString *apiToken;
/** 平台 */
@property (nonatomic, assign) DQAppChannelPlatform platform;

@end
