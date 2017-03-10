//
//  UIBarButtonItem+DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @author daqiang
 
 @remark 需要保存实现的 UIBarButtonItem，然后才能设置其 hidden 和 enable 属性。
 @code @property (weak, nonatomic) UIBarButtonItem *myLeftNavigationItem;
 */
@interface UIBarButtonItem (DQExt)

/**
 @author daqiang
 
 @brief 创建一个自定义导航按钮(标题、默认状态图片、高亮状态图片、代理、点击事件)
 
 @param title            标题
 @param normalImage      默认状态图片
 @param highlightedImage 高亮状态图片
 @param target           代理
 @param action           点击事件
 
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)initWithTitle_DQExt:(NSString *)title
                               normalImg:(NSString *)normalImg
                            highlightImg:(NSString *)highlightImg
                                  target:(id)target
                                  action:(SEL)action;

/**
 @author daqiang
 
 @brief 创建一个自定义导航按钮(标题、默认状态图片、高亮状态图片、代理、点击事件)
 
 @param title            标题
 @param normalImage      默认状态图片
 @param highlightedImage 高亮状态图片
 @param target           代理
 @param action           点击事件
 
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTitle_DQExt:(NSString *)title
                              noralImage:(NSString *)normalImage
                        highlightedImage:(NSString *)highlightedImage
                                  target:(id)target
                                  action:(SEL)action;

/**
 @author daqiang
 
 @brief 创建一个自定义导航按钮(标题、代理、点击事件)
 
 @param title  标题
 @param target 代理
 @param action 点击事件
 
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTitle_DQExt:(NSString *)title
                                  target:(id)target
                                  action:(SEL)action;


@end



@interface UINavigationItem (DQExt)

@end






















