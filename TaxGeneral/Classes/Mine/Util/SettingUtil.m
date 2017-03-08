//
//  SettingUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/9.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "SettingUtil.h"

#define FILE_NAME @"settingData.plist"

@implementation SettingUtil

- (void)initSettingData{
    NSMutableDictionary *settingDict = [[BaseSandBoxUtil alloc] loadDataWithFileName:FILE_NAME];
    
    // 初始化配置信息，包括指纹解锁、声音、震动
    if(settingDict == nil){
        NSNumber *open = [NSNumber numberWithBool:YES];
        NSNumber *close = [NSNumber numberWithBool:NO];
        // 初始化默认值的设置数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:close, @"touchID", open, @"voice", open, @"shake", nil];
        [[BaseSandBoxUtil alloc] writeData:dict fileName:FILE_NAME];
    }
}

- (NSMutableDictionary *)loadSettingData{
    return [[BaseSandBoxUtil alloc] loadDataWithFileName:FILE_NAME];
}

-(BOOL)writeSettingData:(NSMutableDictionary *)data{
    return [[BaseSandBoxUtil alloc] writeData:data fileName:FILE_NAME];
}

-(void)removeSettingData{
    [[BaseSandBoxUtil alloc] removeFileName:FILE_NAME];
}

@end
