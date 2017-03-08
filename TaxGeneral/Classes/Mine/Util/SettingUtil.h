//
//  SettingUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/9.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingUtil : NSObject

- (void)initSettingData;// 初始化setting设置信息

- (NSMutableDictionary *)loadSettingData;// 读取已有数据

- (BOOL)writeSettingData:(NSMutableDictionary *)data;

- (void)removeSettingData;

@end
