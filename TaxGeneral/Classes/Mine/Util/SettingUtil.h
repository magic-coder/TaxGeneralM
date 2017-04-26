/************************************************************
 Class    : SettingUtil.h
 Describe : 设置界面工具类，处理用户设置数据
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface SettingUtil : NSObject

+ (instancetype)shareInstance;

- (void)initSettingData;// 初始化setting设置信息

- (NSMutableDictionary *)loadSettingData;// 读取已有数据

- (BOOL)writeSettingData:(NSMutableDictionary *)data;

- (void)removeSettingData;

@end
