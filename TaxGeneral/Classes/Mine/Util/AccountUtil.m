//
//  AccountUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/9.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AccountUtil.h"
#import "SettingUtil.h"

@implementation AccountUtil

-(void)accountLogout:(void (^)())success failed:(void (^)(NSString *))failed{
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
            // 删除msg详细列表息
            [[BaseSandBoxUtil alloc] removeFileName:@"msgDetailData.plist"];
            // 删除设置信息、并重置设置
            [[SettingUtil alloc] removeSettingData];
            [[SettingUtil alloc] initSettingData];
            success();
        }else{
            failed(@"注销失败！");
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

-(void)accountLogout{
    
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
            // 删除设置信息、并重置设置
            [[SettingUtil alloc] removeSettingData];
            [[SettingUtil alloc] initSettingData];
        }
    } failure:^(NSString *error) {
        DLog(@"failed");
    }];
}

@end
