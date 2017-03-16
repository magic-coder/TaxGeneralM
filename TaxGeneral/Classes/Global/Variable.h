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

@property (nonatomic, assign) NSInteger lastSelectedIds;// TabBar记录最近一次选中的视图
@property (nonatomic, assign) BOOL msgRefresh;  // 标记视图是否刷新
/**
 * @breif 实现声明单例方法 GCD
 */
+(Variable *)shareInstance;

@end
