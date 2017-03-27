/************************************************************
 Class    : MessageDetailModel.m
 Describe : 消息内容展示模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-14
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageDetailModel.h"

@implementation MessageDetailModel

+(MessageDetailModel *)createWithTitle:(NSString *)title date:(NSString *)date content:(NSString *)content url:(NSString *)url{
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.title = title;
    model.date = date;
    model.content = content;
    model.url = url;
    
    return model;
}

+(MessageDetailModel *)createWithDict:(NSDictionary *)dict{
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.title = [dict objectForKey:@"pushtitle"];
    model.date = [dict objectForKey:@"pushdate"];
    model.content = [dict objectForKey:@"pushcontent"];
    model.url = [dict objectForKey:@"detailurl"];
    
    return model;
}

@end
