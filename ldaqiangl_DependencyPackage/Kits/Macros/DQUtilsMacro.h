//
//  DQUtilsMacro.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#ifndef DQUtilsMacro_h
#define DQUtilsMacro_h

/** 通知中心 */
#define DQNotificationCenter [NSNotificationCenter defaultCenter]

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


#endif /* DQUtilsMacro_h */
