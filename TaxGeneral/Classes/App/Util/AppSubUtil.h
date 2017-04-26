//
//  AppSubUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/3/30.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSubUtil : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *)loadSubDataWithPno:(NSString *)pno level:(NSString *)level;

@end
