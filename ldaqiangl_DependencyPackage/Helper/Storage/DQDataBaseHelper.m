//
//  DQDataBaseHelper.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQDataBaseHelper.h"
#import "FMDB.h"
#import "DQExtentionHeader.h"
#import "DQMacro.h"
#import "DQDataBaseUtils.h"
#import "MJExtension.h"
#import "DQUniversalDBDataModel.h"

NSString *const XZL_APP_USER_DB = @"XZL_APP_USER_DB";

static NSString *const updateId = @"id";
static NSString *const updateObject = @"json";
static NSString *const updateJsonClassName = @"jsonClassName";
static NSString *const updateCreatedTime = @"createdTime";
static NSString *const updateType = @"type";
static NSString *const updatePosition = @"position";
static NSString *const updateText1  = @"text1";
static NSString *const updateText2  = @"text2";
static NSString *const updateText3  = @"text3";

/** 创建一个可以存储json字符串的通用型表的SQL */
static NSString *const CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE, \
json TEXT , \
jsonClassName TEXT , \
createdTime TEXT NOT NULL, \
type TEXT, \
position TEXT NOT NULL, \
text1 TEXT, \
text2 TEXT, \
text3 TEXT)";

/** 插入 (直接覆盖)一个通用型数据 */
static NSString *const INSERT_A_UNIVERSAL_DATA_SQL =
@"REPLACE INTO %@ \
(id, \
json, \
jsonClassName, \
createdTime, \
type, \
position, \
text1, \
text2, \
text3) \
values (?,?,?,?,?,?,?,?,?)";

/** 按照条件删除 */
static NSString *const DELETE_UNIVERSAL_ITEMS_CONDITION_SQL =
@"DELETE from %@ where %@";
/** 删除一个 */
static NSString *const DELETE_UNIVERSAL_ITEM_SQL =
@"DELETE from %@ where id = ?";
/** 删除一组 */
static NSString *const DELETE_UNIVERSAL_ITEMS_SQL =
@"DELETE from %@ where id in ( %@ )";
/** 删除时间最早的一条数据 */
static NSString *const DELETE_LAST_UNIVERSAL_ITEM_SQL =
@"DELETE from %@ where id = (select id from %@ order by createdTime) ";
/** 清空表 */
static NSString *const CLEAR_ALL_UNIVERSA_TABLE_SQL =
@"DELETE from %@";

/** 修改和更新 */
static NSString *const UPDATE_ONE_UNIVERSA_ITEM_CONDITON_SQL =
@"UPDATE %@ set %@ = ? WHERE id = ?";

/** 查询 */
static NSString *const SELECT_WITH_SEARCH_CONDITION_SQL = @"SELECT * from ";

/** 统计和条件 **/
static NSString *const SELECT_ID_DEFINED_COUNT_SQL =
@"SELECT count(id) as count from %@";
/** 拼接时间的sql */
static NSString *const SELECT_MOSAIC_TIME_SQL =
@"order by createdTime desc, position  desc";
/** 拼接降序sql */
static NSString *const ORDER_BY_DESC = @"order by %@ desc";

/** 升序排列 */
NSString *const SORT_ASC = @"ASC";
/** 降序排列 */
NSString *const SORT_DESC = @"DESC";


@interface DQDataBaseHelper ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property(nonatomic, strong) NSRecursiveLock *threadLock;

@end

@implementation DQDataBaseHelper
static NSSet *_foundationClasses;

DQSingletonImplementation(DQDataBaseHelper)

#pragma mark - -> 初始化&基础操作

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.threadLock = [[NSRecursiveLock alloc] init];
        _foundationClasses = [NSSet setWithObjects:
                              [NSObject class], [NSURL class], [NSDate class],
                              [NSNumber class], [NSDecimalNumber class],
                              [NSData class], [NSMutableData class],
                              [NSArray class], [NSMutableArray class],
                              [NSDictionary class], [NSMutableDictionary class],
                              [NSString class], [NSMutableString class], nil];
    }
    return self;
}

