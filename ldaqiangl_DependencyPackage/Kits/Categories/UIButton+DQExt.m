//
//  UIButton+DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIButton+DQExt.h"
#import <objc/runtime.h>

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIButton (DQExt)

@end


@implementation UIButton (ExtendTouchRect_DQExt)

+ (void)load
{
    Swizzle(self,
            @selector(pointInside:withEvent:),
            @selector(myPointInside:withEvent:));
}

- (BOOL)myPointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchExtendInset_DQExt, UIEdgeInsetsZero) ||
        self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled))
    {
        return [self myPointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset_DQExt);
    hitFrame.size.width = MAX(hitFrame.size.width, 0);
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    
    return CGRectContainsPoint(hitFrame, point);
}

static char touchExtendInsetKey_DQExt;
- (void)setTouchExtendInset_DQExt:(UIEdgeInsets)touchExtendInset
{
    objc_setAssociatedObject(self, &touchExtendInsetKey_DQExt,
                             [NSValue valueWithUIEdgeInsets:touchExtendInset],
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)touchExtendInset_DQExt
{
    return [objc_getAssociatedObject(self, &touchExtendInsetKey_DQExt) UIEdgeInsetsValue];
}

@end


























