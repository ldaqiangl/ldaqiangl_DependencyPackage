//
//  UIImage+Instance_DQExt.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/5.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "UIImage+Instance_DQExt.h"
#import "UIImage+Effect_DQExt.h"
#import "UIColor+DQExt.h"

@implementation UIImage (Instance_DQExt)

#pragma mark - Public
/** 根据传入参数的颜色创建相应颜色的图片 */
+ (UIImage *)imageWithColor_DQExt:(UIColor *)color
                    andSize:(CGSize)size
{
    CGFloat width = size.width >= MAXFLOAT ? 1.0f : size.width;
    CGFloat height = size.height >= MAXFLOAT ? 1.0f : size.height;
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/** 根据字符串内容，创建指定大小的图片 */
+ (UIImage *)imageWithString_DQExt:(NSString *)string
                     andSize:(CGSize)size
{
    NSArray *colorArrI = [NSArray arrayWithObjects:
                          @"f4a739", @"f9886d", @"6fb7e7", @"8ec566", @"f97c94",
                          @"bdce00", @"f794be", @"7ccfde", @"b0a1d3", @"ff9c9c",
                          @"80e2c5", @"eebd93", @"b4beef", @"f1aea8", @"9abfdf",
                          @"ed8aa6", @"e2d240", @"e97984", @"acd3be", @"d8a7ca",
                          @"98da8e", @"eeaa93", @"f7ae4a", @"fcca4d", @"e8c707",
                          @"f299af", @"94ca76", @"c4d926", @"d6c7b0", @"a1d8ef",
                          nil];
    
    NSUInteger index = [self colorIndexOfString_DQExt:string fromColorTotal:colorArrI.count];
    UIColor *color = [UIColor colorWithHexString_DQExt:[colorArrI objectAtIndex:index]];
    UIImage *pureColorImage = [self imageWithColor_DQExt:color andSize:size];
    string = [self watermarkFromString_DQExt:string];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    return [pureColorImage watermark_DQExt:string attributes:attributes];
}

/** 获取拉伸不变形的图片 */
+ (UIImage *)imageNameToMiddleStretch_DQExt:(NSString *)name
{
    return [self imageNameToStretch_DQExt:name
                          leftRatio:0.5
                           topRatio:0.5];
}

- (UIImage *)middleStretch_DQExt
{
    return [self stretchLeftRatio_DQExt:0.5
                         topRatio:0.5];
}

/** 指定位置拉伸图片 */
+ (UIImage *)imageNameToStretch_DQExt:(NSString *)imageNmae
                      leftRatio:(CGFloat)leftRatio
                       topRatio:(CGFloat)topRatio
{
    UIImage *image = [UIImage imageNamed:imageNmae];
    CGSize imageSize = image.size;
    image = [image stretchableImageWithLeftCapWidth:imageSize.width * leftRatio
                                       topCapHeight:imageSize.height * topRatio];
    
    return image;
}

- (UIImage *)stretchLeftRatio_DQExt:(CGFloat)leftRatio
                     topRatio:(CGFloat)topRatio
{
    CGSize imageSize = self.size;
    
    return [self stretchableImageWithLeftCapWidth:imageSize.width * leftRatio
                                     topCapHeight:imageSize.height * topRatio];;
}

/** 获取当前视图截图 */
+ (UIImage *)imageFromView_DQExt: (UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/** 获取启动图片 */
+ (UIImage *)launchImage_DQExt
{
    UIApplication *application = [UIApplication sharedApplication];
    CGSize viewSize = application.keyWindow.bounds.size;
    UIInterfaceOrientation currentOrientation = application.statusBarOrientation;
    
    NSString *viewOrientation = @"";
    switch (currentOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            viewOrientation = @"Portrait";
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            viewOrientation = @"Landscape";
            break;
        default:
            viewOrientation = @"Portrait";
            break;
    }
    
    NSString *launchImageName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString([dict objectForKey:@"UILaunchImageSize"]);
        NSString *orientation = [dict objectForKey:@"UILaunchImageOrientation"];
        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:orientation])
        {
            launchImageName = [dict objectForKey:@"UILaunchImageName"];
            break;
        }
    }
    
    return [UIImage imageNamed:launchImageName];
}

#pragma mark - Private
/**
 @author daqiang
 
 @brief 获取字符串对应的颜色索引
 
 @param string 字符串
 
 @return 颜色序号
 */
+ (NSUInteger)colorIndexOfString_DQExt:(NSString *)string
                  fromColorTotal:(NSUInteger)total
{
    NSInteger length = total;
    if (nil == string || 0 == string.length) return 0;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    const char *bytes = data.bytes;
    int r = 0;
    for (int i = 0; i < [data length]; i++)
    {
        r = r + (int)(bytes[i] & 0xff);
    }
    NSInteger index = r % length;
    
    return index;
}

/**
 @author daqiang
 
 @brief 获取需要作为水印添加的字符串
 
 @param string 原字符串
 
 @return 水印字符串
 */
+ (NSString *)watermarkFromString_DQExt:(NSString *)string
{
    if (string.length > 2)
    {
        if ([self includedInAlphabet_DQExt:string])
        {
            return [string substringToIndex:2];
        }
        else
        {
            return [string substringFromIndex:string.length - 2];
        }
    }
    else
    {
        return string;
    }
}

/**
 @author daqiang
 
 @brief 判断字符串是否为纯字母
 
 @param string 字符串
 
 @return BOOL
 */
+ (BOOL)includedInAlphabet_DQExt:(NSString *)string
{
    [string enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        
    }];
    for (int i = 0; i < string.length; i++)
    {
        int s = [string characterAtIndex:i];
        if (s > 0x4e00 && s < 0x9fff) return NO;
    }
    
    return YES;
}

@end
