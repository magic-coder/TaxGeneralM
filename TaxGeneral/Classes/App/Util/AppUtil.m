/************************************************************
 Class    : AppUtil.m
 Describe : 应用界面工具类，用于处理应用列表数据
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-29
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppUtil.h"
#import "BaseCollectionModel.h"

#define FILE_NAME @"appData.plist"
#define SUB_FILE_NAME @"appSubData.plist"
#define SEARCH_FILE_NAME @"appSearchData.plist"

@implementation AppUtil

+ (instancetype)shareInstance{
    static AppUtil *appUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appUtil = [[AppUtil alloc] init];
    });
    return appUtil;
}

- (NSMutableArray *)loadDataWithType:(AppItemsType)type{
    NSMutableDictionary *appDict = [[BaseSandBoxUtil shareInstance] loadDataWithFileName:FILE_NAME];
    return [self handleData:appDict WithType:type];
}

- (void)initDataWithType:(AppItemsType)type dataBlock:(void (^)(NSMutableArray *))dataBlock failed:(void (^)(NSString *))failed{
    
    /*
     // 此处目前读取plist资源文件，后期从数据库中获取
     NSString *appDataPath = [[NSBundle mainBundle] pathForResource:@"appsData" ofType:@"plist"];
     NSMutableDictionary *appDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDataPath];
     NSMutableArray *allData = [appDataDic objectForKey:@"allData"];
     NSMutableArray *mineData = [appDataDic objectForKey:@"mineData"];
     NSMutableArray *otherData = [appDataDic objectForKey:@"otherData"];
     
     // 对我的应用进行排序
     [self sortWithArray:mineData key:@"userappsort" ascending:YES];
     
     // 最终数据（写入SandBox的数据）
     NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
     
     BOOL isSuccess = [self writeNewAppData:dataDict];
     if(isSuccess){
     DLog(@"初始化应用列表信息，并写入成功！");
     }else{
     DLog(@"初始化应用列表信息失败...");
     }
     */
    
    NSString *url = @"app/index";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:nil success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        
        if([statusCode isEqualToString:@"00"]){
            
            int serverIconVer = [[[[responseDic objectForKey:@"businessData"] objectForKey:@"iconVersion"] objectForKey:@"iconVersionNo"] intValue];// 服务端图标版本号
            int nativeIconVer = [[[NSUserDefaults standardUserDefaults] objectForKey:ICON_VERSION] intValue];// 本地图标版本号
            if(serverIconVer != nativeIconVer){
                // 重写本地图标版本号、清图片缓存
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", serverIconVer] forKey:ICON_VERSION];
                [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
                // 清理缓存
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                [[SDImageCache sharedImageCache] clearMemory];
            }
            
            DLog(@"请求报文成功，开始进行处理...");
            NSMutableArray *mineData = [[NSMutableArray alloc] init];
            NSMutableArray *otherData = [[NSMutableArray alloc] init];
            NSMutableArray *allData = [[NSMutableArray alloc] init];
            // 搜索的数据(全部数据各level的)
            NSMutableArray *searchData = [[NSMutableArray alloc] init];
            
            // 子类数据
            NSMutableArray *subData = [[NSMutableArray alloc] init];
            
            NSMutableArray *appData = [[responseDic objectForKey:@"businessData"] objectForKey:@"appList"];
            for(NSDictionary *dict in appData){
                int type = [[dict objectForKey:@"apptype"] intValue];  // 1:我的应用 2:其他应用 3:新增应用
                //BOOL flag = [[dict objectForKey:@"isuserapp"] boolValue];
                NSInteger level = [[dict objectForKey:@"applevel"] integerValue];
                if(level == 0){ // 只获取第一个级别的 level = 0 的数据
                    if(type == 1){  // 值为1是我的应用
                        [mineData addObject:dict];
                    }
                    if(type == 2 || type == 3){  // 值为2、3是其他应用
                        [otherData addObject:dict];
                    }
                    [allData addObject:dict];
                }else{
                    [subData addObject:dict];
                }
                [searchData addObject:dict];
            }
            
            // 对我的应用进行排序
            [self sortWithArray:mineData key:@"userappsort" ascending:YES];
            
            // 对其他应用进行排序
            [self sortWithArray:otherData key:@"userappsort" ascending:YES];
            
            // 对子应用进行排序
            [self sortWithArray:subData key:@"appsort" ascending:YES];
            
            // 最终数据（写入SandBox的数据）[第一级主应用]
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
            [self writeNewAppData:dataDict];
            
            // 最终数据（写入SandBox的数据）[子类应用]
            NSMutableDictionary *subDataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:subData, @"subAppData", nil];
            [self writeAppSubData:subDataDict];
            
            // 最终数据（写入SandBox的数据）[搜索应用]
            NSMutableDictionary *searchDataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:searchData, @"searchAppData", nil];
            [self writeAppSearchData:searchDataDict];
            
            dataBlock([self handleData:dataDict WithType:type]);
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

