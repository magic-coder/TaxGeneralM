/************************************************************
 Class    : LoginUtil.h
 Describe : 用户登录方法工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-21
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

+ (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)())success failed:(void (^)(NSString *error))failed;

+ (void)loginWithTokenSuccess:(void (^)())success failed:(void (^)(NSString *error))failed;

@end
