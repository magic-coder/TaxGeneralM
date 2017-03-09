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

-(void)accountLogout{
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

@end
