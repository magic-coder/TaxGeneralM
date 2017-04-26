/************************************************************
 Class    : MineUtil.h
 Describe : 我的界面工具类，加载各子模块内容
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>
#import "BaseTableModel.h"

@interface MineUtil : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *) getMineItems;       // 获取我的列表

- (NSMutableArray *) getAccountItems;    // 获取账户管理列表

- (NSMutableArray *) getSafeItems;       // 获取安全中心列表

- (NSMutableArray *) getGestureItems;    // 获取手势密码列表

- (NSMutableArray *) getScheduleItems;   // 获取我的日程列表

- (NSMutableArray *) getServiceItems;    // 获取我的服务列表

- (NSMutableArray *) getSettingItems;    // 获取设置信息列表

@end
