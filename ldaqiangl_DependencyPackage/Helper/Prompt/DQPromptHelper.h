//
//  DQPromptHelper.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DQPrompt [DQPromptHelper sharedPromptHelper]

/** 正在加载中 */
UIKIT_EXTERN NSString * const DQPromptMessageForLoading;
/** 加载完成 */
UIKIT_EXTERN NSString * const DQPromptMessageForLoadComplete;
/** 正在更新中 */
UIKIT_EXTERN NSString * const DQPromptMessageForUpdating;
/** 更新完成 */
UIKIT_EXTERN NSString * const DQPromptMessageForUpdateComplete;
/** 正在提交中 */
UIKIT_EXTERN NSString * const DQPromptMessageForSubmitting;
/** 提交完成 */
UIKIT_EXTERN NSString * const DQPromptMessageForSubmitComplete;
/** 操作成功  */
UIKIT_EXTERN NSString * const DQPromptMessageForOperateSuccess;
/** 操作失败 */
UIKIT_EXTERN NSString * const DQPromptMessageForOperateFailure;
/** 通用 */
UIKIT_EXTERN NSString * const DQPromptMessageForCommon;
/** 其它 */
UIKIT_EXTERN NSString * const DQPromptMessageForOther;

/**
 @author daqiang
 
 @brief 提示状态
 */
typedef NS_ENUM(NSUInteger, DQPromptState) {
    /** 正在加载 */
    DQPromptStateLoading = 1,
    /** 加载完成 */
    DQPromptStateLoadComplete,
    /** 正在更新 */
    DQPromptStateUpdating,
    /** 加载完成，自动隐藏 */
    DQPromptStateUpdateComplete,
    /** 正在提交 */
    DQPromptStateSubmitting,
    /** 加载完成，自动隐藏 */
    DQPromptStateSubmitComplete,
    /** 操作成功，自动隐藏 */
    DQPromptStateOperateSuccess,
    /** 操作失败，自动隐藏 */
    DQPromptStateOperateFailure,
    /** 普通 */
    DQPromptStateCommon,
    /** 其它 */
    DQPromptStateOther,
};

/**
 @author daqiang
 
 @brief 提示完成Block
 */
typedef void (^DQPromptCompleteBlock)();


/**
 @author daqiang
 
 @brief 提示控件
 */
@interface DQPromptHelper : NSObject

/** 自动隐藏显示时间，默认 1.0f 秒 */
@property (nonatomic, assign) NSTimeInterval showTime;
/** 提示框最小size */
@property (nonatomic, assign) CGSize minSize;
/** MESSAGE字体属性 */
@property (nonatomic, strong) NSDictionary *messageAttributed;
/** DETAIL字体属性 */
@property (nonatomic, strong) NSDictionary *detailAttributed;

/**
 实例
 
 @return DQPromptHelper
 */
+ (instancetype)sharedPromptHelper;

#pragma mark - SETUP

/**
 @author daqiang
 
 @brief 设置不同状态的提示语
 
 @param message 提示语
 @param state   DQPromptState
 */
- (void)setMessage:(NSString *)message
          forState:(DQPromptState)state;

/**
 @author daqiang
 
 @brief 设置不同状态的图标
 
 @param icon  图标
 @param state DQPromptState
 */
- (void)setIcon:(UIImageView *)icon
       forState:(DQPromptState)state;

#pragma mark - SHOW

/**
 @author daqiang
 
 @brief 显示不同状态的提示
 
 @param state DQPromptState
 @param view  视图
 */
- (void)showMessageForState:(DQPromptState)state
                     toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示不同状态的提示，可以添加提示消失后的动作
 
 @param state         DQPromptState
 @param view          视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessageForState:(DQPromptState)state
                     toView:(UIView *)view
                 completion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 显示成功提示
 
 @param view 视图
 */
- (void)showSuccessToView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示指定的成功提示语
 
 @param success success
 @param view    视图
 */
- (void)showSuccess:(NSString *)success
             toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示失败提示
 
 @param view 视图
 */
- (void)showErrorToView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示指定的失败提示语
 
 @param error error
 @param view  视图
 */
- (void)showError:(NSString *)error
           toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示指定的提示
 
 @param message message
 @param view    视图
 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示指定的提示语，可以添加提示消失后的动作
 
 @param message message
 @param view    视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 显示特定提示语，特定图标
 
 @param message  提示语
 @param iconView 图标
 @param view     视图
 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示特定提示语，特定图标，可以添加提示消失后的动作
 
 @param message       提示语
 @param iconView      图标
 @param view          视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 显示包含 message 和 detail 的提示
 
 @param message message
 @param detail  detail
 @param view    视图
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示包含 message 和 detail 的提示，可以添加提示消失后的动作
 
 @param message message
 @param detail  detail
 @param view    视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 显示只包含 message 的提示
 
 @param message message
 @param view    视图
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view;

/**
 @author daqiang
 
 @brief 显示只包含 message 的提示，可以添加提示消失后的动作
 
 @param message message
 @param view    视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
                    completion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作
 
 @param message       message
 @param detail        detail
 @param iconView      icon
 @param view          视图
 @param completeBlock PromptCompleteBlock
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock;

#pragma mark - HIDE

/**
 @author daqiang
 
 @brief 隐藏提示
 */
- (void)hideMessage;

/**
 @author daqiang
 
 @brief 隐藏提示，可以添加提示消失后的动作
 
 @param completeBlock PromptCompleteBlock
 */
- (void)hideMessageCompletion:(DQPromptCompleteBlock)completeBlock;

/**
 @author daqiang
 
 @brief 延迟 delay 秒隐藏提示
 
 @param delay delay
 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay;

/**
 @author daqiang
 
 @brief 延迟 delay 秒隐藏提示，可以添加提示消失后的动作
 
 @param delay         delay
 @param completeBlock PromptCompleteBlock
 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
                   completion:(DQPromptCompleteBlock)completeBlock;

#pragma mark - OTHER

/**
 @author daqiang
 
 @brief 改变提示状态
 
 @param state DQPromptState
 */
- (void)changeState:(DQPromptState)state;


@end

































