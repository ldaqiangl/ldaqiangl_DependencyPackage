//
//  UIImage+Instance_DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Instance_DQExt)

/**
 @author daqiang
 
 @brief 创建指定大小、指定颜色的纯色图片
 
 @param color UIColor
 @param size  CGSize
 
 @return UIImage
 */
+ (UIImage *)imageWithColor_DQExt:(UIColor *)color
                    andSize:(CGSize)size;

/**
 @author daqiang
 
 @brief 根据字符串内容，创建指定大小的图片
 
 @param string 字符串
 @param size   CGSize
 
 @return UIImage
 */
+ (UIImage *)imageWithString_DQExt:(NSString *)string
                           andSize:(CGSize)size;

/**
 @author daqiang
 
 @brief 从图片中心拉伸图片
 @remark 从图片中心拉伸
 @param imageName 图片名称
 
 @return UIImage
 */
+ (UIImage *)imageNameToMiddleStretch_DQExt:(NSString *)imageName;
- (UIImage *)middleStretch_DQExt;

/**
 @author daqiang
 
 @brief 指定位置拉伸图片
 
 @param imageNmae 图片名称
 @param leftRatio 左边比率
 @param topRatio  上边比率
 
 @return UIImage
 */
+ (UIImage *)imageNameToStretch_DQExt:(NSString *)imageNmae
                      leftRatio:(CGFloat)leftRatio
                       topRatio:(CGFloat)topRatio;
- (UIImage *)stretchLeftRatio_DQExt:(CGFloat)leftRatio
                     topRatio:(CGFloat)topRatio;

/**
 @author daqiang
 
 @brief 获取当前视图截图
 
 @param theView 当前视图
 
 @return UIImage
 */
+ (UIImage *)imageFromView_DQExt:(UIView *)theView;

/**
 @author daqiang
 
 @brief 获取启动图片
 
 @return UIImage
 */
+ (UIImage *)launchImage_DQExt;

@end
