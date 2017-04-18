/************************************************************
 Class    : LoginUtil.m
 Describe : 用户登录方法工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-21
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "LoginUtil.h"
#import "DeviceInfoModel.h"

@implementation LoginUtil

+ (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)())success failed:(void (^)(NSString *))failed{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_INFO];
    DeviceInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [dict setObject:@"app" forKey:@"loginType"];
    [dict setObject:model.deviceModel forKey:@"phonemodel"];
    [dict setObject:model.systemVersion forKey:@"osversion"];
    [dict setObject:@"4" forKey:@"phonetype"];
    [dict setObject:model.deviceIdentifier forKey:@"deviceid"];
    
    NSString *jsonString = [BaseHandleUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"account/login";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            NSDictionary *businessData = [responseDic objectForKey:@"businessData"];
            [dict setObject:[businessData objectForKey:@"userName"] forKey:@"userName"];
            [dict setObject:[businessData objectForKey:@"orgCode"] forKey:@"orgCode"];
            [dict setObject:[businessData objectForKey:@"orgName"] forKey:@"orgName"];
            [dict setObject:[businessData objectForKey:@"token"] forKey:@"token"];
            // 获取系统当前时间(登录时间)
            NSDate *sendDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *loginDate = [dateFormatter stringFromDate:sendDate];
            [dict setObject:loginDate forKey:@"loginDate"];
            
            // 登录成功将信息保存到用户单例模式中
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:LOGIN_SUCCESS];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
            
            // 绑定推送设备
            NSDictionary *pushDict = [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_INFO];
            if(nil != pushDict){
                NSString *jsonString = [BaseHandleUtil dataToJsonString:pushDict];
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
                NSString *url = @"push/registerPush";
                [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                    DLog(@"Yan -> 绑定推送设备信息成功：responseDic = %@", responseDic);
                } failure:^(NSString *error) {
                    DLog(@"Yan -> 绑定推送设备信息失败：error = %@", error);
                }];
            }
            
            success();
            
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

// token 登录请求三次，若三次都失败则失败
+ (void)loginWithTokenSuccess:(void (^)())success failed:(void (^)(NSString *))failed{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_INFO];
    DeviceInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"appToken" forKey:@"loginType"];
    [dict setObject:[userDict objectForKey:@"userCode"] forKey:@"userCode"];
    [dict setObject:model.deviceModel forKey:@"phonemodel"];
    [dict setObject:model.systemVersion forKey:@"osversion"];
    [dict setObject:@"4" forKey:@"phonetype"];
    [dict setObject:model.deviceIdentifier forKey:@"deviceid"];
    [dict setObject:[userDict objectForKey:@"token"] forKey:@"token"];
    
    NSString *jsonString = [BaseHandleUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"account/login";
    // 第一次执行
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            [self handleTokenLogin:responseDic successDict:dict];
            success();
        }else{
            // 第二次执行
            [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                NSString *statusCode = [responseDic objectForKey:@"statusCode"];
                if([statusCode isEqualToString:@"00"]){
                    [self handleTokenLogin:responseDic successDict:dict];
                    success();
                }else{
                    // 第三次执行
                    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
                        if([statusCode isEqualToString:@"00"]){
                            [self handleTokenLogin:responseDic successDict:dict];
                            success();
                        }else if([statusCode isEqualToString:@"510"]){
                            failed(@"510");
                        }else{
                            failed([responseDic objectForKey:@"msg"]);
                        }
                    } failure:^(NSString *error) {
                        failed(error);
                    }];
                }
            } failure:^(NSString *error) {
                // 第三次执行
                [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                    NSString *statusCode = [responseDic objectForKey:@"statusCode"];
                    if([statusCode isEqualToString:@"00"]){
                        [self handleTokenLogin:responseDic successDict:dict];
                        success();
                    }else if([statusCode isEqualToString:@"510"]){
                        failed(@"510");
                    }else{
                        failed([responseDic objectForKey:@"msg"]);
                    }
                } failure:^(NSString *error) {
                    failed(error);
                }];
            }];
        }
    } failure:^(NSString *error) {
        // 第二次执行
        [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
            NSString *statusCode = [responseDic objectForKey:@"statusCode"];
            if([statusCode isEqualToString:@"00"]){
                [self handleTokenLogin:responseDic successDict:dict];
                success();
            }else{
                // 第三次执行
                [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                    NSString *statusCode = [responseDic objectForKey:@"statusCode"];
                    if([statusCode isEqualToString:@"00"]){
                        [self handleTokenLogin:responseDic successDict:dict];
                        success();
                    }else if([statusCode isEqualToString:@"510"]){
                        failed(@"510");
                    }else{
                        failed([responseDic objectForKey:@"msg"]);
                    }
                } failure:^(NSString *error) {
                    failed(error);
                }];
            }
        } failure:^(NSString *error) {
            // 第三次执行
            [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                NSString *statusCode = [responseDic objectForKey:@"statusCode"];
                if([statusCode isEqualToString:@"00"]){
                    [self handleTokenLogin:responseDic successDict:dict];
                    success();
                }else if([statusCode isEqualToString:@"510"]){
                    failed(@"510");
                }else{
                    failed([responseDic objectForKey:@"msg"]);
                }
            } failure:^(NSString *error) {
                failed(error);
            }];
        }];
    }];
}

+ (void)handleTokenLogin:(NSDictionary *)responseDict successDict:(NSMutableDictionary *)dict{
    NSDictionary *businessData = [responseDict objectForKey:@"businessData"];
    [dict setObject:[businessData objectForKey:@"userName"] forKey:@"userName"];
    [dict setObject:[businessData objectForKey:@"orgCode"] forKey:@"orgCode"];
    [dict setObject:[businessData objectForKey:@"orgName"] forKey:@"orgName"];
    // 获取系统当前时间(登录时间)
    NSDate *sendDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *loginDate = [dateFormatter stringFromDate:sendDate];
    [dict setObject:loginDate forKey:@"loginDate"];
    
    // 登录成功将信息保存到用户单例模式中
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:LOGIN_SUCCESS];
    [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
}

@end
