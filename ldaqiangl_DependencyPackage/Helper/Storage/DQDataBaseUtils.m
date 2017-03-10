//
//  DQDataBaseUtils.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQDataBaseUtils.h"
#import "MJExtension.h"

NSString *DB_SET_PRIMARY_KEY(NSString *sql,NSString *key) {
    
    return [NSString stringWithFormat:@"%@,PRIMARY KEY(%@)",sql,key];
}

//字段声明条件
static NSString *const DQDB_FIELD_NOT_NULL = @"NOT NULL";
static NSString *const DQDB_FIELD_NOT_NULL_UNIQUE = @"NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE";
static NSString *const DQDB_FIELD_PRIMARY_KEY = @"PRIMARY KEY";
static NSString *const DQDB_FIELD_AUTOINCREMENT = @"AUTOINCREMENT";
//字段属性
static NSString *const DQDB_FIELD_TEXT = @"TEXT";
static NSString *const DQDB_FIELD_INTEGER = @"INTEGER";
static NSString *const DQDB_FIELD_DOUBLE = @"DOUBLE";
static NSString *const DQDB_FIELD_BLOB = @"BLOB";
static NSString *const DQDB_FIELD_LONG_TEXT = @"varchar(2048)";
//InitTable & CRUD
static NSString *const DQDB_CREATE_TABLE = @"CREATE TABLE";

@implementation DQDataBaseUtils

+ (NSString *)getTableNameWithDataModel:(Class)modelClass {
    
    return NSStringFromClass(modelClass);
}


+ (NSString *)getCreateTableSQLModelClass:(Class)modelClass {
    
    NSString *tableName = [self getTableNameWithDataModel:modelClass];
    NSArray *allFields = [self allSortedFieldsForClass:modelClass];
    
    NSMutableString *sql_create =
    [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (",tableName];
    
    for (NSInteger i = 0; i < allFields.count; i++) {
        
        NSString *fieldStr = allFields[i];
        [sql_create appendString:fieldStr];
        
        if ([@"dqPrimaryKeyId" isEqualToString:fieldStr]) {
            
            [sql_create appendFormat:@" %@ %@",
             DQDB_FIELD_TEXT,DQDB_FIELD_NOT_NULL_UNIQUE];
        } else {
            
            [sql_create appendFormat:@" %@",DQDB_FIELD_TEXT];
        }
        
        if (i < allFields.count-1) {
            
            [sql_create appendString:@" ,"];
        }
    }
    
    [sql_create appendString:@")"];
    
    return sql_create;
}

+ (DQExecuteSqlInfoModel *)getInsertSQLWithDataModel:(NSObject *)dataModel {
    
    NSMutableString *insertPreSQL = [[NSMutableString alloc] initWithString:@"REPLACE INTO"];
    NSMutableString *insertLastSQL = [[NSMutableString alloc] initWithString:@" values("];
    
    NSString *tabelName = [self getTableNameWithDataModel:[dataModel class]];
    [insertPreSQL appendFormat:@" %@(",tabelName];
    
    NSDictionary *keyValuesDic = dataModel.mj_keyValues;
    NSArray *allFiels = [keyValuesDic allKeys];

    NSMutableArray *allValues = [NSMutableArray array];
    for (NSInteger i = 0;i < allFiels.count; i++) {
        
        NSString *filedName = [NSString stringWithFormat:@"%@",allFiels[i]];
        [insertPreSQL appendString:filedName];
        [insertLastSQL appendString:@"?"];
        if (i < allFiels.count-1) {
            
            [insertPreSQL appendString:@","];
            [insertLastSQL appendString:@","];
        } else {
            
            [insertPreSQL appendString:@")"];
            [insertLastSQL appendString:@")"];
        }
        
        NSString *value =
        [NSString stringWithFormat:@"%@",[keyValuesDic objectForKey:filedName]];
        [allValues addObject:value];
    }
    
    DQExecuteSqlInfoModel *sqlInfo = [[DQExecuteSqlInfoModel alloc] init];
    sqlInfo.sql = [NSString stringWithFormat:@"%@%@",insertPreSQL,insertLastSQL];
    sqlInfo.arguments = allValues;
    
    return sqlInfo;
}

+ (NSString *)allFields:(Class)modelClass {
    
    NSArray *arr = [self allSortedFieldsForClass:modelClass];
    return [arr componentsJoinedByString:@","];
}

+ (NSArray *)allSortedFieldsForClass:(Class)modelClass {
    
    NSMutableArray *fields = [NSMutableArray array];
    
    [modelClass mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
       
        [fields addObject:[[NSString alloc] initWithString:property.name]];
    }];
    
    return fields;
}

@end


@implementation DQExecuteSqlInfoModel


@end














