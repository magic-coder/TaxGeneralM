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

+ (void)accountLogout{
    // 删除用户登录信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
    // 删除用户手势密码信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturespassword"];
    // 删除app列表信息
    [[BaseSandBoxUtil alloc] removeFileName:@"appData.plist"];
    // 删除msg列表信息
    [[BaseSandBoxUtil alloc] removeFileName:@"msgData.plist"];
    // 删除设置信息、并重置设置
    [[SettingUtil alloc] removeSettingData];
    [[SettingUtil alloc] initSettingData];
    
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

/*
+ (void)accountLogout:(void (^)())success failed:(void (^)(NSString *))failed{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"app" forKey:@"loginType"];
    
    NSString *jsonString = [BaseDataUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"account/loginout";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            // 删除用户登录信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
            // 删除用户手势密码信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturespassword"];
            // 删除app列表信息
            [[BaseSandBoxUtil alloc] removeFileName:@"appData.plist"];
            // 删除msg列表信息
            [[BaseSandBoxUtil alloc] removeFileName:@"msgData.plist"];
            // 删除设置信息、并重置设置
            [[SettingUtil alloc] removeSettingData];
            [[SettingUtil alloc] initSettingData];
            
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
            
            success();
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}
*/
@end
