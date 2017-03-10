//
//  DQConversionMacro.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#ifndef DQConversionMacro_h
#define DQConversionMacro_h

/** 由角度获取弧度 */
#define DQDegreesToRadian(degrees) (M_PI * (degrees) / 180.0)

/** 由弧度获取角度 */
#define DQRadianToDegrees(radian) (radian * 180.0) / (M_PI)


#endif /* DQConversionMacro_h */
