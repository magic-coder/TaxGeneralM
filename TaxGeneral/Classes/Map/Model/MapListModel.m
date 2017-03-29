/************************************************************
 Class    : MapListModel.m
 Describe : 地图机构模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MapListModel.h"

@implementation MapListModel

+ (MapListModel *)createWithDict:(NSDictionary *)dict{
    MapListModel *model = [[MapListModel alloc] init];
    model.parentCode = [dict objectForKey:@"AREAFATHERID"];
    model.nodeCode = [dict objectForKey:@"AREAID"];
    model.level = [[dict objectForKey:@"LEVELS"] integerValue]-1;
    model.name = [dict objectForKey:@"AREANAME"];
    model.deptName = [dict objectForKey:@"TAXDEPTNAME"];
    model.address = [dict objectForKey:@"ADDRESS"];
    model.tel = [dict objectForKey:@"PHONE"];
    model.latitude = [dict objectForKey:@"LAT"];
    model.longitude = [dict objectForKey:@"WARP"];
    if(model.level == 0){
        model.isExpand = YES;
    }else{
        model.isExpand = NO;
    }
    
    return model;
}

@end
