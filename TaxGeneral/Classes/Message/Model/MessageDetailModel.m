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

+(MessageDetailModel *)createWithDict:(NSDictionary *)dict{
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.uuid = [dict objectForKey:@"pushdetailuuid"];
    model.title = [dict objectForKey:@"pushtitle"];
    model.user = [dict objectForKey:@"taxofficialname"];
    model.date = [[BaseHandleUtil shareInstance] formatDate:[[dict objectForKey:@"pushdate"] substringWithRange:NSMakeRange(0, 19)] pattern:@"yyyy年MM月dd日 HH:mm"];
    model.content = [dict objectForKey:@"pushcontent"];
    model.url = [dict objectForKey:@"detailurl"];
    
    return model;
}

@end
