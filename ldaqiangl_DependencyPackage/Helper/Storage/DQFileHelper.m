//
//  DQFileHelper.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQFileHelper.h"

@implementation DQFileHelper

#pragma mark - -> Initialization
/** 唯一实例 */
+ (instancetype)sharedFileHelper {
    
    static DQFileHelper *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{ _instace = [[DQFileHelper alloc] init]; });
    
    return _instace;
}

#pragma mark - -> Public
/** 保存文件到指定的目录 */
- (BOOL)saveFileData:(NSData *)fileData
                name:(NSString *)fileName
              toPath:(NSString *)toPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:toPath])
        [fileManager createDirectoryAtPath:toPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    
    NSString *fullPath = [toPath stringByAppendingPathComponent:fileName];
    BOOL flag = [fileData writeToFile:fullPath atomically:YES];
    if (flag) NSLog(@"文件保存成功，路径%@", fullPath);
    
    return flag;
}

/** 获取指定目录下的所有文件，包括子目录下的文件 */
- (NSArray<NSString *> *)takeAllFilePathFromDirectory:(NSString *)fromDirectory
{
    NSMutableArray *fileArrM = [NSMutableArray new];
    [self takeFileFromPath:fromDirectory
               storeToArrM:&fileArrM
       includeSubdirectory:YES];
    
    return [fileArrM copy];
}

/** 获取指定目录下的文件，不包括子目录下的文件 */
- (NSArray<NSString *> *)takeAllFilePathFromCurrentDirectory:(NSString *)fromDirectory
{
    NSMutableArray *fileArrM = [NSMutableArray array];
    [self takeFileFromPath:fromDirectory
               storeToArrM:&fileArrM
       includeSubdirectory:NO];
    
    return [fileArrM copy];
}

/** 获取指定的文件 NSData类型 */
- (NSData *)takeFileData:(NSString *)filePath
                   error:(NSError *__autoreleasing *)error
{
    NSData *data = nil;
    if ((nil == filePath || filePath.length <= 0) && nil != error)
    {
        NSMutableDictionary *userInfoDictM = [NSMutableDictionary dictionary];
        [userInfoDictM setObject:@"文件不存在!" forKey:NSLocalizedDescriptionKey];
        [userInfoDictM setObject:@"输入正确的文件路径!" forKey:NSLocalizedFailureReasonErrorKey];
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:NSFileReadNoSuchFileError
                                 userInfo:[userInfoDictM copy]];
        return data;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExist && nil != error)
    {
        NSMutableDictionary *userInfoDictM = [NSMutableDictionary dictionary];
        [userInfoDictM setObject:@"文件不存在!" forKey:NSLocalizedDescriptionKey];
        [userInfoDictM setObject:@"输入的文件路径不存在!" forKey:NSLocalizedFailureReasonErrorKey];
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:NSFileReadNoSuchFileError
                                 userInfo:[userInfoDictM copy]];
        return data;
    }
    if (isDirectory && nil != error)
    {
        NSMutableDictionary *userInfoDictM = [NSMutableDictionary dictionary];
        [userInfoDictM setObject:@"文件不存在!" forKey:NSLocalizedDescriptionKey];
        [userInfoDictM setObject:@"输入路径是文件夹路径!" forKey:NSLocalizedFailureReasonErrorKey];
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:NSFileReadInvalidFileNameError
                                 userInfo:[userInfoDictM copy]];
        return data;
    }
    
    data = [NSData dataWithContentsOfFile:filePath
                                  options:NSDataReadingMappedIfSafe
                                    error:error];
    
    return data;
}

/** 获取指定的图片文件 */
- (UIImage *)takeImage:(NSString *)imagePath
                 error:(NSError *__autoreleasing *)error
{
    UIImage *image = nil;
    NSData *imageData = [self takeFileData:imagePath error:error];
    if (nil != imageData) image = [UIImage imageWithData:imageData];
    
    return image;
}

#pragma mark - -> Private
/**
 @author daqiang
 
 @brief 获取指定目录下的文件路径，并保存到指定的容器内
 
 @param fromPath 文件目录
 @param fileArrM 容器 NSMutableArray
 */
- (void)takeFileFromPath:(NSString*)fromPath
             storeToArrM:(NSMutableArray **)fileArrM
     includeSubdirectory:(BOOL)include
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    __block BOOL isDirectory;
    BOOL isExist = [fileManager fileExistsAtPath:fromPath
                                     isDirectory:&isDirectory];
    if (isExist && isDirectory)
    {
        NSArray *tempArrI = [fileManager contentsOfDirectoryAtPath:fromPath
                                                             error:NULL];
        [tempArrI enumerateObjectsUsingBlock:^(NSString *directory,
                                               NSUInteger idx,
                                               BOOL *stop)
         {
             NSString *filePath = [fromPath stringByAppendingPathComponent:directory];
             if (!include)
             {
                 [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
                 if (isDirectory) return ;
             }
             [self takeFileFromPath:filePath
                        storeToArrM:fileArrM
                includeSubdirectory:include];
         }];
    }
    else if (isExist && !isDirectory)
    {
        if ([self isNeedFile:fromPath]) [*fileArrM addObject:fromPath];
    }
}

/**
 @author daqiang
 
 @brief 判断是否是需要的文件
 
 @param filePath 文件路径
 @return BOOL
 */
- (BOOL)isNeedFile:(NSString *)filePath
{
    NSString *fileName = filePath.lastPathComponent;
    return [fileName hasPrefix:@"."] ? NO : YES;
}

@end



