- (NSString *)openDatabaseWithUserName:(NSString *)userName {
    
    if (userName.length == 0) {
        
        return nil;
    }
    
    //1、Library/Caches:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //2、userName MD5:
    NSString *userNameMD5 = userName.MD5String_DQExt;
    
    //3、生成数据库所在文件夹
    NSString *documentsDirectory = [[paths firstObject] stringByAppendingPathComponent:userNameMD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory
                                        isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsDirectory
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        if(!bCreateDir) {
            
            DQLog(@"Create Database Directory Failed.");
        }
    }
    
    //4、数据库完整路径 并 初始化数据库
    NSString *dbPath =
    [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",userName]];
    DQLog(@"【用户数据库路径】：%@", dbPath);
    
    if (_dbQueue) {
        
        [self close];
    }
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //5、初始化该数据库中的各个表
    //(1)用户个人信息表【如：昵称、姓名、性别等】
    
    //(2)初始化通用数据表
    
    return documentsDirectory;
}

- (void)close {
    
    [_dbQueue close];
    _dbQueue = nil;
}

- (BOOL)deleteUserDataFolderAndDB:(NSString *)userName {
    //TODO:
 
    return YES;
}

/** 创建一个表 */
- (void)createCustomTableWithName:(NSString *)tableName {
    
    [self _createTable:tableName
                   sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
}

/** 清空表 */
- (void)clearTable:(NSString *)tableName {
    
    if ([self _isValidTableName:tableName] == NO) {
        
        return;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    NSString *sql = [NSString stringWithFormat:CLEAR_ALL_UNIVERSA_TABLE_SQL, tableName];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL result;
    [self _executeDB:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        
        DQLog(@"ERROR,清除表 出错 clear table: %@", tableName);
    }

}

#pragma mark - -> 数据库CRUD操作API

#pragma mark - --> 1、增加和插入数据

/**
 @author daqiang
 
 插入一个数据模型
 
 @param dataModel dataModle
 @return 是否成功
 */
- (BOOL)insertToDBWithDataModel:(NSObject *)dataModel {
    
    Class modelClass = [dataModel class];
    
    //1、表名称
    NSString *tableName = [DQDataBaseUtils getTableNameWithDataModel:modelClass];
    
    if (![self _isValidTableName:tableName]) {
        
        DQLog(@"创建表名称失败：表名称非法");
        return NO;
    }
    
    //2、不存在该表 则创建
    if (![self _isExistTableName:tableName]) {
        
        NSString *createSql =
        [DQDataBaseUtils getCreateTableSQLModelClass:modelClass];
        DQLog(@"\n -----===SQL执行===----- \n%@",createSql);
        
        BOOL ret = [self _createTable:tableName sql:createSql];
        if (!ret) {
            
            DQLog(@"插入操作因为创建表而失败");
            return NO;
        }
    }
    
    //3、执行插入
    DQExecuteSqlInfoModel *sqlInfo = [DQDataBaseUtils getInsertSQLWithDataModel:dataModel];
    
    return [self _executeInsertSQL:sqlInfo.sql andValues:sqlInfo.arguments];
}

- (void)insertToDBWithDataModel:(NSObject *)dataModel
                       callback:(void(^)(BOOL result))block {
    
    BOOL ret = [self insertToDBWithDataModel:dataModel];
    
    if (block) {
        
        block(ret);
    }
}


/**
 插入一条通用型数据到某张表中
 
 @param universalData 通用型的数据模型
 @param tableName 表名
 */
- (BOOL)insertUniversalDataModel:(DQUniversalDBDataModel *)universalData
                         toTable:(NSString *)tableName {
    
    return [self insertUniversalDataWithId:universalData.itemId
                                   jsonStr:universalData.json
                             jsonClassName:universalData.jsonClassName
                               createdTime:universalData.createdTime
                                      type:universalData.type
                                  position:universalData.position
                                     text1:universalData.text1
                                     text2:universalData.text2
                                     text3:universalData.text3
                                  maxCount:0
                                 intoTable:tableName];
}

/** 插入一条通用型数据到存储表中 */
- (BOOL)insertUniversalDataWithId:(NSString *)dataId
                          jsonStr:(NSString *)jsonStr
                    jsonClassName:(NSString *)className
                      createdTime:(NSString *)createdTime
                             type:(NSString *)type
                         position:(NSString *)position
                            text1:(NSString *)text1
                            text2:(NSString *)text2
                            text3:(NSString *)text3
                         maxCount:(int)maxCount
                        intoTable:(NSString *)tableName {
    
    if (dataId == nil) {
        
        return NO;
    }
    
    if (!tableName || tableName.length == 0) {
        
        return NO;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    if (maxCount) {
        
        //需要 查询数据库最早的数据 删掉
        NSString *deleteLastObjsql = [NSString stringWithFormat:
                                      DELETE_LAST_UNIVERSAL_ITEM_SQL,
                                      tableName,
                                      tableName];
        __block BOOL result;
        [self _executeDB:^(FMDatabase *db) {
            
            result = [db executeUpdate:deleteLastObjsql];
        }];
        
        if (!result) {
            
            DQLog(@"ERROR, 删除数据库最早的数据时出错 from table: %@",
                tableName);
        }
    }
    
    if (createdTime && createdTime.length == 0) {
        
    } else {
        
        createdTime = [NSDate getNowTimestamp_DQExt];
    }
    
    NSString *sql = [NSString stringWithFormat:INSERT_A_UNIVERSAL_DATA_SQL, tableName];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL ret;
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:sql,
               dataId,
               jsonStr,
               className,
               createdTime,
               type,
               position,
               text1,
               text2,
               text3];
    }];
    
    if (!ret) {
        
        DQLog(@"ERROR, 插入数据 出错 into table: %@", tableName);
    }
    
    return ret;
}


#pragma mark - --> 2、删除数据
/**
 *  通过条件删除数据
 *
 *  @param condition 删除条件
 *  @param tableName 表名
 */
- (BOOL)deleteUniversalDataByCondition:(NSString *)condition
                             fromTable:(NSString *)tableName {
    
    if (nil == condition || condition.length == 0) {
        
        return NO;
    }
    
    if ([self _isValidTableName:tableName] == NO) {
        
        return NO;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    NSString *sql =
    [NSString stringWithFormat:DELETE_UNIVERSAL_ITEMS_CONDITION_SQL,tableName, condition];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL result;
    [self _executeDB:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        
        DQLog(@"ERROR, 删除数据时出错 table: %@", tableName);
        DQLog(@"%@", [NSString stringWithFormat:@"您已引发bug 出错 : %@", condition]);
    }
    
    return result;
}

- (BOOL)deleteUniversalDataById:(NSString *)dataId
                      fromTable:(NSString *)tableName {
    
    if ([self _isValidTableName:tableName] == NO) {
        
        return NO;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    NSString *sql = [NSString stringWithFormat:DELETE_UNIVERSAL_ITEM_SQL, tableName];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL result;
    [self _executeDB:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql, dataId];
    }];
    
    if (!result) {
        
        DQLog(@"ERROR, 删除某一条数据时出错 table: %@", tableName);
        DQLog(@"%@", [NSString stringWithFormat:@"您已引发bug 出错 : %@", dataId]);
    } else {
        
        DQLog(@"Info :成功删除一条数据 id: %@", dataId);
    }

    return result;
}

- (BOOL)deleteUniversalDatasByIds:(NSArray *)dataIdsArray
                        fromTable:(NSString *)tableName {
    
    if ([self _isValidTableName:tableName] == NO) {
        
        return NO;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    NSMutableString *stringBuilder = [NSMutableString string];
    
    for (id objectId in dataIdsArray) {
        
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        
        if (stringBuilder.length == 0) {
            
            [stringBuilder appendString:item];
        } else {
            
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    
    NSString *sql =
    [NSString stringWithFormat:DELETE_UNIVERSAL_ITEMS_SQL, tableName, stringBuilder];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL result;
    
    [self _executeDB:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        
        DQLog(@"ERROR, 群删 数据时出错 from table: %@", tableName);
    }
    
    return result;
}


#pragma mark - --> 3、更改和更新数据


/**
 更新一条数据到目标表里
 
 @param universalDataModel 通用数据模型
 @param tableName 表名称
 @return 是否成功
 */
- (BOOL)updateUniversalData:(DQUniversalDBDataModel *)universalDataModel
                  intoTable:(NSString *)tableName {
    
    if (universalDataModel.itemId && universalDataModel.itemId.length > 0) {
    } else {
        
        DQLog(@"ERROR：更新失败，通用数据模型id非法");
        return NO;
    }
    
    NSString *itemId = universalDataModel.itemId;
    if (universalDataModel.json && universalDataModel.json.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateObject
                                updatedObj:universalDataModel.json
                                 intoTable:tableName];
    }
    
    if (universalDataModel.jsonClassName && universalDataModel.jsonClassName.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateJsonClassName
                                updatedObj:universalDataModel.jsonClassName
                                 intoTable:tableName];
    }
    
    if (universalDataModel.createdTime && universalDataModel.createdTime.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateCreatedTime
                                updatedObj:universalDataModel.createdTime
                                 intoTable:tableName];
    }
    
    if (universalDataModel.type && universalDataModel.type.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateType
                                updatedObj:universalDataModel.type
                                 intoTable:tableName];
    }
    
    if (universalDataModel.position && universalDataModel.position.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updatePosition
                                updatedObj:universalDataModel.position
                                 intoTable:tableName];
    }
    
    if (universalDataModel.text1 && universalDataModel.text1.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateText1
                                updatedObj:universalDataModel.text1
                                 intoTable:tableName];
    }
    
    if (universalDataModel.text2 && universalDataModel.text2.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateText2
                                updatedObj:universalDataModel.text2
                                 intoTable:tableName];
    }

    if (universalDataModel.text3 && universalDataModel.text3.length > 0) {
        
        [self updateOneFieldDataWithDataId:itemId
                              updatedField:updateText3
                                updatedObj:universalDataModel.text3
                                 intoTable:tableName];
    }
    
    return YES;
}

