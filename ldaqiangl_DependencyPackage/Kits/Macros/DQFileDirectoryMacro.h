//
//  DQFileDirectoryMacro.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#ifndef DQFileDirectoryMacro_h
#define DQFileDirectoryMacro_h


/** 缓存目录 */
#define DQCachesDirectory \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

/** 指定缓存目录 */
#define DQCacheWithDirecotryName(dirName) \
[DQCachesDirectory stringByAppendingPathComponent:dirName]

/** 文档目录 */
#define DQDocumentDirectory \
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

/** 指定文档目录 */
#define DQDocumentWithDirecotryName(dirName) \
[DQDocumentDirectory stringByAppendingPathComponent:dirName]

/** 系统目录 */
#define DQPathDirectory(NSSearchPathDirectory) \
[NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory, NSUserDomainMask, YES) lastObject]




#endif /* DQFileDirectoryMacro_h */
