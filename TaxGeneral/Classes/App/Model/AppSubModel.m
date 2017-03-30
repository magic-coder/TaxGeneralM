/************************************************************
 Class    : AppSubModel.m
 Describe : 应用第二级菜单数据模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-29
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppSubModel.h"

@implementation AppSubModel

+ (AppSubModel *)createWithDict:(NSDictionary *)dict{
    AppSubModel *model = [[AppSubModel alloc] init];
    model.no = [dict objectForKey:@"appno"];
    model.title = [dict objectForKey:@"appname"];
    model.webImg = [dict objectForKey:@"appimage"];// 服务器logo图标
    model.localImg = [NSString stringWithFormat:@"appSub_0%@", model.no]; // 加载本地default图标(根据应用序列号生成)
    model.url = [dict objectForKey:@"appurl"];
    return model;
}

@end
