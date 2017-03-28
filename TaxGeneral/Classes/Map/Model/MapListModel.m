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

+ (MapListModel *)createWithParentCode:(NSString *)parentCode nodeCode:(NSString *)nodeCode level:(NSInteger)level name:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude isExpand:(BOOL)isExpand{
    
    MapListModel *model = [[MapListModel alloc] init];
    model.parentCode = parentCode;
    model.nodeCode = nodeCode;
    model.level = level;
    model.name = name;
    model.latitude = latitude;
    model.longitude = longitude;
    model.isExpand = isExpand;
    
    return model;
}

+ (MapListModel *)createWithDict:(NSDictionary *)dict{
    MapListModel *model = [[MapListModel alloc] init];
    model.parentCode = [dict objectForKey:@"AREAFATHERID"];
    model.nodeCode = [dict objectForKey:@"AREAID"];
    model.level = [[dict objectForKey:@"LEVELS"] integerValue]-1;
    model.name = [dict objectForKey:@"AREANAME"];
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
