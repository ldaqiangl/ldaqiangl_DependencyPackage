//
//  DQAppFirResult.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQAppFirResult.h"

@implementation DQAppFirResult

@end


@implementation DQFIRSizeModel


@end

@implementation DQFIRChangeLogModel

- (BOOL)isForceUpdate {
    
    return [self.force_update isEqualToString:@"true"];
}

@end
