/************************************************************
 Class    : MapListUtil.m
 Describe : 地图机构工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MapListUtil.h"
#import "MapListModel.h"

#define FILE_NAME @"mapData.plist"

@implementation MapListUtil

+ (instancetype)shareInstance{
    static MapListUtil *mapListUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapListUtil = [[MapListUtil alloc] init];
    });
    return mapListUtil;
}

- (NSMutableArray *)getMapData{
    NSDictionary *dict = [[BaseSandBoxUtil shareInstance] loadDataWithFileName:FILE_NAME];
    return [self handleDataDict:dict];
}

-(void)loadMapDataBlock:(void (^)(NSMutableArray *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSString *url = @"public/taxmap/init";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:nil success:^(NSDictionary *responseDic) {
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        DLog(@"Yan -> 请求处理结果状态值 : statusCode = %@", statusCode);
        if([statusCode isEqualToString:@"00"]){
            [[BaseSandBoxUtil shareInstance] writeData:responseDic fileName:FILE_NAME];
            dataBlock([self handleDataDict:responseDic]);
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

#pragma mark - 对返回的数据进行处理
- (NSMutableArray *)handleDataDict:(NSDictionary *)dict{
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    
    NSDictionary *businessData = [dict objectForKey:@"businessData"];
    NSArray *taxMapArray = [businessData objectForKey:@"taxmaplist"];
    for(NSDictionary *taxMapDict in taxMapArray){
        MapListModel *model = [ MapListModel createWithDict:taxMapDict];
        [resArray addObject:model];
    }
    
    return resArray;
}
     
@end
