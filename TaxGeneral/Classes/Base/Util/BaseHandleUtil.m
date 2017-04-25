/************************************************************
 Class    : BaseHandleUtil.m
 Describe : 基本的应用处理类（自定义通用功能）
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-04-12
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseHandleUtil.h"
#import "MainTabBarController.h"
#import <EventKit/EventKit.h>

@implementation BaseHandleUtil

+ (NSString *)dataToJsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if(jsonData){
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        DLog(@"Yan -> 转换失败 error : %@",error);
    }
    
    return jsonString;
}

+ (void)setBadge:(int)badge{
    // 设置app角标(若为0则系统会自动清除角标)
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    
    MainTabBarController *mainTabBarController = [MainTabBarController shareInstance];
    // 设置tabBar消息角标
    if(badge > 0){
        [mainTabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%d", badge];
    }else{
        [mainTabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
    }
}


#pragma mark - 获取当前展示的视图
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];//  这方法下面有详解
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        // UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

// 获取一个随机整数，范围在[from,to），包括from，包括to
+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate notes:(NSString *)notes allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray block:(void(^)(NSString *str))block{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error){
                    block(@"添加失败，请稍后重试！");
                }else if (!granted){
                    block(@"不允许使用日历,请在设置中允许此App使用日历！");
                }else{
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    event.title = [NSString stringWithFormat:@"互联网+税务：%@", title];
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    event.notes  = notes;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    block(@"已添加到系统日历中！");
                    
                }
            });
        }];
    }
}

@end