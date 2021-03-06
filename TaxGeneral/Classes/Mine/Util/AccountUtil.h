/************************************************************
 Class    : AccountUtil.h
 Describe : 账户管理工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface AccountUtil : NSObject

+ (instancetype)shareInstance;

//- (void)accountLogout;// 用户注销方法

- (void)accountLogout:(void (^)())success failed:(void (^)(NSString *error))failed;  // 使用接口注销方法

@end
