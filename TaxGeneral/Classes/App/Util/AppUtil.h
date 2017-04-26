/************************************************************
 Class    : AppUtil.h
 Describe : 应用界面工具类，用于处理应用列表数据
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-29
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

// 应用列表数据类型
typedef NS_ENUM(NSInteger, AppItemsType){
    AppItemsTypeNone,   // 一般应用列表类型
    AppItemsTypeEdit    // 编辑类型
};

@interface AppUtil : NSObject

+ (instancetype)shareInstance;

- (BOOL)writeNewAppData:(NSDictionary *)appData;// 重新写入菜单列表（编辑时调用）

- (NSMutableArray *)loadDataWithType:(AppItemsType)type;

- (void)initDataWithType:(AppItemsType)type dataBlock:(void (^)(NSMutableArray *dataArray))dataBlock failed:(void(^)(NSString *error))failed;

@end