/**
 更新目标主键对应的数据的某一个字段的数据
 
 @param dataId 主键id
 @param targetField 字段
 @param object 新传入的数据
 @param tableName 表名称
 */
- (BOOL)updateOneFieldDataWithDataId:(NSString *)dataId
                        updatedField:(NSString *)targetField
                          updatedObj:(id)object
                           intoTable:(NSString *)tableName {
    
    if (dataId == nil || object == nil || targetField == nil ||
        [targetField isEqualToString:updatePosition] ||
        [targetField isEqualToString:updateId]) {
        
        DQLog(@"非法参数传入->更新操作失败");
        return NO;
    }
    
    if ([self _isValidTableName:tableName] == NO) {
        
        DQLog(@"非法表名称传入->更新操作失败");
        return NO;
    }
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    
    id updatedObj;
    if ([object isKindOfClass:[NSString class]]) {
        
        updatedObj = object;
    }
    
    NSString *sql =
    [NSString stringWithFormat:UPDATE_ONE_UNIVERSA_ITEM_CONDITON_SQL, tableName, targetField];
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL result;
    [self _executeDB:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql, updatedObj, dataId];
    }];
    
    if (!result) {
        
        DQLog(@"ERROR, 没有更新 table: %@  condition : %@  obj :%@ ",tableName, targetField, object);
    } else {
        
        DQLog(@" 更新成功 table: %@  condition : %@  obj :%@ ",
              tableName,
              targetField, object);
    }
    
    return result;
}



