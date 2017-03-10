//
//  UIViewController+EmptyDataSet_DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIViewController+EmptyDataSet_DQExt.h"

#import "UIScrollView+EmptyDataSet.h"
#import "UIImage+Instance_DQExt.h"
#import "UIColor+DQExt.h"
#import <objc/runtime.h>

@interface DQWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;
@end

@implementation DQWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object
{
    if (self == [super init])
    {
        _weakObject = object;
    }
    
    return self;
}

@end


static char const * const kEmptyDataSetImage = "emptyDataSetImage";
static char const * const kEmptyDataSetTitle = "emptyDataSetTitle";
static char const * const kEmptyDataSetTitleColor = "emptyDataSetImageColor";
static char const * const kEmptyDataSetDetail = "emptyDataSetDetail";
static char const * const kEmptyDataSetDetailColor = "emptyDataSetDetailColor";
static char const * const kEmptyDataSetButtonTitle = "emptyDataSetButtonTitle";
static char const * const kEmptyDataSetButtonTitleColor = "emptyDataSetButtonTitleColor";
static char const * const kEmptyDataSetButtonBackgroundColor = "emptyDataSetButtonBackgroundColor";
static char const * const kEmptyDataSetButtonBackgroundImage = "emptyDataSetButtonBackgroundImage";

@interface UIViewController (EmptyDataSet_DQExt)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation UIViewController (EmptyDataSet_DQExt)

- (NSString *)emptyDataSetImage_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetImage);
    return container.weakObject;
}

- (void)setEmptyDataSetImage_DQExt:(NSString *)emptyDataSetImage
{
    objc_setAssociatedObject(self, kEmptyDataSetImage, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetImage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSetTitle_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetTitle);
    return container.weakObject;
}

- (void)setEmptyDataSetTitle_DQExt:(NSString *)emptyDataSetTitle
{
    objc_setAssociatedObject(self, kEmptyDataSetTitle, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetTitle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)emptyDataSetTitleColor_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetTitleColor);
    return container.weakObject;
}

- (void)setEmptyDataSetTitleColor_DQExt:(UIColor *)emptyDataSetTitleColor
{
    objc_setAssociatedObject(self, kEmptyDataSetTitleColor, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetTitleColor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSetDetail_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetDetail);
    return container.weakObject;
}

- (void)setEmptyDataSetDetail_DQExt:(NSString *)emptyDataSetDetail
{
    objc_setAssociatedObject(self, kEmptyDataSetDetail, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetDetail], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)emptyDataSetDetailColor_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetDetailColor);
    return container.weakObject;
}

- (void)setEmptyDataSetDetailColor_DQExt:(UIColor *)emptyDataSetDetailColor
{
    objc_setAssociatedObject(self, kEmptyDataSetDetailColor, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetDetailColor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSetButtonTitle_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetButtonTitle);
    return container.weakObject;
}

- (void)setEmptyDataSetButtonTitle_DQExt:(NSString *)emptyDataSetButtonTitle
{
    objc_setAssociatedObject(self, kEmptyDataSetButtonTitle, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetButtonTitle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)emptyDataSetButtonTitleColor_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetButtonTitleColor);
    return container.weakObject;
}

- (void)setEmptyDataSetButtonTitleColor_DQExt:(UIColor *)emptyDataSetButtonTitleColor
{
    objc_setAssociatedObject(self, kEmptyDataSetButtonTitleColor, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetButtonTitleColor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSetButtonBackgroundColor_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetButtonBackgroundColor);
    return container.weakObject;
}

