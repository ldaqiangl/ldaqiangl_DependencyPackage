//
//  NSString+DQPinYin.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "NSString+PinYin_DQExt.h"

@implementation NSString (PinYin_DQExt)

- (NSString *)pinyinString_DQExt
{
    NSAssert([self isKindOfClass:[NSString class]], @"必须是字符串");
    if (self == nil) return nil;
    
    NSMutableString *pinyin = [self mutableCopy];
    
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
    
    return pinyin;
}

- (NSString *)pinyinFirstLetter_DQExt
{
    NSString *pinyin = self.pinyinString_DQExt;
    if (pinyin.length) return [pinyin substringToIndex:1];
    else return @"";
}

@end



@implementation NSArray (PinYin_DQExt)

- (NSArray *)sortedArrayUsingChineseKey_DQExt:(NSString *)chineseKey
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:self.count];
    
    for (int i = 0; i < self.count; ++i)
    {
        NSString *chineseString = (chineseKey == nil) ? self[i] : [self[i] valueForKeyPath:chineseKey];
        [tmpArray addObject:@{@"obj": self[i], @"pinyin": chineseString.pinyinString_DQExt.lowercaseString}];
    }
    
    [tmpArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
     {
         return [obj1[@"pinyin"] compare:obj2[@"pinyin"]];
     }];
    
    return [tmpArray valueForKey:@"obj"];;
    
}

@end
