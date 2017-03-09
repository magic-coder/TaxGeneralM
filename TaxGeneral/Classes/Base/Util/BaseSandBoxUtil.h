/************************************************************
 Class    : BaseSandBoxUtil.h
 Describe : 基本的沙盒SandBox操作(读、写、删)
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-12
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseSandBoxUtil : NSObject

- (NSMutableDictionary *)loadDataWithFileName:(NSString *)fileName;    // 读取文件

- (BOOL)writeData:(NSDictionary *)data fileName:(NSString *)fileName;    // 写入文件

- (void)removeFileName:(NSString *)fileName;    // 删除文件

@end
