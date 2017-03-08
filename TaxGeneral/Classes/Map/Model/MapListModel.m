//
//  MapListModel.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MapListModel.h"

@implementation MapListModel

+(MapListModel *)createWithParentCode:(NSString *)parentCode nodeCode:(NSString *)nodeCode level:(NSInteger)level name:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude isExpand:(BOOL)isExpand{
    
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

@end
