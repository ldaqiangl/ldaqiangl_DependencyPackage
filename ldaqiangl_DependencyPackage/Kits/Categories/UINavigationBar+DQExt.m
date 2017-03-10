//
//  UINavigationBar+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UINavigationBar+DQExt.h"

#import <objc/runtime.h>

#ifndef GreateriOS10
#define GreateriOS10 [[UIDevice currentDevice].systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending
#endif
#define bgView GreateriOS10 ? @"barBackgroundView" : @"backgroundView"
@interface UINavigationBar ()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation UINavigationBar (DQExt)

#pragma mark - Public
/** 设置 NavigationBar 背景色 方法1 */
- (void)setNavBarBackgroundColor_DQExt:(UIColor *)color
{
    if (!self.backgroundView)
    {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.frame = CGRectMake(0, -20, self.bounds.size.width, 20 + self.bounds.size.height);
        [[self.subviews firstObject] insertSubview:self.backgroundView atIndex:0];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundView.userInteractionEnabled = NO;
    }
    self.backgroundView.backgroundColor = color;
}

/** 设置 NavigationBar 背景色 方法2 */
- (void)setNavBarBackgroundColor2:(UIColor *)color
{
    // 为了提高性能，我不想每次设置颜色，都需要进行创建UIImage对象，然后重新赋值
    if (!self.navigationBarBackgroundImage)
    {
        self.barStyle = UIBarStyleBlackOpaque;
        [self setBackgroundViewSubViewAlpha:1.0f];
        self.navigationBarBackgroundImage = [UIImage new];
        [self setBackgroundImage:self.navigationBarBackgroundImage
                   forBarMetrics:UIBarMetricsDefault];
    }
    // 通过KVC拿到这个属性，然后对其进行直接赋值
    UIView *backgroundViewObject = [self valueForKey:bgView];
    // 设置其CALayer属性的颜色值，因为CALayer是通过GPU渲染的，所以性能高一些，又不影响CPU
    backgroundViewObject.layer.backgroundColor = color.CGColor;
}

/** 设置 NavigationBar 的背景透明度 */
- (void)setNavBarBackgroundViewWithAlpha:(CGFloat)alpha
{
    // 为了提高性能，我不想每次设置颜色，都需要进行创建UIImage对象，然后重新赋值
    if (!self.navigationBarBackgroundImage)
    {
        self.navigationBarBackgroundImage = [UIImage new];
        [self setBackgroundImage:self.navigationBarBackgroundImage
                   forBarMetrics:UIBarMetricsDefault];
    }
    // 通过KVC拿到这个属性，然后对其进行直接赋值
    UIView *backgroundViewObject = [self valueForKey:bgView];
    // 设置其CALayer属性的颜色值，因为CALayer是通过GPU渲染的，所以性能高一些，又不影响CPU
    backgroundViewObject.alpha = alpha;
}

/** 设置导航栏左右按钮及标题的透明度 */
- (void)setNavBarElementsAlpha_DQExt:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"]
     enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop)
     {
         view.alpha = alpha;
     }];
    
    [[self valueForKey:@"_rightViews"]
     enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop)
     {
         view.alpha = alpha;
     }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    
    [[self subviews]
     enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")])
         {
             obj.alpha = alpha;
             *stop = YES;
         }
     }];
}

/** 设置导航栏 Y 轴偏移量*/
- (void)setNavBarTranslationY_DQExt:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

/** 重设 NavigationBar 的背景样式为默认的样式 */
- (void)resetNavBarBackgroundDefaultStyle
{
    if (self.navigationBarBackgroundImage)
    {
        self.navigationBarBackgroundImage = nil;
        [self setBackgroundImage:nil
                   forBarMetrics:UIBarMetricsDefault];
    }
    [self setBackgroundViewSubViewAlpha:1.0f];
    self.barStyle = UIBarStyleDefault;
}

/** 重置 NavigationBar */
- (void)resetNavBar_DQExt
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

#pragma mark - Private
#pragma clang diagnostic ignored "-W#warnings"

#warning runtime动态获取 backgroundView
- (void)setBackgroundView:(UIView *)object
{
    [self willChangeValueForKey:bgView];
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:bgView];
}

- (UIView *)backgroundView
{
    return objc_getAssociatedObject(self, @selector(setBackgroundView:));
}

#warning runtime动态添加UIImage属性
static char navigationBar_BackgroundImage;

-(UIImage*)navigationBarBackgroundImage
{
    return objc_getAssociatedObject(self, &navigationBar_BackgroundImage);
}

-(void)setNavigationBarBackgroundImage:(UIImage*)navigationBarBackgroundImage
{
    objc_setAssociatedObject(self, &navigationBar_BackgroundImage, navigationBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma clang diagnostic pop

/**
 @author daqiang
 
 @brief 设置BackgroundViewSubView透明度方法
 
 @param alpha CGFloat
 */
-(void)setBackgroundViewSubViewAlpha:(CGFloat)alpha
{
    // 通过KVC拿到这个属性，然后对其子控件进行修改
    UIView *backgroundViewObject = [self valueForKey:bgView];
    for (UIView* childView in backgroundViewObject.subviews)
    {
        childView.alpha = alpha;
    }
}


@end
