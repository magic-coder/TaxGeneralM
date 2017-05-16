/************************************************************
 Class    : AppSubUtil.m
 Describe : 应用程序子界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-03-30
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppSubUtil.h"
#import "AppSubModel.h"

#define SUB_FILE_NAME @"appSubData.plist"
#define SEARCH_FILE_NAME @"appSearchData.plist"

@implementation AppSubUtil

+ (instancetype)shareInstance{
    static AppSubUtil *appSubUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appSubUtil = [[AppSubUtil alloc] init];
    });
    return appSubUtil;
}

- (NSMutableArray *)loadSubDataWithPno:(NSString *)pno level:(NSString *)level{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subAppDict = [[BaseSandBoxUtil shareInstance] loadDataWithFileName:SUB_FILE_NAME];
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

// 搜索应用数据
- (NSMutableArray *)loadSearchData{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *searchAppDict = [[BaseSandBoxUtil shareInstance] loadDataWithFileName:SEARCH_FILE_NAME];
    NSArray *searchAppData = [searchAppDict objectForKey:@"searchAppData"];
    for(NSDictionary *dict in searchAppData){
        AppSubModel *model = [AppSubModel createWithDict:dict];
        [mutableArray addObject:model];
    }
    
    return mutableArray;
}

@end
