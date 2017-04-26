/************************************************************
 Class    : NewsUtil.h
 Describe : 税闻列表内容获取方法类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface NewsUtil : NSObject

+ (instancetype)shareInstance;

- (NSMutableDictionary *)loadData;

- (void)initDataWithPageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *dataDict))dataBlock failed:(void(^)(NSString *error))failed;

- (void)moreDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSArray *dataArray))dataBlock failed:(void(^)(NSString *error))failed;

@end
