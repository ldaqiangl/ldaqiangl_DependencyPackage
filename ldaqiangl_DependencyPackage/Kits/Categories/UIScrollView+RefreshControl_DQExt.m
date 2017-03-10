//
//  UIScrollView+RefreshControl_DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIScrollView+RefreshControl_DQExt.h"
#import "MJRefresh.h"

@implementation UIScrollView (RefreshControl_DQExt)

- (void)beginHeaderRefresh_DQExt
{
    if (self.mj_footer.state == MJRefreshStateNoMoreData)
        [self.mj_footer resetNoMoreData];
    [self.mj_header beginRefreshing];
}

- (void)endHeaderRefresh_DQExt
{
    [self.mj_header endRefreshing];
}

- (void)beginFooterRefresh_DQExt
{
    [self.mj_footer beginRefreshing];
}

- (void)endFooterRefresh_DQExt
{
    [self.mj_footer endRefreshing];
}

- (void)hideHeader_DQExt
{
    [self.mj_header setHidden:YES];
}

- (void)hideFooter_DQExt
{
    [self.mj_footer setHidden:YES];
}

- (void)endFooterRefreshingWithNoMoreData_DQExt
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetFooterNoMoreData_DQExt
{
    [self.mj_footer resetNoMoreData];
}

- (void)setupHideFooterNoData_DQExt
{
    if ([self totalDataCount_DQExt]) self.mj_footer.hidden = NO;
    else self.mj_footer.hidden = YES;
}

- (void)headerWithRefreshingBlock_DQExt:(DQRefreshingBlock)refreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    self.mj_header = header;
}

- (void)headerWithRefreshingTarget_DQExt:(id)target
                        refreshingAction:(SEL)action
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target
                                                                     refreshingAction:action];
    self.mj_header = header;
}

- (void)footerWithRefreshingBlock_DQExt:(DQRefreshingBlock)refreshingBlock
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"已经没有更多了" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}

- (void)footerWithRefreshingTarget_DQExt:(id)target
                  refreshingAction:(SEL)action
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target
                                                                             refreshingAction:action];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"已经没有更多了" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}


- (void)removeHeader_DQExt
{
    [self.mj_header removeFromSuperview];
}

- (void)removeFooter_DQExt
{
    [self.mj_footer removeFromSuperview];
}

- (NSInteger)totalDataCount_DQExt
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section<tableView.numberOfSections; section++)
        {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    }
    else if ([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++)
        {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    
    return totalCount;
}

@end
