//
//  UIImage+Effect_DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIImageGrayLevelTypeHalfGray    = 0,
    UIImageGrayLevelTypeGrayLevel   = 1,
    UIImageGrayLevelTypeDarkBrown   = 2,
    UIImageGrayLevelTypeInverse     = 3
} UIImageGrayLevelType;

@interface UIImage (Effect_DQExt)

/**
 @author daqiang
 
 @brief 根据色值改变图片的暗度
 
 @param darkValue 色值 变暗多少 0.0 - 1.0
 
 @return UIImage
 */
- (UIImage *)darkToValue_DQExt:(float)darkValue;

/**
 @author daqiang
 
 @brief 根据灰度级别改变图片的灰度
 
 @param type 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
 
 @return UIImage
 */
- (UIImage *)grayToLevelType_DQExt:(UIImageGrayLevelType)type;

/**
 @author daqiang
 
 @brief 加模糊效果
 
 @param blur 模糊度
 
 @return UIImage
 */
- (UIImage *)blurToLevel_DQExt:(CGFloat)blur;

/**
 @author daqiang
 
 @brief 加高斯模糊
 
 @param blurLevel 模糊度
 
 @return UIImage
 */
- (UIImage *)gaussBlur_DQExt:(CGFloat)blurLevel;

/**
 @author daqiang
 
 @brief 添加水印
 
 @param string 内容
 
 @return UIImage
 */
- (UIImage *)watermark_DQExt:(NSString *)content
                  attributes:(NSDictionary *)attributes;

@end
