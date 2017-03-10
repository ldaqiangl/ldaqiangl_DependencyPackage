//
//  DQUniversalDBDataModel.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQUniversalDBDataModel : NSObject

/** 此字段不能为空 */
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *json;
@property (nonatomic, copy) NSString *jsonClassName;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *type;
/** 此字段不能为空必须指定一个值,无用可以指定@“0” */
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@property (nonatomic, copy) NSString *text3;

@end
