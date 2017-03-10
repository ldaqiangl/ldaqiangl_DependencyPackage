//
//  CALayer+Frame_DQExt.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Frame_DQExt)

@property (nonatomic) CGFloat left_DQExt;
@property (nonatomic) CGFloat top_DQExt;
@property (nonatomic) CGFloat right_DQExt;
@property (nonatomic) CGFloat bottom_DQExt;

@property (nonatomic) CGFloat width_DQExt;
@property (nonatomic) CGFloat height_DQExt;

@property (nonatomic) CGSize size_DQExt;

@property (nonatomic) CGFloat x_DQExt;
@property (nonatomic) CGFloat y_DQExt;
@property (nonatomic) CGFloat z_DQExt;

@property (readonly) CGPoint midPoint_DQExt;
@property (readonly) CGFloat midX_DQExt;
@property (readonly) CGFloat midY_DQExt;

@end
