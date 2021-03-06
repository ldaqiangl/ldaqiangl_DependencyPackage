//
//  UIViewController+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIViewController+DQExt.h"

@implementation UIViewController (DQExt)

#pragma mark - Public
/** 设置键盘的隐藏 */
- (void)setupForDismissKeyboard_DQExt
{
    // 实例通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // 实例手势
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnyWhereToDismissKeyboard_DQExt:)];
    
    __weak __typeof(self)weakSelf = self;
    
    // 创建主队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    // 监听键盘的即将弹出和隐藏
    [notificationCenter addObserverForName:UIKeyboardWillShowNotification
                                    object:nil queue:mainQueue
                                usingBlock:^(NSNotification *note) {
                                    
                                    [weakSelf.view addGestureRecognizer:singleTapGR];
                                }];
    
    [notificationCenter addObserverForName:UIKeyboardWillHideNotification
                                    object:nil
                                     queue:mainQueue
                                usingBlock:^(NSNotification *note) {
                                    
                                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                                }];
}

/** 获取当前视图所在的控制器 */
- (UIViewController *)currentActivityViewController_DQExt
{
    UIViewController *activityViewController = nil;
    
    // 获取当前主窗口
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if (currentWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *allWindows = [UIApplication sharedApplication].windows;
        for (UIWindow *tempWindow in allWindows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                currentWindow = tempWindow;
                break;
            }
        }
    }
    
    // 获取活动的视图控制器
    NSArray *currentWinViews = [currentWindow subviews];
    if (currentWinViews.count > 0)
    {
        UIView *frontView = [currentWinViews objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = currentWindow.rootViewController;
        }
    }
    
    return activityViewController;
}

/** 隐藏导航栏 */
- (void)hideNavigationBar_DQExt
{
    self.navigationController.delegate = self;
}

#pragma mark - 监听方法
/**
 *  手势监听的方法
 */
- (void)tapAnyWhereToDismissKeyboard_DQExt:(UIGestureRecognizer *)gestureRecognizer
{
    // 此方法会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //如果是当前控制器，则隐藏背景；如果不是当前控制器，则显示背景
    if (viewController == self) {
        for (UIView *view in [self.navigationController.navigationBar subviews])
        {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
            {
                //最好使用隐藏，指不定什么时候你又想让他出现
                view.hidden = YES;
                
                //如果不想让它一直出现，那么可以移除
                //                [view removeFromSuperview];
            }
        }
    }
    else
    {
        for (UIView *view in [self.navigationController.navigationBar subviews])
        {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
            {
                view.hidden = NO;
            }
        }
    }
}

@end
