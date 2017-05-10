/************************************************************
 Class    : AccountUtil.m
 Describe : 账户管理工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AccountUtil.h"
#import "SettingUtil.h"

@implementation AccountUtil

+ (instancetype)shareInstance{
    static AccountUtil *accountUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountUtil = [[AccountUtil alloc] init];
    });
    return accountUtil;
}

/*
- (void)accountLogout{
    // 删除用户登录信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
    // 删除是否为开发者信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_TEST];
    // 删除用户手势密码信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GESTURES_PASSWORD];
    // 删除app列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"appData.plist"];
    // 删除msg列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"msgData.plist"];
    // 删除设置信息、并重置设置
    [[SettingUtil shareInstance] removeSettingData];
    [[SettingUtil shareInstance] initSettingData];
    // 清除应用提醒角标
    [[BaseHandleUtil shareInstance] setBadge:0];
    
    // 清空Cookie
    NSHTTPCookieStorage * loginCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in [loginCookie cookies]){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // 删除沙盒自动生成的Cookies.binarycookies文件
    NSString * path = NSHomeDirectory();
    NSString * filePath = [path stringByAppendingPathComponent:@"/Library/Cookies/Cookies.binarycookies"];
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:filePath error:nil];
}
*/

- (void)accountLogout:(void (^)())success failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"app" forKey:@"loginType"];
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    [dict setObject:[userDict objectForKey:@"userCode"] forKey:@"userCode"];
    
    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"account/loginout";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            
            [self dropUserInfo];// 删除用户信息
            
            success();
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
    
}

// 删除用户信息
- (void)dropUserInfo{
    // 删除用户登录信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
    // 删除是否为开发者信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_TEST];
    // 删除用户手势密码信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GESTURES_PASSWORD];
    // 删除绑定注册推送设备信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_PUSH];
    // 删除税闻列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"newsData.plist"];
    // 删除app列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"appData.plist"];
    // 删除msg列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"msgData.plist"];
    // 将用户TouchID设置信息删除
    NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    [settingDict setValue:[NSNumber numberWithBool:NO] forKey:@"touchID"];
    [[SettingUtil shareInstance] writeSettingData:settingDict];
    //[[SettingUtil shareInstance] removeSettingData];
    //[[SettingUtil shareInstance] initSettingData];
    
    // 清理缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 清除应用提醒角标
    [[BaseHandleUtil shareInstance] setBadge:0];
    
    // 清空Cookie
    NSHTTPCookieStorage * loginCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in [loginCookie cookies]){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // 删除沙盒自动生成的Cookies.binarycookies文件
    NSString * path = NSHomeDirectory();
    NSString * filePath = [path stringByAppendingPathComponent:@"/Library/Cookies/Cookies.binarycookies"];
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:filePath error:nil];
}

@end
