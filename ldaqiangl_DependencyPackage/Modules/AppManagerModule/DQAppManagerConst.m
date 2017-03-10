//
//  DQAppManagerConst.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/9.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQAppManagerConst.h"


NSString * const KEY_URL_APPSTORE_LOOKUP = @"https://itunes.apple.com/lookup";
NSString * const KEY_URL_APPSTORE_SEARCH = @"https://itunes.apple.com/search";
NSString * const KEY_URL_APPSTORE_REVIEW = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";

NSString * const KEY_URL_FIR_CHECKVERSION = @"https://api.fir.im/apps/latest";
NSString * const KEY_URL_FIR_DOWNLOADTOKEN = @"https://api.fir.im/apps/%@/download_token";
NSString * const KEY_URL_FIR_DOWNLOADPLISTID = @"https://download.fir.im/apps/%@/install";
NSString * const KEY_URL_FIR_DOWNLOADURL = @"itms-services://?action=download-manifest&url=https://fir.im/plists/%@";