- (void)setEmptyDataSetButtonBackgroundColor_DQExt:(NSString *)emptyDataSetButtonBackgroundColor
{
    objc_setAssociatedObject(self, kEmptyDataSetButtonBackgroundColor, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetButtonBackgroundColor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSetButtonBackgroundImage_DQExt
{
    DQWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetButtonBackgroundImage);
    return container.weakObject;
}

- (void)setEmptyDataSetButtonBackgroundImage_DQExt:(NSString *)emptyDataSetButtonBackgroundImage
{
    objc_setAssociatedObject(self, kEmptyDataSetButtonBackgroundImage, [[DQWeakObjectContainer alloc] initWithWeakObject:emptyDataSetButtonBackgroundImage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 设置空白页 */
- (void)showEmptyDataSet_DQExt:(UIScrollView *)scrollView
{
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
    [scrollView reloadEmptyDataSet];
}

- (void)hideEmptyDataSet_DQExt:(UIScrollView *)scrollView
{
    scrollView.emptyDataSetSource = nil;
    scrollView.emptyDataSetDelegate = nil;
}

- (NSAttributedString *)DQEmptyDataSetTitleAttribute:(NSString *)title
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIFont systemFontOfSize:15]
                   forKey:NSFontAttributeName];
    [attributes setObject:self.emptyDataSetTitleColor_DQExt ? self.emptyDataSetTitleColor_DQExt : [UIColor lightGrayColor]
                   forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:attributes];
}

- (NSAttributedString *)DQEmptyDataSetDetailAttribute:(NSString *)detail
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIFont systemFontOfSize:13]
                   forKey:NSFontAttributeName];
    [attributes setObject:self.emptyDataSetTitleColor_DQExt ? self.emptyDataSetDetailColor_DQExt : [UIColor lightGrayColor]
                   forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraph
                   forKey:NSParagraphStyleAttributeName];
    return [[NSMutableAttributedString alloc] initWithString:detail
                                                  attributes:attributes];
}

- (NSAttributedString *)DQEmptyDataSetButtonTitleAttribute:(NSString *)title
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIFont systemFontOfSize:13]
                   forKey:NSFontAttributeName];
    [attributes setObject:self.emptyDataSetButtonTitleColor_DQExt ? self.emptyDataSetButtonTitleColor_DQExt : [UIColor whiteColor]
                   forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:attributes];
}

#pragma mark - DZNEmptyDataSet
#pragma mark <DZNEmptyDataSetSource>
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (nil != self.emptyDataSetImage_DQExt && self.emptyDataSetImage_DQExt.length)
    {
        return [UIImage imageNamed:self.emptyDataSetImage_DQExt];
    }
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (nil != self.emptyDataSetTitle_DQExt && self.emptyDataSetTitle_DQExt.length)
    {
        return [self DQEmptyDataSetTitleAttribute:self.emptyDataSetTitle_DQExt];
    }
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (nil != self.emptyDataSetDetail_DQExt && self.emptyDataSetDetail_DQExt.length)
    {
        return [self DQEmptyDataSetDetailAttribute:self.emptyDataSetDetail_DQExt];
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (nil != self.emptyDataSetButtonTitle_DQExt && self.emptyDataSetButtonTitle_DQExt.length)
    {
        return [self DQEmptyDataSetButtonTitleAttribute:self.emptyDataSetButtonTitle_DQExt];
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (nil != self.emptyDataSetButtonBackgroundImage_DQExt && self.emptyDataSetButtonBackgroundImage_DQExt.length)
    {
        return [UIImage imageNamed:self.emptyDataSetButtonBackgroundImage_DQExt];
    }
    
    if (nil != self.emptyDataSetButtonBackgroundColor_DQExt && self.emptyDataSetButtonBackgroundColor_DQExt.length)
    {
        return [UIImage imageWithColor_DQExt:[UIColor colorWithHexString_DQExt:self.emptyDataSetButtonBackgroundColor_DQExt]
                                     andSize:CGSizeMake(100, 100)];
    }
    
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self respondsToSelector:@selector(emptyDataCustomView_DQExt)])
    {
        return [self emptyDataCustomView_DQExt];
    }
    return nil;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -scrollView.contentOffset.y * 0.5;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

#pragma mark <DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if ([self respondsToSelector:@selector(emptyDidTapView_DQExt)])
    {
        [self emptyDidTapView_DQExt];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if ([self respondsToSelector:@selector(emptyDidTapButton_DQExt)])
    {
        [self emptyDidTapButton_DQExt];
    }
}

@end




























