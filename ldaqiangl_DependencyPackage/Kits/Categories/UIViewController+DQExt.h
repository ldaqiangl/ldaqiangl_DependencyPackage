//
//  UIViewController+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DQExt)<UINavigationControllerDelegate>

/**
 @author daqiang
 
 @brief 设置键盘的隐藏
 */
- (void)setupForDismissKeyboard_DQExt;

/**
 @author daqiang
 
 @brief 获取当前活动的视图控制器
 
 @return 活动控制器
 */
- (UIViewController *)currentActivityViewController_DQExt;

/**
 @author daqiang
 
 @brief 隐藏导航栏
 */
- (void)hideNavigationBar_DQExt;


@end
