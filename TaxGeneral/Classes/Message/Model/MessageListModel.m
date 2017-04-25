/************************************************************
 Class    : MessageListModel.m
 Describe : 消息列表模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-15
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageListModel.h"

@implementation MessageListModel
/*
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"avatar"  :   @"avatar",
             @"name"    :   @"name",
             @"message" :   @"message",
             @"date"    :   @"date"
             };
}
*/

+ (MessageListModel *)createWithDict:(NSDictionary *)dict{
    MessageListModel *model = [[MessageListModel alloc] init];
    
    NSString *sourceCode = [dict objectForKey:@"sourcecode"];
    model.sourceCode = sourceCode;
    if([sourceCode isEqualToString:@"01"]){     // 一般用户推送
        model.avatar = @"msg_head";
        model.name = [dict objectForKey:@"swjgjc"];
    }else if([sourceCode isEqualToString:@"02"]){
        model.avatar = @"msg_notification";
        model.name = [dict objectForKey:@"sourcename"];
    }else{
        model.avatar = @"msg_information";
        model.name = [dict objectForKey:@"sourcename"];
    }
    
    model.pushOrgCode = [dict objectForKey:@"swjgdm"];
    model.message = [dict objectForKey:@"pushcontent"];
    model.date = [[dict objectForKey:@"pushdate"] substringWithRange:NSMakeRange(0, 16)];
    model.unReadCount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"unreadcount"]];;
    
    return model;
}

@end
