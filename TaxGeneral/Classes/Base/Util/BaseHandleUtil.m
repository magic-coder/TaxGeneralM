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

@end
