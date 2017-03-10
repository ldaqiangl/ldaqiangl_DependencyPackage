//
//  DQFileHelper.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DQFile [DQFileHelper sharedFileHelper]

#define DQSaveFileToPath(data, fileName, toPath) \
[DQFile saveFileData:data name:fileName toPath:toPath]

@interface DQFileHelper : NSObject

/**
 @author daqiang
 
 @brief 唯一实例
 
 @return DQFileHelper
 */
+ (instancetype)sharedFileHelper;

/**
 @author daqiang
 
 @brief 保存文件到指定的目录
 
 @param fileData 保存的文件 NSData 类型
 @param toPath 保存的路径
 @param fileName 保存的文件名
 
 @return 是否保存成功
 */
- (BOOL)saveFileData:(NSData *)fileData
                name:(NSString *)fileName
              toPath:(NSString *)toPath;

/**
 @author daqiang
 
 @brief 获取指定目录下的所有文件
 
 @param fromDirectory 文件夹
 @return 文件路径数组 NSArray
 @remark 包括子目录下的文件
 */
- (NSArray<NSString *> *)takeAllFilePathFromDirectory:(NSString *)fromDirectory;

/**
 @author daqiang
 
 @brief 获取指定目录下的文件
 
 @param fromDirectory 文件目录
 @return 文件路径数组 NSArray
 @remark 不包括子目录下的文件
 */
- (NSArray<NSString *> *)takeAllFilePathFromCurrentDirectory:(NSString *)fromDirectory;

/**
 @author daqiang
 
 @brief 获取指定的文件 NSData类型
 
 @param filePath 文件路径
 @param error 错误信息 NSError
 @return NSData
 */
- (NSData *)takeFileData:(NSString *)filePath error:(NSError **)error;

/**
 @author daqiang
 
 @brief 获取指定的图片文件
 
 @param imagePath 文件路径
 @param error 错误信息 NSError
 @return UIImage
 */
- (UIImage *)takeImage:(NSString *)imagePath error:(NSError **)error;

@end





