#pragma mark - --> 4、查找数据

/**
 *  根据某条id  查询某条数据  (返回的是DQUniversalDBDataModel 模型)
 */
- (DQUniversalDBDataModel *)searchOneUniversalDataModelById:(NSString *)itemId
                                                  fromTable:(NSString *)tableName {
    NSArray *array =
    [self searchUniversalDataModelWithSearchCondition:[NSString stringWithFormat:@"%@ = '%@'",updateId, itemId]
                                          searchCount:1
                                            fromTable:tableName];
    if (array && array.count > 0) {
        
        return [array lastObject];
    }
    
    return nil;
}

/**
 查询出所有的通用型数据
 
 @param tableName 表名称
 @return DQUniversalDBDataModel数组
 */
- (NSArray *)searchAllUniversalDataModelFromTable:(NSString *)tableName {
    
    NSString *sql =
    [NSString stringWithFormat:@"%@%@",SELECT_WITH_SEARCH_CONDITION_SQL,tableName];
    
    return [self searchUniversalDataModelsWithSQL:sql fromTableName:tableName];
}

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
                                               fromTable:(NSString *)tableName {
    
    if ([self _isValidTableName:tableName] == NO) {
        
        return nil;
    }
    
    
    NSString *sql;
    
    if (searchCondition) {
        
        sql = [NSString stringWithFormat:@"%@ %@ where %@ %@",
               SELECT_WITH_SEARCH_CONDITION_SQL,
               tableName,
               searchCondition,
               SELECT_MOSAIC_TIME_SQL];
    } else {
        
        sql = [NSString stringWithFormat:@"%@ %@ %@",
               SELECT_WITH_SEARCH_CONDITION_SQL,
               tableName,
               SELECT_MOSAIC_TIME_SQL];
    }
    
    if (searchCount) {
        
        sql = [NSString stringWithFormat:@"%@ Limit %d", sql, searchCount];
    }
    
    return [self searchUniversalDataModelsWithSQL:sql fromTableName:tableName];
}

