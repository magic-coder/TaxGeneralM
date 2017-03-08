/************************************************************
 Class    : BaseCollectionModel.h
 Describe : 基础的网格模型对象
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-11
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseCollectionModelItem : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
/*
@property (nonatomic, assign) NSInteger uids;
@property (nonatomic, assign) NSInteger sids;
@property (nonatomic, assign) NSInteger flag;
 */

/************************ 类方法 ************************/
+ (BaseCollectionModelItem *)createWithTitle:(NSString *)title image:(NSString *)image;
+ (BaseCollectionModelItem *)createWithDict:(NSDictionary *)dict;

@end

@interface BaseCollectionModelGroup : NSObject

/************************ 属性 ************************/
// 组标题
@property (nonatomic, strong) NSString *groupTitle;
// 组元素
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, readonly) NSUInteger itemsCount;

/************************ 类方法 ************************/
- (instancetype) initWithGroupTitle:(NSString *)groupTitle settingItems:(BaseCollectionModelItem *)firstObj, ...;
- (BaseCollectionModelItem *) itemAtIndex:(NSUInteger)index;
- (NSUInteger) itemsCount;

@end
