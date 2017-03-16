/************************************************************
 Class    : BaseCollectionModel.m
 Describe : 基础的网格模型对象
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-11
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseCollectionModel.h"

#pragma mark - BaseCollectionModelItem方法
@implementation BaseCollectionModelItem

#pragma mark 根据字典创建一个item
+ (BaseCollectionModelItem *)createWithDict:(NSDictionary *)dict{
    BaseCollectionModelItem *item = [[BaseCollectionModelItem alloc] init];
    item.no = [dict objectForKey:@"appno"];
    item.title = [dict objectForKey:@"appname"];
    item.webImg = [dict objectForKey:@"appimage"];// 服务器logo图标
    item.localImg = [NSString stringWithFormat:@"app_%@", item.no]; // 加载本地default图标(根据应用序列号生成)
    item.url = [dict objectForKey:@"appurl"];
    return item;
}

@end

#pragma mark - BaseCollectionModelGroup方法
@implementation BaseCollectionModelGroup

#pragma mark 初始化方法
-(instancetype)initWithGroupTitle:(NSString *)groupTitle settingItems:(BaseCollectionModelItem *)firstObj, ...{
    if (self = [super init]) {
        _groupTitle = groupTitle;
        _items = [[NSMutableArray alloc] init];
        va_list argList;
        if (firstObj) {
            [_items addObject:firstObj];
            va_start(argList, firstObj);
            id arg;
            while ((arg = va_arg(argList, id))) {
                [_items addObject:arg];
            }
            va_end(argList);
        }
    }
    return self;
}

#pragma mark 根据下标获取对象
-(BaseCollectionModelItem *)itemAtIndex:(NSUInteger)index{
    return [_items objectAtIndex:index];
}

#pragma mark 获取每个组中对象的个数
- (NSUInteger) itemsCount{
    return self.items.count;
}

@end
