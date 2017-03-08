//
//  MapListUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MapListUtil.h"
#import "MapListModel.h"

@implementation MapListUtil

+ (NSMutableArray *)getMapData{
    MapListModel *group1 = [MapListModel createWithParentCode:@"0" nodeCode:@"1" level:0 name:@"业务类型" latitude:nil longitude:nil isExpand:YES];
    MapListModel *station11 = [MapListModel createWithParentCode:@"1" nodeCode:@"11" level:1 name:@"局机关" latitude:nil longitude:nil isExpand:NO];
    MapListModel *station12 = [MapListModel createWithParentCode:@"1" nodeCode:@"12" level:1 name:@"政务大厅（中心）" latitude:nil longitude:nil isExpand:NO];
    MapListModel *station13 = [MapListModel createWithParentCode:@"1" nodeCode:@"13" level:1 name:@"办税大厅" latitude:nil longitude:nil isExpand:NO];
    MapListModel *station14 = [MapListModel createWithParentCode:@"1" nodeCode:@"14" level:1 name:@"税务所" latitude:nil longitude:nil isExpand:NO];
    MapListModel *station15 = [MapListModel createWithParentCode:@"1" nodeCode:@"15" level:1 name:@"契税征收" latitude:nil longitude:nil isExpand:NO];
    MapListModel *institute111 = [MapListModel createWithParentCode:@"11" nodeCode:@"111" level:2 name:@"西安市地方税务局" latitude:@"34.229205" longitude:@"108.947769" isExpand:NO];
    MapListModel *institute112 = [MapListModel createWithParentCode:@"11" nodeCode:@"112" level:2 name:@"西安市地方税务局稽查局" latitude:@"34.261796" longitude:@"108.94931" isExpand:NO];
    MapListModel *institute113 = [MapListModel createWithParentCode:@"11" nodeCode:@"113" level:2 name:@"西安市地方税务局大企业税收管理局" latitude:@"34.263018" longitude:@"108.963344" isExpand:NO];
    MapListModel *institute121 = [MapListModel createWithParentCode:@"12" nodeCode:@"121" level:2 name:@"西安市人民政府政务服务中心" latitude:@"34.347648" longitude:@"108.951362" isExpand:NO];
    MapListModel *institute122 = [MapListModel createWithParentCode:@"12" nodeCode:@"122" level:2 name:@"西安市碑林区政务服务中心" latitude:@"34.262641" longitude:@"108.947167" isExpand:NO];
    MapListModel *institute123 = [MapListModel createWithParentCode:@"12" nodeCode:@"123" level:2 name:@"西安市莲湖区政务服务中心" latitude:@"34.269723" longitude:@"108.907909" isExpand:NO];
    MapListModel *institute124 = [MapListModel createWithParentCode:@"12" nodeCode:@"124" level:2 name:@"西安市经开区政府服务中心" latitude:@"34.366349" longitude:@"108.935571" isExpand:NO];
    MapListModel *institute125 = [MapListModel createWithParentCode:@"12" nodeCode:@"125" level:2 name:@"西安市地方税务局阎良国家航空高技术产业基地分局" latitude:@"34.648817" longitude:@"109.213213" isExpand:NO];
    
    MapListModel *group2 = [MapListModel createWithParentCode:@"0" nodeCode:@"2" level:0 name:@"组织机构" latitude:nil longitude:nil isExpand:YES];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:group1,station11,station12,station13,station14,station15,institute111,institute112,institute113,group2,institute121,institute122,institute123,institute124,institute125, nil];
    
    return mutableArray;
}
     
@end
