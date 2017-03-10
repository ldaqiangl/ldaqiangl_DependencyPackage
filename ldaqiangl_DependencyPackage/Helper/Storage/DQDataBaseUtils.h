//
//  DQDataBaseUtils.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DQExecuteSqlInfoModel;
@interface DQDataBaseUtils : NSObject

+ (NSString *)getTableNameWithDataModel:(Class)modelClass;
+ (NSString *)getCreateTableSQLModelClass:(Class)modelClass;
+ (DQExecuteSqlInfoModel *)getInsertSQLWithDataModel:(NSObject *)dataModel;



@end


@interface DQExecuteSqlInfoModel : NSObject

@property (nonatomic, copy) NSString *sql;
@property (nonatomic, strong) NSArray *arguments;

@end


























