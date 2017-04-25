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

+ (NSString *)dataToJsonString:(id)object;      // 数据转换jsonString

+ (void)setBadge:(int)badge;                    // 设置应用、消息角标

+ (UIViewController *)getCurrentVC;             // 获取当前展示的视图

+ (int)getRandomNumber:(int)from to:(int)to;    // 获取一个随机整数，范围在[from,to），包括from，包括to

/**
 *  将App事件添加到系统日历提醒事项，实现闹铃提醒的功能
 *
 *  @param title      事件标题
 *  @param location   事件位置
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param allDay     是否全天
 *  @param alarmArray 闹钟集合
 *  @param block      回调方法
 */
+ (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate notes:(NSString *)notes allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray block:(void(^)(NSString *str))block;

@end
