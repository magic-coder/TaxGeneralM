/************************************************************
 Class    : YZCookieSyncManager.m
 Describe : Cookie同步管理类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-04-01
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZCookieSyncManager.h"

@implementation YZCookieSyncManager

+ (instancetype)sharedWKCookieSyncManager {
    static YZCookieSyncManager *sharedYZCookieSyncManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedYZCookieSyncManagerInstance = [[self alloc] init];
    });
    return sharedYZCookieSyncManagerInstance;
}

- (WKProcessPool *)processPool {
    if (!_processPool) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            _processPool = [[WKProcessPool alloc] init];
        });
    }
    
    return _processPool;
}

@end
