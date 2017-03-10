//
//  UIView+Frame_DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIView+Frame_DQExt.h"

@implementation UIView (Frame_DQExt)

- (CGFloat)left_DQExt
{
    return self.frame.origin.x;
}

- (void)setLeft_DQExt:(CGFloat)left
{
    self.x_DQExt = left;
}

- (CGFloat)top_DQExt {
    return self.frame.origin.y;
}

- (void)setTop_DQExt:(CGFloat)top
{
    self.y_DQExt = top;
}

- (CGFloat)right_DQExt
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_DQExt:(CGFloat)right
{
    self.x_DQExt = right - self.width_DQExt;
}

- (CGFloat)bottom_DQExt
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_DQExt:(CGFloat)bottom
{
    self.y_DQExt = bottom - self.height_DQExt;
}

- (CGFloat)centerX_DQExt
{
    return self.center.x;
}

- (void)setCenterX_DQExt:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY_DQExt
{
    return self.center.y;
}

- (void)setCenterY_DQExt:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)x_DQExt
{
    return self.frame.origin.x;
}

- (void)setX_DQExt:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

- (CGFloat)y_DQExt
{
    return self.frame.origin.y;
}

- (void)setY_DQExt:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y  = y;
    self.frame = tempFrame;
}

- (CGFloat)width_DQExt
{
    return self.frame.size.width;
}

- (void)setWidth_DQExt:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)height_DQExt
{
    return self.frame.size.height;
}

- (void)setHeight_DQExt:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGPoint)orgin_DQExt
{
    return self.frame.origin;
}

- (void)setOrgin_DQExt:(CGPoint)orgin
{
    CGRect frame = self.frame;
    frame.origin = orgin;
    self.frame = frame;
}

- (CGSize)size_DQExt
{
    return self.frame.size;
}

- (void)setSize_DQExt:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)midPoint_DQExt
{
    return CGPointMake(self.width_DQExt * 0.5, self.height_DQExt * 0.5);
}

- (CGFloat)midX_DQExt
{
    return self.width_DQExt * 0.5;
}

- (CGFloat)midY_DQExt
{
    return self.height_DQExt * 0.5;
}
    
@end
