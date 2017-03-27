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

@implementation AppUtil

- (NSMutableArray *)loadDataWithType:(AppItemsType)type{
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    NSMutableDictionary *appDict = [sandBoxUtil loadDataWithFileName:FILE_NAME];
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
            DLog(@"请求报文成功，开始进行处理...");
            NSMutableArray *mineData = [[NSMutableArray alloc] init];
            NSMutableArray *otherData = [[NSMutableArray alloc] init];
            NSMutableArray *allData = [[NSMutableArray alloc] init];
            
            NSMutableArray *appData = [[responseDic objectForKey:@"businessData"] objectForKey:@"appList"];
            for(NSDictionary *dict in appData){
                BOOL flag = [[dict objectForKey:@"isuserapp"] boolValue];
                if(flag){  // 值为TRUE是我的应用
                    [mineData addObject:dict];
                }
                if(!flag){  // 值为FALSE是其他应用
                    [otherData addObject:dict];
                }
                [allData addObject:dict];
            }
            
            // 对我的应用进行排序
            [self sortWithArray:mineData key:@"userappsort" ascending:YES];
            
            // 最终数据（写入SandBox的数据）
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
            
            [self writeNewAppData:dataDict];
            
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

// 写入应用数据到本地SandBox中
- (BOOL)writeNewAppData:(NSDictionary *)appData{
    
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    
    return [sandBoxUtil writeData:appData fileName:FILE_NAME];
}

// 私有为NSMutableArray排序方法
- (void)sortWithArray:(NSMutableArray *)array key:(NSString *)key ascending:(BOOL)ascending{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
