/************************************************************
 Class    : MapListUtil.h
 Describe : 地图机构工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MapListUtil : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *)getMapData;

- (void)loadMapDataBlock:(void(^)(NSMutableArray *dataArray))dataBlock failed:(void(^)(NSString *error))failed;

@end
