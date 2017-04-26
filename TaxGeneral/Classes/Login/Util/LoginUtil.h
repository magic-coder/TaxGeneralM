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

+ (instancetype)shareInstance;

// 通过app进行登录
- (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)())success failed:(void (^)(NSString *error))failed;

// 通过token进行登录
- (void)loginWithTokenSuccess:(void (^)())success failed:(void (^)(NSString *error))failed;

@end
