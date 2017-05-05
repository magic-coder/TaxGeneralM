/************************************************************
 Class    : SettingUtil.m
 Describe : 设置界面工具类，处理用户设置数据
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "SettingUtil.h"

#define FILE_NAME @"settingData.plist"

@implementation SettingUtil

+ (instancetype)shareInstance{
    static SettingUtil *settingUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingUtil = [[SettingUtil alloc] init];
    });
    return settingUtil;
}

- (void)initSettingData{
    NSMutableDictionary *settingDict = [[BaseSandBoxUtil shareInstance] loadDataWithFileName:FILE_NAME];
    
    // 初始化配置信息，包括指纹解锁、声音、震动、是否检测更新、是否开启天气预报
    if(settingDict == nil){
        NSNumber *open = [NSNumber numberWithBool:YES];
        NSNumber *close = [NSNumber numberWithBool:NO];
        // 初始化默认值的设置数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:close, @"touchID", open, @"voice", open, @"shake", close, @"forecast", open, @"update", nil];
        [[BaseSandBoxUtil shareInstance] writeData:dict fileName:FILE_NAME];
    }
}

- (NSMutableDictionary *)loadSettingData{
    return [[BaseSandBoxUtil shareInstance] loadDataWithFileName:FILE_NAME];
}

-(BOOL)writeSettingData:(NSMutableDictionary *)data{
    return [[BaseSandBoxUtil shareInstance] writeData:data fileName:FILE_NAME];
}

-(void)removeSettingData{
    [[BaseSandBoxUtil shareInstance] removeFileName:FILE_NAME];
}

@end
