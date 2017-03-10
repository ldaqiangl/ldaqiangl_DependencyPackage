//
//  DQDataBaseHelper.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSingletonMacro.h"
@class DQUniversalDBDataModel;

extern NSString *const XZL_APP_USER_DB;

#define DQDBHelper [DQDataBaseHelper sharedDQDataBaseHelper]

@interface DQDataBaseHelper : NSObject

DQSingletonInterface(DQDataBaseHelper)

#pragma mark - -> 数据库DB初始化操作API

/** 根据用户名（id） 打开相应的数据库
 *  返回 该用户所属文件夹的目录路径
 */
- (NSString *)openDatabaseWithUserName:(NSString *)userName;
/** 删除某个用户所有缓存的数据和该数据所在的文件夹 */
- (BOOL)deleteUserDataFolderAndDB:(NSString *)userName;
/** 关闭 */
- (void)close;

#pragma mark - -> 数据库CRUD操作API

#pragma mark - --> 0、表操作

/** 创建一个表 */
- (void)createCustomTableWithName:(NSString *)tableName;
/** 清空表 */
- (void)clearTable:(NSString *)tableName;

#pragma mark - --> 1、增加和插入数据

/**
 插入一条通用型数据到某张表中
 
 @param universalData 通用型的数据模型
 @param tableName 表名
 */
- (BOOL)insertUniversalDataModel:(DQUniversalDBDataModel *)universalData
                         toTable:(NSString *)tableName;


#pragma mark - --> 2、删除数据

/**
 *  通过条件删除数据
 *
 *  @param condition 类似于 "id＝xx and name=xx"
 *  @param tableName 表名
 */
- (BOOL)deleteUniversalDataByCondition:(NSString *)condition
                             fromTable:(NSString *)tableName;

/**
 删除指定主键id的数据
 
 @param dataId 主键
 @param tableName 表名称
 */
- (BOOL)deleteUniversalDataById:(NSString *)dataId
                      fromTable:(NSString *)tableName;

/**
 批量删除指定的 一组 主键ID 对应的数据

 @param dataIdsArray 主键id 数组
 @param tableName 表名
 */
- (BOOL)deleteUniversalDatasByIds:(NSArray *)dataIdsArray
                        fromTable:(NSString *)tableName;

/**
 清空表
 
 @param tableName 表名称
 */
- (BOOL)cleanAllDataForTable:(NSString *)tableName;

#pragma mark - --> 3、更改和更新数据

/**
 更新一条数据到目标表里
 
 @param universalDataModel 通用数据模型
 除了itemID外 其他字段可以任意指定有值或没值，有值就更新，没值不会做任何操作
 @param tableName 表名称
 @return 是否成功
 */
- (BOOL)updateUniversalData:(DQUniversalDBDataModel *)universalDataModel
                  intoTable:(NSString *)tableName;


#pragma mark - --> 4、查找数据

/**
 *  根据某条id  查询某条数据  (返回的是DQUniversalDBDataModel 模型)
 */
- (DQUniversalDBDataModel *)searchOneUniversalDataModelById:(NSString *)itemId
                                                  fromTable:(NSString *)tableName;

/**
 查询出所有的通用型数据
 
 @param tableName 表名称
 @return DQUniversalDBDataModel数组
 */
- (NSArray *)searchAllUniversalDataModelFromTable:(NSString *)tableName;

/**
 *  根据条件筛选
 *
 *  @param searchCondition 筛选条件 比如 type = 1111 and id > 2 sql条件交给用户
 *
 *  @param searchCount 如果为空默认是所有的数据
 *  @return 返回 这个表中的满足这个查询条件的 数据
 */
- (NSArray *)searchUniversalDataModelWithSearchCondition:(NSString *)searchCondition
                                             searchCount:(int)searchCount
                                               fromTable:(NSString *)tableName;
/**
 对作为比较的字段comparedField，类似于|createdTime、position|等
 和一个这个字段要比较的值comparedValue
 是否获取这个值之前（isThisDataBefore==YES）和之后（isThisDataBefore==NO）
 的targetCount条数据 ，并按照isDESC对获取的这targetCount数据是否降序排列
 返回

 @param comparedField 比较的字段名称
 @param comparedValue 要比较的值大小
 @param isThisDataBefore 是否在这个字段对应的比较值之前
 @param targetCount 获取多少条数据
 @param tableName 表名称
 @param isDESC 对获取的最终结果 是否降序返回
 @return 返回DQUniversalDBDataModel 实例数组
 */
- (NSArray *)searchDataModelsForField:(NSString *)comparedField
                andComparedFieldValue:(NSString *)comparedValue
                          andIsBefore:(BOOL)isThisDataBefore
                      withTargetCount:(NSInteger)targetCount
                            fromTable:(NSString *)tableName
                     isSortDESCResult:(BOOL)isDESC;

/** 执行查询SQL语句 */
- (NSArray *)searchUniversalDataModelsWithSQL:(NSString *)sql
                                fromTableName:(NSString *)tableName;

#pragma mark - -> 其他辅助操作API


@end















