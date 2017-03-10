//
//  CALayer+Frame_DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "CALayer+Frame_DQExt.h"

@implementation CALayer (Frame_DQExt)

#pragma mark 边界

- (CGFloat)left_DQExt
{
    return self.x_DQExt - self.width_DQExt / 2;
}

- (void)setLeft_DQExt:(CGFloat)left_DQExt
{
    [self setX_DQExt:left_DQExt + self.width_DQExt / 2];
}

- (CGFloat)top_DQExt
{
    return self.y_DQExt - self.height_DQExt / 2;
}

- (void)setTop_DQExt:(CGFloat)top_DQExt
{
    [self setY_DQExt:top_DQExt + self.height_DQExt / 2];
}

- (CGFloat)right_DQExt
{
    return self.x_DQExt + self.width_DQExt / 2;
}

- (void)setRight_DQExt:(CGFloat)right_DQExt
{
    [self setX_DQExt:right_DQExt - self.width_DQExt / 2];
}

- (CGFloat)bottom_DQExt {
    
    return self.y_DQExt + self.height_DQExt / 2;
}

- (void)setBottom_DQExt:(CGFloat)bottom_DQExt
{
    [self setY_DQExt:bottom_DQExt - self.height_DQExt / 2];
}

#pragma mark 边界

- (CGFloat)width_DQExt
{
    return self.bounds.size.width;
}

- (void)setWidth_DQExt:(CGFloat)width
{
    [self setBounds:CGRectMake(0, 0, self.height_DQExt, width)];
}

- (CGFloat)height_DQExt
{
    return self.bounds.size.height;
}

- (void)setHeight_DQExt:(CGFloat)height
{
    [self setBounds:CGRectMake(0, 0, self.width_DQExt, height)];
}

- (CGSize)size_DQExt
{
    return self.bounds.size;
}

- (void)setSize_DQExt:(CGSize)size
{
    [self setBounds:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark 位置

- (CGFloat)x_DQExt
{
    return self.position.x;
}

- (void)setX_DQExt:(CGFloat)x
{
    [self setPosition:CGPointMake(x, self.y_DQExt)];
}

- (CGFloat)y_DQExt
{
    return self.position.y;
}

- (void)setY_DQExt:(CGFloat)y
{
    [self setPosition:CGPointMake(self.x_DQExt, y)];
}

- (CGFloat)z_DQExt
{
    return self.zPosition;
}

- (void)setZ_DQExt:(CGFloat)z
{
    [self setZPosition:z];
}

#pragma mark 中心相对于左上角的坐标

- (CGPoint)midPoint_DQExt
{
    return CGPointMake(self.width_DQExt / 2, self.height_DQExt / 2);
}

- (CGFloat)midX_DQExt
{
    return self.width_DQExt / 2;
}

- (CGFloat)midY_DQExt
{
    return self.height_DQExt / 2;
}

@end






















