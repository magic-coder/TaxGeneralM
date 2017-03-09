//
//  MapListModel.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapListModel : NSObject

/************************ 属性 ************************/
@property (nonatomic , assign) NSString *parentCode;      // 父节点的id，如果为-1表示该节点为根节点
@property (nonatomic , assign) NSString *nodeCode;        // 本节点的id
@property (nonatomic , assign) NSInteger level;         // 该节点的级别
@property (nonatomic , strong) NSString *name;          // 本节点的名称
@property (nonatomic, strong) NSString *latitude;    // 纬度 latitude
@property (nonatomic, strong) NSString *longitude;    // 经度 longitude
@property (nonatomic , assign) BOOL isExpand;//该节点是否处于展开状态

/************************ 类方法 ************************/
+ (MapListModel *)createWithParentCode:(NSString *)parentCode nodeCode:(NSString *)nodeCode level:(NSInteger)level name:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude isExpand:(BOOL)isExpand;

@end