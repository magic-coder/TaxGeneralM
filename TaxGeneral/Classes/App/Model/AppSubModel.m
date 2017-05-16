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
    model.pno = [dict objectForKey:@"pappno"];
    model.level = [dict objectForKey:@"applevel"];
    model.title = [dict objectForKey:@"appname"];
    model.webImg = [dict objectForKey:@"appimage"];// 服务器logo图标
    model.localImg = [NSString stringWithFormat:@"app_%@%@", model.pno, model.no]; // 加载本地default图标(根据应用序列号生成)
    model.url = [dict objectForKey:@"appurl"];
    model.keyWords = [NSString stringWithFormat:@"%@ %@", model.title, [[BaseHandleUtil shareInstance] transform:[dict objectForKey:@"appname"]]];
    return model;
}

#pragma mark - 重写属性的Getter方法
-(NSString *)no{
    return _no == nil ? @"" : _no;
}
-(NSString *)pno{
    return _pno == nil ? @"" : _pno;
}
-(NSString *)level{
    return _level == nil ? @"" : _level;
}
-(NSString *)title{
    return _title == nil ? @"" : _title;
}
-(NSString *)webImg{
    //return @"";
    return _webImg == nil ? @"" : _webImg;
}
-(NSString *)localImg{
    return _localImg == nil ? @"" : _localImg;
}
- (NSString *)url{
    return _url == nil ? @"" : _url;
}

@end
