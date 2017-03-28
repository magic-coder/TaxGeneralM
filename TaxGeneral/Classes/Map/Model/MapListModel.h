/************************************************************
 Class    : MapListModel.h
 Describe : 地图机构模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MapListModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *parentCode; // 父节点的id，如果为-1表示该节点为根节点
@property (nonatomic, strong) NSString *nodeCode;   // 本节点的id
@property (nonatomic, assign) NSInteger level;      // 该节点的级别
@property (nonatomic, strong) NSString *name;       // 本节点的名称
@property (nonatomic, strong) NSString *address;    // 详细地址
@property (nonatomic, strong) NSString *tel;        // 电话
@property (nonatomic, strong) NSString *latitude;   // 纬度 latitude
@property (nonatomic, strong) NSString *longitude;  // 经度 longitude
@property (nonatomic, assign) BOOL isExpand;        // 该节点是否处于展开状态

/************************ 类方法 ************************/
+ (MapListModel *)createWithParentCode:(NSString *)parentCode nodeCode:(NSString *)nodeCode level:(NSInteger)level name:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude isExpand:(BOOL)isExpand;

+ (MapListModel *)createWithDict:(NSDictionary *)dict;

@end
