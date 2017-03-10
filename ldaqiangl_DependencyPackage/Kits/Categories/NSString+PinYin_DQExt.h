//
//  NSString+DQPinYin.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYin_DQExt)

/** 拼音字符串 */
@property (nonatomic, copy, readonly) NSString *pinyinString_DQExt;
/** 拼音首字母 */
@property (nonatomic, copy, readonly) NSString *pinyinFirstLetter_DQExt;

@end

@interface NSArray (PinYin_DQExt)

/**
 @author 大强
 
 @brief 使用指定 key 的属性对数组进行排序
 
 @param chineseKey key
 
 @return NSArray
 */
- (NSArray *)sortedArrayUsingChineseKey_DQExt:(NSString *)chineseKey;

@end
