//
//  UIImage+DQClipping.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clipping_DQExt)

/**
 @author daqiang
 
 @brief 根据size缩放图片
 
 @param newSize 缩放尺寸
 
 @return UIImage
 */
- (instancetype)scaledToSize_DQExt:(CGSize)newSize;

/**
 @author daqiang
 
 @brief 对UIImage进行指定倍数放大
 
 @param scale 放大倍数
 
 @return UIImage
 */
- (instancetype)scale_DQExt:(CGFloat)scale;

/**
 @author daqiang
 
 @brief 根据rect剪切图片
 
 @param newRect rect
 
 @return UIImage
 */
- (instancetype)clipToRect_DQExt:(CGRect)newRect;

/**
 @author daqiang
 
 @brief 等比例缩放图片
 
 @param newSize 缩放尺寸
 
 @return UIImage
 */
- (instancetype)ratioToSize_DQExt:(CGSize)newSize;

/**
 @author daqiang
 
 @brief 按最短边 等比压缩
 
 @param newSize 缩放尺寸
 
 @return UIImage
 */
- (instancetype)ratioCompressToSize_DQExt:(CGSize)newSize;

/**
 @author daqiang
 
 @brief 添加圆角
 
 @param size 圆角大小
 
 @return UIImage
 */
- (instancetype)roundToSize_DQExt:(CGSize)size;

/**
 @author daqiang
 
 @brief 设置 Image 的尺寸
 
 @param size    CGSize
 @param quality CGInterpolationQuality
 
 @return UIImage
 */
- (UIImage *)resizeImageToSize_DQExt:(CGSize)size
                interpolationQuality:(CGInterpolationQuality)quality;

/**
 @author daqiang
 
 @brief 设置图片的 UIViewContentMode、CGSize、CGInterpolationQuality
 
 @param contentMode UIViewContentMode
 @param bounds      CGSize
 @param quality     CGInterpolationQuality
 
 @return UIImage
 */
- (UIImage *)resizedImageWithContentMode_DQExt:(UIViewContentMode)contentMode
                                        bounds:(CGSize)bounds
                          interpolationQuality:(CGInterpolationQuality)quality;


@end
