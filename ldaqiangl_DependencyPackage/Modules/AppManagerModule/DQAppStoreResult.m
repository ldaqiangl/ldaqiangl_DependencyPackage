//
//  DQAppStoreResult.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQAppStoreResult.h"

@implementation DQAppStoreResult

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"results" : [DQAppStoreInfo class]};
}

@end

@implementation DQAppStoreInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"describe" : @"description"};
}


@end
