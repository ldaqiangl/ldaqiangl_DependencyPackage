//
//  DQPromptHelper.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/8.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQPromptHelper.h"

#import "MBProgressHUD.h"

NSString * const DQPromptMessageForLoading = @"正在加载……";
NSString * const DQPromptMessageForLoadComplete = @"加载完成！";
NSString * const DQPromptMessageForUpdating = @"正在更新……";
NSString * const DQPromptMessageForUpdateComplete = @"更新完成！";
NSString * const DQPromptMessageForSubmitting = @"正在提交……";
NSString * const DQPromptMessageForSubmitComplete = @"提交完成！";
NSString * const DQPromptMessageForOperateSuccess = @"操作成功！";
NSString * const DQPromptMessageForOperateFailure = @"操作失败！";
NSString * const DQPromptMessageForCommon = @"";
NSString * const DQPromptMessageForOther = @"";

static NSString * const DQPromptIconForSuccess = @"prompt_success_icon";
static NSString * const DQPromptIconForFailure = @"prompt_error_icon";
static NSString * const DQPromptIconForCommon = @"placeholder_small";

@interface DQPromptHelper()

/** 所有状态对应的提示语 */
@property (nonatomic, strong) NSMutableDictionary *stateMessages;
/** 所有状态对应的图标 */
@property (nonatomic, strong) NSMutableDictionary *stateIcons;
/** 保存当前的提示框 */
@property (nonatomic, weak) MBProgressHUD *myHud;

@end

@implementation DQPromptHelper

#pragma mark - -> LazyLoading
- (NSMutableDictionary *)stateMessages
{
    if (nil == _stateMessages)
    {
        _stateMessages = [NSMutableDictionary dictionary];
    }
    
    return _stateMessages;
}

- (NSMutableDictionary *)stateIcons
{
    if (nil == _stateIcons)
    {
        _stateIcons = [NSMutableDictionary dictionary];
    }
    
    return _stateIcons;
}

#pragma mark - -> initialization
- (instancetype)init
{
    if (self = [super init])
    {
        [self setupDefaultValue];
        [self prepareMessageForState];
        [self prepareIconForState];
    }
    
    return self;
}

+ (instancetype)sharedPromptHelper
{
    static DQPromptHelper *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{ _instace = [[DQPromptHelper alloc] init]; });
    
    return _instace;
}

#pragma mark - -> Public

/** 改变不同状态下的提示语 */
- (void)setMessage:(NSString *)message
          forState:(DQPromptState)state
{
    if (nil == message) return;
    self.stateMessages[@(state)] = message;
}

/** 设置不同状态的图标 */
- (void)setIcon:(UIImageView *)icon
       forState:(DQPromptState)state
{
    if (nil == icon) return;
    
    UIImage *fitImage = [self scaledImage:icon.image
                                   toSize:CGSizeMake(37, 37)];
    icon.image = fitImage;
    self.stateIcons[@(state)] = icon;
}

#pragma mark Show

