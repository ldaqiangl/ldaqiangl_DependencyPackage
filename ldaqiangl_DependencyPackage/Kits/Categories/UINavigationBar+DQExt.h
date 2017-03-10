//
//  UINavigationBar+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (DQExt)

/**
 @author daqiang
 
 @brief 设置 NavigationBar 背景色
 
 @param color UIColor
 */
- (void)setNavBarBackgroundColor_DQExt:(UIColor *)color;

/**
 设置导航栏左右按钮及标题的透明度
 
 @param alpha CGFloat
 */
- (void)setNavBarElementsAlpha_DQExt:(CGFloat)alpha;

/** 设置导航栏 Y 轴偏移量*/

/**
 设置导航栏 Y 轴偏移量
 
 @param translationY CGFloat
 */
- (void)setNavBarTranslationY_DQExt:(CGFloat)translationY;

/**
 重置 NavigationBar
 */
- (void)resetNavBar_DQExt;


@end
