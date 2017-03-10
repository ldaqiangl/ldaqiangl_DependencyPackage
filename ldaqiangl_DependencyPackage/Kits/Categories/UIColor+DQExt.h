//
//  UIColor+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/** rgb颜色转换（16进制->10进制） */
#define DQColorWithHexValue(hexValue) \
[UIColor colorWithHexValue:hexValue]

/** 十六进制颜色字符串转为UIColor */
#define DQColorWithHexString(hexString) \
[UIColor colorWithHexString:hexString]

/** 带有RGBA的颜色设置 */
#define DQColorWithRGBA(red, green, blue, alpha) \
[UIColor colorWithR:red/255.0 G:green/255.0 B:blue/255.0 A:alpha]

/** 带有RGB的颜色设置 */
#define DQColorWithRGB(red, green, blue) \
[UIColor colorWithR:red/255.0 G:green/255.0 B:blue/255.0]

/** 随机颜色 */
#define DQRandomColor \
[UIColor randomColor]

UIKIT_EXTERN NSString * const DQHexDefaulColorKey;

@interface UIColor (DQExt)

#pragma mark - 类方法
/**
 @author daqiang
 
 @brief RGBA的颜色设置
 
 @param red   red
 @param green green
 @param blue  blue
 @param alpha alpha
 
 @return UIColor
 */
+ (instancetype)colorWithR_DQExt:(CGFloat)red
                         G:(CGFloat)green
                         B:(CGFloat)blue
                         A:(CGFloat)alpha;

/**
 @author daqiang
 
 @brief RGB的颜色设置
 
 @param red   red
 @param green green
 @param blue  blue
 
 @return UIColor
 */
+ (instancetype)colorWithR_DQExt:(CGFloat)red
                         G:(CGFloat)green
                         B:(CGFloat)blue;
/**
 @author daqiang
 
 @brief 十六进制字符串转为颜色，可以设置透明度
 
 @param hexColor 十六进制字符串
 @param alphaValue 透明度
 
 @return UIColor
 */
+ (instancetype)colorWithHexString_DQExt:(NSString *)hexString
                             alpha:(CGFloat)alphaValue;

/**
 @author daqiang
 
 @brief 十六进制字符串转为颜色
 
 @param hexColor 十六进制字符串
 
 @return UIColor
 */
+ (instancetype)colorWithHexString_DQExt:(NSString *)hexString;

/**
 @author daqiang
 
 @brief 十六进制数值转为颜色，可以设置透明度
 
 @param hexValue   十六进制数值
 @param alphaValue 透明度
 
 @return UIColor
 */
+ (instancetype)colorWithHexValue_DQExt:(NSInteger)hexValue
                            alpha:(CGFloat)alphaValue;

/**
 @author daqiang
 
 @brief 十六进制数值转为颜色
 
 @param hexValue   十六进制数值
 
 @return UIColor
 */
+ (instancetype)colorWithHexValue_DQExt:(NSInteger)hexValue;

/**
 @author daqiang
 
 @brief 随机颜色
 
 @return UIColor
 */
+ (instancetype)randomColor_DQExt;

#pragma mark - 对象方法
/**
 @author daqiang
 
 @brief 获取颜色的十六进制字符串
 
 @return 十六进制字符串
 */
- (NSString *)hexString_DQExt;

/**
 @author daqiang
 
 @brief 设置颜色的透明度
 
 @param alpha 透明度(0.0~1.0)
 
 @return UIColor
 */
-(UIColor *)colorWithAlpha_DQExt:(CGFloat)alpha;

/**
 @author daqiang
 
 @brief 获取UIColor中红色的取值
 
 @return NSInteger
 */
-(NSInteger)red_DQExt;

/**
 @author daqiang
 
 @brief 获取UIColor中绿色的取值
 
 @return NSInteger
 */
-(NSInteger)green_DQExt;

/**
 @author daqiang
 
 @brief 获取UIColor中蓝色的取值
 
 @return NSInteger
 */
-(NSInteger)blue_DQExt;

/**
 @author daqiang
 
 @brief 获取UIColor中透明度的取值
 
 @return NSInteger
 */
-(CGFloat)alpha_DQExt;

/**
 @author daqiang
 
 @brief 设置反色
 
 @return UIColor
 */
-(UIColor *)reversedColor_DQExt;

@end
