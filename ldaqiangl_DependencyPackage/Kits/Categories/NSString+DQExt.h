//
//  NSString+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DQExt)

/**
 *  计算文本内容的尺寸，包括文本所占的宽和高
 */
- (CGSize)textSizeWithFont_DQExt:(UIFont *)font andMaxSize:(CGSize)maxSize;
+ (CGSize)textSizeWithText_DQExt:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

/**
 *  计算文件或文件夹的大小
 *
 *  @return 文件的大小
 */
- (long long)fileSzie_DQExt;


/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode_DQExt:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode_DQExt:(NSString *)stringCode;
- (NSString *)emoji_DQExt;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji_DQExt;


- (NSString *)md5_DQExt;

- (BOOL)isValidateUrl_DQExt;
/**
 *  去除左边空格
 */
- (NSString *)stringByTrimmingLeftCharactersInSet_DQExt:(NSCharacterSet *)characterSet ;
/**
 *  去除右边空格
 */
- (NSString *)stringByTrimmingRightCharactersInSet_DQExt:(NSCharacterSet *)characterSet ;

+ (NSString *)trimWhitespaceAndNewline_DQExt:(NSString *)val;


@end


@interface NSString (Encode_DQExt)

@property (nonatomic, copy, readonly) NSString *MD5String_DQExt;
@property (nonatomic, copy, readonly) NSString *SHA1String_DQExt;
@property (nonatomic, copy, readonly) NSString *SHA256String_DQExt;
@property (nonatomic, copy, readonly) NSString *SHA512String_DQExt;

- (NSString *)SHA1StringWithKey_DQExt:(NSString *)key;
- (NSString *)SHA256StringWithKey_DQExt:(NSString *)key;
- (NSString *)SHA512StringWithKey_DQExt:(NSString *)key;

@end
