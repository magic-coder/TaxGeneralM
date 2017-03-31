//
//  AppSubUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/30.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AppSubUtil.h"
#import "AppSubModel.h"

@implementation AppSubUtil

+ (NSMutableArray *)getAppSubData{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for(int i=1;i<6;i++){
        AppSubModel *model = [[AppSubModel alloc] init];
        model.no = [NSString stringWithFormat:@"21%d", i];
        model.title = [NSString stringWithFormat:@"第二级菜单名称_%d", i];
        model.webImg = [NSString stringWithFormat:@"image_%d", i];
        model.localImg = [NSString stringWithFormat:@"appSub_0%d", i];
        model.url = @"http://www.qq.com";
        [mutableArray addObject:model];
    }
    
    return mutableArray;
}

@end