- (NSArray *)searchDataModelsForField:(NSString *)comparedField
                andComparedFieldValue:(NSString *)comparedValue
                          andIsBefore:(BOOL)isThisDataBefore
                      withTargetCount:(NSInteger)targetCount
                            fromTable:(NSString *)tableName
                     isSortDESCResult:(BOOL)isDESC {
    
    NSString *condition =
    [NSString stringWithFormat:@"%@ %@ %@",
     comparedField,
     isThisDataBefore?@"<":@">",
     comparedValue];
    
    __block NSString *sql = [NSString stringWithFormat:
                             @"SELECT * FROM (SELECT * FROM %@ WHERE %@ ORDER BY %@ DESC LIMIT %d) ORDER BY %@ %@",
                             tableName,
                             condition,
                             comparedField,
                             (int)targetCount,
                             comparedField,
                             isDESC?SORT_DESC:SORT_ASC];
    
    return [self searchUniversalDataModelsWithSQL:sql fromTableName:tableName];
}

- (NSArray *)searchUniversalDataModelsWithSQL:(NSString *)sql
                                fromTableName:(NSString *)tableName {
    
    
    if (![self _isExistTableName:tableName]) {
        
        [self _createTable:tableName
                       sql:[NSString stringWithFormat:CREATE_A_UNIVERSAL_DATA_STORE_TABLE_SQL,tableName]];
    }
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block NSMutableArray *result = [NSMutableArray array];
    
    [self _executeDB:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            DQUniversalDBDataModel *item = [[DQUniversalDBDataModel alloc] init];
            item.itemId = [rs stringForColumn:updateId];
            item.json = [rs stringForColumn:updateObject];
            item.jsonClassName = [rs stringForColumn:updateJsonClassName];
            item.createdTime = [rs stringForColumn:updateCreatedTime];
            item.type = [rs stringForColumn:updateType];
            item.position = [rs stringForColumn:updatePosition];
            item.text1 = [rs stringForColumn:updateText1];
            item.text2 = [rs stringForColumn:updateText2];
            item.text3 = [rs stringForColumn:updateText3];
            [result addObject:item];
        }
        
        [rs close];
    }];
    
    return result;
}


#pragma mark - -> 其他辅助操作API

/**
 清空表
 
 @param tableName 表名称
 */
- (BOOL)cleanAllDataForTable:(NSString *)tableName {
    
    __block NSString *sql = [NSString stringWithFormat:
                             CLEAR_ALL_UNIVERSA_TABLE_SQL,
                             tableName];
    
    DQLog(@"\n -----===SQL执行===----- \n%@",sql);
    
    __block BOOL ret = NO;
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:sql];
    }];

    return ret;
}


#pragma mark - -> 私有方法

/**
 判断传入的表名称 是否合法
 
 @param tableName 表名称
 @return YES:合法，NO:非法
 */
