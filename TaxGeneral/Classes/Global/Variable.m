/************************************************************
 Class    : Variable.m
 Describe : 定义全局变量，该类为单例模式
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-01
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "Variable.h"

@implementation Variable

+(Variable *)shareInstance{
    static Variable *variable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        variable = [[Variable alloc] init];
    });
    return variable;
}

- (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

- (NSString *)appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用版本号码   int类型
    // NSString *appVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    // 当前应用软件版本  比如：1.0.1
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)buildVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用版本号码   int类型
    // NSString *appVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    // 当前应用软件版本  比如：1.0.1
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}

@end
