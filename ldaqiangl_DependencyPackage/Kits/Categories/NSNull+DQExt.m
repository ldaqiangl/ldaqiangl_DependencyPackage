//
//  NSNull+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "NSNull+DQExt.h"
#import <objc/runtime.h>

@implementation NSNull (DQExt)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    // 处理NSNumber,NSString,NSArray,NSDictionary
    NSArray *supporttedTypes = @[@"NSNumber",
                                 @"NSString",
                                 @"NSArray",
                                 @"NSDictionary"];
    
    for (NSUInteger i = 0; i < 4; ++i) {
        
        Method m = class_getInstanceMethod(NSClassFromString(supporttedTypes[i]) , aSelector);
        const char *returnType = method_copyReturnType(m);
        if (returnType) {
            
            free((void *)returnType);
            switch (i) {
                case 0:
                    return @(0);
                case 1:
                    return @"";
                case 2:
                    return @[];
                case 3:
                    return @{};
                default:
                    break;
            }
        }
    }
    
    return [super forwardingTargetForSelector:aSelector];
}


@end