- (BOOL)_isValidTableName:(NSString *)tableName {
    
    if (tableName == nil ||
        tableName.length == 0 ||
        [tableName rangeOfString:@" "].location != NSNotFound) {
        
        DQLog(@"数据库判断 表名是否合格出错, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

/** 是否存在表 */
- (BOOL)_isExistTableName:(NSString *)tableName {
    
    if (!(tableName && tableName.length > 0)) {
        
        return NO;
    }
    
    __block BOOL ret = NO;
    
    __block NSString *chatTableName = tableName;
    
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db tableExists:chatTableName];
    }];
    
    return ret;
}

/** 创建表 */
- (BOOL)_createTable:(NSString *)tableName
                sql:(NSString *)createSql {
    
    if ([self _isValidTableName:tableName] == NO) {
        
        DQLog(@"表名称非法");
        return NO;
    }
    
    NSString *creat_table_sql = createSql;
    DQLog(@"\n -----===SQL执行===----- \n%@",createSql);
    
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db tableExists:tableName]) {
            
            result = [db executeUpdate:creat_table_sql];
            
            if (!result) {
                
                DQLog(@"ERROR, 创表 出错 create table: %@", tableName);
            }
        }
    }];
    
    return result;
}

/**
 执行插入SQL
 */
- (BOOL)_executeInsertSQL:(NSString *)insertSql
                andValues:(NSArray *)values {
    
    __block BOOL ret = NO;
    
    DQLog(@"执行insert sql：%@",insertSql);
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:insertSql withArgumentsInArray:values];
    }];
    
    return ret;
}

- (BOOL)_executeInsertSQL:(NSString *)insertSql
        withParameterDictionary:(NSDictionary *)valueDic {
    
    __block BOOL ret = NO;
    
    DQLog(@"执行insert sql：%@",insertSql);
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:insertSql withParameterDictionary:valueDic];
    }];
    
    return ret;
}

/**
 执行删除SQL
 */
- (BOOL)_executeDeleteSQL:(NSString *)deleteSql {
    
    __block BOOL ret = NO;
    
    DQLog(@"执行Delete sql：%@",deleteSql);
    
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:deleteSql];
    }];
    
    return ret;
}


/**
 执行更新SQL
 */
- (BOOL)_executeUpdateSQL:(NSString *)updateSql {
    
    __block BOOL ret = NO;
    DQLog(@"执行updateSql sql：%@",updateSql);
    
    [self _executeDB:^(FMDatabase *db) {
        
        ret = [db executeUpdate:updateSql];
    }];
    
    return ret;
}

/**
 执行查询SQL
 */
- (BOOL)_executeSearchSQL:(NSString *)searchSql {
    
    __block BOOL ret = NO;
    DQLog(@"执行searchSql sql：%@",searchSql);
    
    [self _executeDB:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:searchSql];
        while ([rs next]) {
            
        }
        [rs close];
    }];
    
    return ret;
}

/**
 获取要执行数据库的DB
 */
- (void)_executeDB:(void (^)(FMDatabase *db))block {
    
    [_threadLock lock];
    
    if(_dbQueue == nil) {
        
        [self openDatabaseWithUserName:XZL_APP_USER_DB];
        
        [_dbQueue inDatabase:^(FMDatabase *db) {
#ifdef DEBUG
             //debug 模式下  打印错误日志
             db.logsErrors = YES;
#endif
         }];
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        block(db);
    }];
    
    [_threadLock unlock];
}

/**
 *  判断数据库数据个数  如果大于一定数目  需要删除 时间最早的一条
 */
- (BOOL)isMoreThanTheDefaultCount:(int)definedCount
                        fromTable:(NSString *)tableName {
    
    NSString *sql =
    [NSString stringWithFormat:SELECT_ID_DEFINED_COUNT_SQL, tableName];
    
    __block int jsonCount = 0;
    [self _executeDB:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next]) {
            
            jsonCount = [rs intForColumn:@"count"];
        }
        [rs close];
    }];
    
    if (jsonCount < definedCount) {
        
        return NO;
    } else {
        
        return YES;
    }
}






@end
