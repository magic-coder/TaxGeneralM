/************************************************************
 Class    : Variable.h
 Describe : 定义全局变量，该类为单例模式
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-01
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface Variable : NSObject

@property (nonatomic, strong) NSString *appName;            // 应用名称
@property (nonatomic, strong) NSString *appVersion;         // 应用版本号

@property (nonatomic, assign) NSInteger lastSelectedIds;    // TabBar记录最近一次选中的视图
@property (nonatomic, assign) BOOL msgRefresh;              // 标记视图是否刷新
@property (nonatomic, assign) int unReadCount;              // 未读消息条数
@property (nonatomic, strong) NSString *runtimeLog;         // 运行日志
@property (nonatomic, strong) NSString *crashLog;           // 崩溃日志
@property (nonatomic, assign) float brightness;             // 系统屏幕亮度
@property (nonatomic, assign) BOOL isUpdates;               // 是开启检测更新

/**
 * @breif 实现声明单例方法 GCD
 */
+(Variable *)shareInstance;

@end
