//
//  UIView+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIView+DQExt.h"

@implementation UIView (DQExt)

@end


@implementation UIView (DQViewController)
    
/** 获取当前视图所在的控制器 */
- (UIViewController *)viewController_DQExt {
    
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            
            return (UIViewController *)responder;
        }
    
    return nil;
}
    
@end
