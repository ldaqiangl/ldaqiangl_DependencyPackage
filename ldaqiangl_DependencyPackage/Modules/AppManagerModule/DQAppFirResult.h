//
//  DQAppFirResult.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class
DQFIRSizeModel,
DQFIRChangeLogModel;

/**
 @author daqinag
 
 @brief FIR平台 App 信息模型
 */

@interface DQAppFirResult : NSObject

/** size */
@property (nonatomic, strong) DQFIRSizeModel *binary;
/** build */
@property (nonatomic, copy) NSString *build;
/** changelog */
@property (nonatomic, strong) DQFIRChangeLogModel *changelog;
/** installUrl（适配 Fir 老版本） */
@property (nonatomic, copy) NSString *installUrl;
/** install_url */
@property (nonatomic, copy) NSString *install_url;
/** download_token */
@property (nonatomic, copy) NSString *download_token;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 更新URL */
@property (nonatomic, copy) NSString *update_url;
/** 更新时间 */
@property (nonatomic, copy) NSString *updated_at;
/** version */
@property (nonatomic, copy) NSString *version;
/** versionShort */
@property (nonatomic, copy) NSString *versionShort;

@end


@interface DQFIRSizeModel : NSObject

/** fsize */
@property (nonatomic, copy) NSNumber *fsize;

@end


@interface DQFIRChangeLogModel : NSObject

/** 标记是否需要强制升级 */
@property (nonatomic, copy) NSString *force_update;
/** 升级的日志内容 */
@property (nonatomic, copy) NSString *content;

#pragma mark 自定义属性
/** 是否强制升级 */
@property (nonatomic, assign, getter = isForceUpdate) BOOL forceUpdate;

@end














