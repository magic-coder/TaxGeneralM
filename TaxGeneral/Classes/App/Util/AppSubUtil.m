//
//  AppSubUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/30.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AppSubUtil.h"
#import "AppSubModel.h"

#define SUB_FILE_NAME @"appSubData.plist"

@implementation AppSubUtil

- (NSMutableArray *)loadSubDataWithPno:(NSString *)pno level:(NSString *)level{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    NSMutableDictionary *subAppDict = [sandBoxUtil loadDataWithFileName:SUB_FILE_NAME];
    NSArray *subAppData = [subAppDict objectForKey:@"subAppData"];
    for(NSDictionary *dict in subAppData){
        NSString *pappno = [dict objectForKey:@"pappno"];
        NSString *applevel = [dict objectForKey:@"applevel"];
        if([pno isEqualToString:pappno] && [level isEqualToString:applevel]){
            AppSubModel *model = [AppSubModel createWithDict:dict];
            [mutableArray addObject:model];
        }
    }
    
    return mutableArray;
}

@end
