//
//  DQSingletonMacro.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#ifndef DQSingletonMacro_h
#define DQSingletonMacro_h


/** .h文件 方法声明 */
#define DQSingletonInterface(className) + (instancetype)shared##className;

/** .m文件 方法实现*/
#if __has_feature(objc_arc)
#define DQSingletonImplementation(className) \
static className *_instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
+ (instancetype)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
#else
#define DQSingletonImplementation(className) \
static className *_instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
+ (instancetype)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)retain { return _instance; }  \
- (oneway void)release { }  \
- (id)autorelease { return _instance; }  \
- (NSUInteger)retainCount { return UINT_MAX; }
#endif

#endif /* DQSingletonMacro_h */
