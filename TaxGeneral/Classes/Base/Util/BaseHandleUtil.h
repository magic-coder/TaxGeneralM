/************************************************************
 Class    : BaseHandleUtil.h
 Describe : 基本的应用处理类（自定义通用功能）
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-04-12
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseHandleUtil : NSObject

+ (NSString *)dataToJsonString:(id)object;  // 数据转换jsonString

+ (void)setBadge:(int)badge;          // 设置应用、消息角标

@end
