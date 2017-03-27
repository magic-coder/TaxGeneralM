/************************************************************
 Class    : BaseDataUtil.h
 Describe : 基本的数据转换工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseDataUtil : NSObject

+(NSString *)dataToJsonString:(id)object;// 数据转换jsonString

@end