- (NSMutableArray *)handleData:(NSDictionary *)dict WithType:(AppItemsType)type{
    if(dict){
        NSMutableArray *appItems = [[NSMutableArray alloc] init];
        NSArray *mineData = [dict objectForKey:@"mineData"];
        NSArray *otherData = [dict objectForKey:@"otherData"];
        NSArray *allData = [dict objectForKey:@"allData"];
        
        NSMutableArray *mineItems = [[NSMutableArray alloc] init];
        NSMutableArray *otherItems = [[NSMutableArray alloc] init];
        NSMutableArray *allItems = [[NSMutableArray alloc] init];
        
        for(NSDictionary *mineDict in mineData){
            BaseCollectionModelItem *mineItem = [BaseCollectionModelItem createWithDict:mineDict];
            [mineItems addObject:mineItem];
        }
        for(NSDictionary *otherDict in otherData){
            BaseCollectionModelItem *otherItem = [BaseCollectionModelItem createWithDict:otherDict];
            [otherItems addObject:otherItem];
        }
        for(NSDictionary *allDict in allData){
            BaseCollectionModelItem *allItem = [BaseCollectionModelItem createWithDict:allDict];
            [allItems addObject:allItem];
        }
        
        BaseCollectionModelGroup *mineGroup = [[BaseCollectionModelGroup alloc] init];
        mineGroup.groupTitle = @"我的应用";
        mineGroup.items = mineItems;
        
        BaseCollectionModelGroup *otherGroup = [[BaseCollectionModelGroup alloc] init];
        otherGroup.groupTitle = @"其他应用";
        otherGroup.items = otherItems;
        
        BaseCollectionModelGroup *allGroup = [[BaseCollectionModelGroup alloc] init];
        allGroup.groupTitle = @"全部应用";
        allGroup.items = allItems;
        
        [appItems addObject:mineGroup];
        
        if(type == AppItemsTypeNone && otherGroup.itemsCount > 0){
            [appItems addObject:otherGroup];
        }
        if(type == AppItemsTypeEdit){
            [appItems addObject:allGroup];
        }
        
        return appItems;
    }else{
        return nil;
    }
}

// 向服务器保存自定义app排序
- (void)saveCustomData:(NSArray *)customData{
    
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    
    int appsort = 0;
    for(NSDictionary *dict in customData){
        appsort ++;
        NSString *appno = [dict objectForKey:@"appno"];
        NSString *apptype = [dict objectForKey:@"apptype"];
        
        NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:appsort], @"appsort", appno, @"appno", apptype, @"apptype", nil];
        
        [paramsArray addObject:paramDict];
    }
    
    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:paramsArray];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    
    NSString *url = @"app/saveCustomAppSort";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
    } failure:^(NSString *error) {
        RLog(@"Yan -> 同步消息失败，error=%@", error);
    }];
    
}

// 写入应用数据到本地SandBox中
- (BOOL)writeNewAppData:(NSDictionary *)appData{
    
    NSMutableArray *customData = [[NSMutableArray alloc] init];
    
    for(NSDictionary *mineDict in [appData objectForKey:@"mineData"]){
        [customData addObject:mineDict];
    }
    for(NSDictionary *otherDict in [appData objectForKey:@"otherData"]){
        [customData addObject:otherDict];
    }
    
    [self saveCustomData:customData];
    
    return [[BaseSandBoxUtil shareInstance] writeData:appData fileName:FILE_NAME];
}

// 子类信息写入应用数据到本地SandBox中
- (BOOL)writeAppSubData:(NSDictionary *)appData{
    return [[BaseSandBoxUtil shareInstance] writeData:appData fileName:SUB_FILE_NAME];
}

// 应用搜索信息写入本地SandBox中
- (BOOL)writeAppSearchData:(NSDictionary *)appData{
    return [[BaseSandBoxUtil shareInstance] writeData:appData fileName:SEARCH_FILE_NAME];
}

// 私有为NSMutableArray排序方法
- (void)sortWithArray:(NSMutableArray *)array key:(NSString *)key ascending:(BOOL)ascending{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
