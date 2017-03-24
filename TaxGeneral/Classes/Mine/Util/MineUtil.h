//
//  MineUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableModel.h"

@interface MineUtil : NSObject

+(NSMutableArray *) getMineItems;       // 获取我的列表

+(NSMutableArray *) getAccountItems;    // 获取账户管理列表

+(NSMutableArray *) getSafeItems;       // 获取安全中心列表

+(NSMutableArray *) getGestureItems;    // 获取手势密码列表

+(NSMutableArray *) getScheduleItems;   // 获取我的日程列表

+(NSMutableArray *) getServiceItems;    // 获取我的服务列表

+(NSMutableArray *) getSettingItems;    // 获取设置信息列表

@end
