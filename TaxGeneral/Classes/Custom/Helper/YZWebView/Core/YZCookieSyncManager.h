/************************************************************
 Class    : YZCookieSyncManager.h
 Describe : Cookie同步管理类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-04-01
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface YZCookieSyncManager : NSObject


@property (nonatomic, strong) WKProcessPool *processPool;

+ (instancetype)sharedWKCookieSyncManager;

@end
