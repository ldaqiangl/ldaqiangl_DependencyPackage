//
//  NSString+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "NSString+DQExt.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (DQExt)

/** 计算文本内容的尺寸，包括文本所占的宽和高 */
- (CGSize)textSizeWithFont_DQExt:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    // 根据文本内容的字体和宽高的属性计算，文本内容所占用的控件区域的大小
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)textSizeWithText_DQExt:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    return [text textSizeWithFont_DQExt:font andMaxSize:maxSize];
}

/** 计算文件或文件夹的大小 */
- (long long)fileSzie_DQExt
{
    // 1.创建文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断filePath是否为文件夹
    BOOL isDirectory = NO;
    if ([mgr fileExistsAtPath:self isDirectory:&isDirectory]) {
        // 文件夹
        
        // 2.1获取目录下的所有文件夹名称
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        
        // 2.2遍历所有文件夹，累加大小
        long long totalSize = 0.0;
        for (NSString *subpath in subpaths) {
            
            NSString *fullPath = [self stringByAppendingPathComponent:subpath];
            totalSize += [[mgr attributesOfItemAtPath:fullPath error:nil][NSFileSize] longLongValue];
        }
        return totalSize;
    } else {
        // 文件
        
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] longLongValue];
    }
}

+ (NSString *)emojiWithIntCode_DQExt:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (NSString *)emoji_DQExt
{
    return [NSString emojiWithStringCode_DQExt:self];
}

+ (NSString *)emojiWithStringCode_DQExt:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    return [self emojiWithIntCode_DQExt:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji_DQExt
{
    BOOL returnValue = NO;
    
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}

//md5 加密
- (NSString *)md5_DQExt
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)isValidateUrl_DQExt
{
    NSString *regular = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    return [predicate evaluateWithObject:self];
}

// 去除左边空格
- (NSString *)stringByTrimmingLeftCharactersInSet_DQExt:(NSCharacterSet *)characterSet {
    
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location = location; location < length; location++) {
        
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

// 去除右边空格
- (NSString *)stringByTrimmingRightCharactersInSet_DQExt:(NSCharacterSet *)characterSet {
    
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length = length; length > 0; length--) {
        
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

+ (NSString *)trim_DQExt:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet {
    NSString *returnVal = @"";
    if (val) {
        returnVal = [val stringByTrimmingCharactersInSet:characterSet];
    }
    return returnVal;
}

+ (NSString *)trimWhitespace_DQExt:(NSString *)val {
    return [self trim_DQExt:val trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]]; //去掉前后空格
}

+ (NSString *)trimNewline_DQExt:(NSString *)val {
    return [self trim_DQExt:val trimCharacterSet:[NSCharacterSet newlineCharacterSet]]; //去掉前后回车符
}

+ (NSString *)trimWhitespaceAndNewline_DQExt:(NSString *)val {
    return [self trim_DQExt:val trimCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去掉前后空格和回车符
}

@end


@implementation NSString (Encode_DQExt)

- (NSString *)MD5String_DQExt
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)SHA1String_DQExt
{
    const char *plaintext = self.UTF8String;
    int length = (int)strlen(plaintext);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(plaintext, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)SHA256String_DQExt
{
    const char *plaintext = self.UTF8String;
    int length = (int)strlen(plaintext);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(plaintext, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)SHA512String_DQExt
{
    const char *plaintext = self.UTF8String;
    int length = (int)strlen(plaintext);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(plaintext, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)SHA1StringWithKey_DQExt:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)SHA256StringWithKey_DQExt:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)SHA512StringWithKey_DQExt:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

#pragma mark - Private
- (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSInteger)length {
    
    NSMutableString *mutableString = @"".mutableCopy;
    for (NSInteger i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end

