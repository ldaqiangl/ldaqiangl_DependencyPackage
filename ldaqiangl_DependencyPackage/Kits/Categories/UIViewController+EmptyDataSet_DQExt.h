//
//  UIViewController+EmptyDataSet_DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DQEmptyDataSetDelegate <NSObject>

@optional
- (void)emptyDidTapView_DQExt;
- (void)emptyDidTapButton_DQExt;
- (UIView *)emptyDataCustomView_DQExt;
@end
@interface UIViewController (EmptyDataSet_DQExt)
<DQEmptyDataSetDelegate>

/** 图标 */
@property (nonatomic, copy) NSString *emptyDataSetImage_DQExt;
/** 标题 */
@property (nonatomic, copy) NSString *emptyDataSetTitle_DQExt;
/** 标题颜色 */
@property (nonatomic, strong) UIColor *emptyDataSetTitleColor_DQExt;
/** 描述 */
@property (nonatomic, copy) NSString *emptyDataSetDetail_DQExt;
/** 描述颜色 */
@property (nonatomic, strong) UIColor *emptyDataSetDetailColor_DQExt;
/** 按钮标题 */
@property (nonatomic, copy) NSString *emptyDataSetButtonTitle_DQExt;
/** 按钮标题颜色 */
@property (nonatomic, strong) UIColor *emptyDataSetButtonTitleColor_DQExt;
/** 按钮背景颜色 */
@property (nonatomic, copy) NSString *emptyDataSetButtonBackgroundColor_DQExt;
/** 按钮背景图片 */
@property (nonatomic, copy) NSString *emptyDataSetButtonBackgroundImage_DQExt;


/**
 @author daqiang
 
 @brief 设置空白页
 
 @param target target
 */
- (void)showEmptyDataSet_DQExt:(UIScrollView *)scrollView;

/**
 @author daqing
 
 @brief 显示空白页
 */
- (void)hideEmptyDataSet_DQExt:(UIScrollView *)scrollView;


@end
