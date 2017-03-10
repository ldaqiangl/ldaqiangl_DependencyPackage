//
//  UIScrollView+RefreshControl_DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 进入刷新状态的回调 */
typedef void (^DQRefreshingBlock)();

@interface UIScrollView (RefreshControl_DQExt)

/**
 @author daqiang
 
 @brief 开始下拉刷新
 */
- (void)beginHeaderRefresh_DQExt;

/**
 @author daqiang
 
 @brief 结束下拉刷新
 */
- (void)endHeaderRefresh_DQExt;

/**
 @author daqiang
 
 @brief 开始上拉加载
 */
- (void)beginFooterRefresh_DQExt;

/**
 @author daqiang
 
 @brief 结束上拉加载
 */
- (void)endFooterRefresh_DQExt;

/**
 @author daqiang
 
 @brief 隐藏下拉刷新
 */
- (void)hideHeader_DQExt;

/**
 @author daqiang
 
 @brief 隐藏上拉加载
 */
- (void)hideFooter_DQExt;

/**
 @author daqiang
 
 @brief 结束上拉加载，并提示没有更多
 */
- (void)endFooterRefreshingWithNoMoreData_DQExt;

/**
 @author daqiang
 
 @brief 重置没有更多提示
 */
- (void)resetFooterNoMoreData_DQExt;

/**
 @author daqiang
 
 @brief 当没有数据时，隐藏上拉刷新
 @remark 暂未实现，现等同于 - (void)hideFooter
 */
- (void)setupHideFooterNoData_DQExt;

/**
 @author daqiang
 
 @brief 添加下拉刷新
 
 @param refreshingBlock DQRefreshingBlock
 */
- (void)headerWithRefreshingBlock_DQExt:(DQRefreshingBlock)refreshingBlock;

/**
 @author daqiang
 
 @brief 添加下拉刷新
 
 @param target Target
 @param action Action
 */
- (void)headerWithRefreshingTarget_DQExt:(id)target
                        refreshingAction:(SEL)action;

/**
 @author daqiang
 
 @brief 添加上拉加载
 
 @param refreshingBlock DQRefreshingBlock
 */
- (void)footerWithRefreshingBlock_DQExt:(DQRefreshingBlock)refreshingBlock;

/**
 @author daqiang
 
 @brief 添加上拉加载
 
 @param target Target
 @param action Action
 */
- (void)footerWithRefreshingTarget_DQExt:(id)target
                        refreshingAction:(SEL)action;
/**
 @author daqiang
 
 @brief 移除下拉刷新
 */
- (void)removeHeader_DQExt;

/**
 @author daqiang
 
 @brief 移除上拉加载
 */
- (void)removeFooter_DQExt;

/**
 @author daqiang
 
 @brief 获取TableView或Collection的单元数
 
 @return NSInteger
 */
- (NSInteger)totalDataCount_DQExt;

@end