/** 显示不同状态的提示 */
- (void)showMessageForState:(DQPromptState)state
                     toView:(UIView *)view
{
    BOOL autoHide = NO;
    switch (state)
    {
        case DQPromptStateLoading:
        case DQPromptStateUpdating:
        case DQPromptStateSubmitting:
        case DQPromptStateCommon:
        case DQPromptStateOther:
        {
            autoHide = NO;
            break;
        }
        case DQPromptStateLoadComplete:
        case DQPromptStateUpdateComplete:
        case DQPromptStateSubmitComplete:
        case DQPromptStateOperateSuccess:
        case DQPromptStateOperateFailure:
        {
            autoHide = YES;
            break;
        }
    }
    
    [self showPromptMessage:self.stateMessages[@(state)]
                     detail:nil
                   iconView:self.stateIcons[@(state)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:autoHide];
}

/** 显示不同状态的提示，可以添加提示消失后的动作 */
- (void)showMessageForState:(DQPromptState)state
                     toView:(UIView *)view
                 completion:(DQPromptCompleteBlock)completeBlock
{
    [self showMessageForState:state
                       toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示成功提示 */
- (void)showSuccessToView:(UIView *)view
{
    [self showMessageForState:DQPromptStateOperateSuccess
                       toView:view];
}

/** 显示指定的成功提示语 */
- (void)showSuccess:(NSString *)success
             toView:(UIView *)view
{
    [self showPromptMessage:success
                     detail:nil
                   iconView:self.stateIcons[@(DQPromptStateOperateSuccess)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:YES];
}

/** 显示失败提示 */
- (void)showErrorToView:(UIView *)view
{
    [self showMessageForState:DQPromptStateOperateFailure
                       toView:view];
}

/** 显示指定的失败提示语 */
- (void)showError:(NSString *)error
           toView:(UIView *)view
{
    [self showPromptMessage:error
                     detail:nil
                   iconView:self.stateIcons[@(DQPromptStateOperateFailure)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:YES];
}

/** 显示指定的提示 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
{
    [self showPromptMessage:message
                     detail:nil
                   iconView:nil
              toContentView:view
                 ignoreIcon:NO
                   autoHide:NO];
}

/** 显示指定的提示语，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock
{
    [self showMessage:message
               toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示特定提示语，特定图标 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
{
    [self showPromptMessage:message
                     detail:nil
                   iconView:iconView
              toContentView:view
                 ignoreIcon:NO
                   autoHide:NO];
}

/** 显示特定提示语，特定图标，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock
{
    [self showMessage:message
       customIconView:iconView
               toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示包含 message 和 detail 的提示 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
{
    [self showPromptMessage:message
                     detail:detail
                   iconView:nil
              toContentView:view
                 ignoreIcon:YES
                   autoHide:NO];
}

/** 显示包含 message 和 detail 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock
{
    [self showMessage:message
               detail:detail
               toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示只包含 message 的提示 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
{
    [self showMessage:message
               detail:nil
               toView:view];
}

/** 显示只包含 message 的提示，可以添加提示消失后的动作 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
                    completion:(DQPromptCompleteBlock)completeBlock
{
    [self showMessage:message
               toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(DQPromptCompleteBlock)completeBlock
{
    BOOL ignore = nil == iconView ? NO : NO;
    [self showPromptMessage:message
                     detail:detail
                   iconView:iconView
              toContentView:view
                 ignoreIcon:ignore
                   autoHide:NO];
}

#pragma mark Hide

/** 隐藏提示 */
- (void)hideMessage
{
    if (nil == self.myHud) return;
    [self.myHud hideAnimated:YES];
}

/** 隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageCompletion:(DQPromptCompleteBlock)completeBlock
{
    [self hideMessage];
    self.myHud.completionBlock = completeBlock;
}

/** 延迟 delay 秒隐藏提示 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
{
    if (nil == self.myHud) return;
    [self.myHud hideAnimated:YES afterDelay:delay];
}

/** 延迟 delay 秒隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
                   completion:(DQPromptCompleteBlock)completeBlock
{
    [self hideMessageAfterDelay:delay];
    self.myHud.completionBlock = completeBlock;
}

#pragma mark - -> Other

/** 改变提示状态 */
- (void)changeState:(DQPromptState)state
{
    // 保存提示框文字属性
    NSAttributedString *messageAttributedString = nil;
    if (self.myHud.label.attributedText)
    {
        messageAttributedString = [[NSAttributedString alloc] initWithAttributedString:self.myHud.label.attributedText];
    }
    NSAttributedString *detailAttributedString = nil;
    if (self.myHud.detailsLabel.attributedText)
    {
        detailAttributedString = [[NSAttributedString alloc] initWithAttributedString:self.myHud.detailsLabel.attributedText];
    }
    
    // 设置提示框图标
    if (nil != self.stateIcons[@(state)])
    {
        [self.myHud setCustomView:self.stateIcons[@(state)]];
        self.myHud.mode = MBProgressHUDModeCustomView;
    }
    
    // 设置提示框文字属性
    self.myHud.label.attributedText = messageAttributedString;
    self.myHud.detailsLabel.attributedText = detailAttributedString;
}

#pragma mark - -> Private

/**
 @author daqiang
 
 @brief 初始所有状态提示语
 */
- (void)prepareMessageForState
{
    self.stateMessages[@(DQPromptStateLoading)] = DQPromptMessageForLoading;
    self.stateMessages[@(DQPromptStateLoadComplete)] = DQPromptMessageForLoadComplete;
    self.stateMessages[@(DQPromptStateUpdating)] = DQPromptMessageForUpdating;
    self.stateMessages[@(DQPromptStateUpdateComplete)] = DQPromptMessageForUpdateComplete;
    self.stateMessages[@(DQPromptStateSubmitting)] = DQPromptMessageForSubmitting;
    self.stateMessages[@(DQPromptStateSubmitComplete)] = DQPromptMessageForSubmitComplete;
    self.stateMessages[@(DQPromptStateOperateSuccess)] = DQPromptMessageForOperateSuccess;
    self.stateMessages[@(DQPromptStateOperateFailure)] = DQPromptMessageForOperateFailure;
    self.stateMessages[@(DQPromptStateCommon)] = DQPromptMessageForCommon;
    self.stateMessages[@(DQPromptStateOther)] = DQPromptMessageForOther;
}

/**
 @author daqiang
 
 @brief 初始所有状态图标
 */
- (void)prepareIconForState
{
    // 成功图标
    UIImage *completeImg = [UIImage imageNamed:DQPromptIconForSuccess];
    if (nil == completeImg) completeImg = [self imageWithResourceName:@"success.png"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    
    // 失败图标
    UIImage *failureImg = [UIImage imageNamed:DQPromptIconForFailure];
    if (nil == failureImg) failureImg = [self imageWithResourceName:@"failure.png"];
    UIImageView *failureImgView = [[UIImageView alloc] initWithImage:failureImg];
    
    [self setIcon:nil forState:DQPromptStateLoading];
    [self setIcon:completeImgView forState:DQPromptStateLoadComplete];
    [self setIcon:nil forState:DQPromptStateUpdating];
    [self setIcon:completeImgView forState:DQPromptStateUpdateComplete];
    [self setIcon:nil forState:DQPromptStateSubmitting];
    [self setIcon:completeImgView forState:DQPromptStateSubmitComplete];
    [self setIcon:completeImgView forState:DQPromptStateOperateSuccess];
    [self setIcon:failureImgView forState:DQPromptStateOperateFailure];
    [self setIcon:nil forState:DQPromptStateCommon];
    [self setIcon:nil forState:DQPromptStateOther];
}

/**
 @author daqiang
 
 @brief 初始默认值
 */
- (void)setupDefaultValue
{
    self.showTime = 1.0f;
    self.minSize = CGSizeMake(200, 100);
    self.messageAttributed = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                               NSForegroundColorAttributeName : [UIColor darkTextColor],
                               };
    self.detailAttributed = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                              NSForegroundColorAttributeName : [UIColor magentaColor],
                              };
}

/**
 @author daqiang
 
 @brief 设置提示框内容
 */
- (void)showPromptMessage:(NSString *)message
                   detail:(NSString *)detail
                 iconView:(UIImageView *)iconView
            toContentView:(UIView *)view
               ignoreIcon:(BOOL)ignore
                 autoHide:(BOOL)hide
{
    if (nil != self.myHud)
    {
        [self.myHud hideAnimated:YES];
        self.myHud = nil;
    }
    
    // 实例
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [self promptToView:view];
    self.myHud = hud;
    
    // mode
    if (nil != iconView)
    {
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *fitImg = [self scaledImage:iconView.image
                                     toSize:CGSizeMake(37, 37)];
        iconView.image = fitImg;
        
        hud.customView = iconView;
        hud.mode = MBProgressHUDModeCustomView;
    }
    else if (ignore)
    {
        hud.mode = MBProgressHUDModeText;
    }
    
    // 设置提示语
    if (nil !=  message && message.length)
        hud.label.attributedText = [[NSAttributedString alloc] initWithString:message attributes:self.messageAttributed];
    if (nil != detail && detail.length)
        hud.detailsLabel.attributedText = [[NSAttributedString alloc] initWithString:detail attributes:self.detailAttributed];
    
    if (hide) [hud hideAnimated:YES afterDelay:self.showTime];
}

/**
 @author daqiang
 
 @brief 创建提示框到 View 视图上
 
 @param view 视图
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)promptToView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minSize = self.minSize;
    hud.graceTime = 1.0f;
    hud.minShowTime = 0.25;
    hud.margin = 5.0f;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

/**
 @author daqiang
 
 @brief 根据size缩放图片
 */
- (UIImage *)scaledImage:(UIImage *)image
                  toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 @author daqiang
 
 @brief 实例资源目录下的图片
 
 @param name 图片名
 
 @return UIImage
 */
- (UIImage *)imageWithResourceName:(NSString *)name
{
    NSBundle *promptBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[DQPromptHelper class]] pathForResource:@"Prompt.bundle" ofType:nil]];
    NSString *imgPath = [promptBundle pathForResource:name ofType:nil];
    
    return [UIImage imageWithContentsOfFile:imgPath];
}


@end






























