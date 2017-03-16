//
//  MessageListModel.m
//  TaxGeneral
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

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
        model.name = [dict objectForKey:@"taxofficialname"];
    }else if([sourceCode isEqualToString:@"02"]){
        model.avatar = @"msg_notification";
        model.name = [dict objectForKey:@"sourcename"];
    }else{
        model.avatar = @"msg_information";
        model.name = [dict objectForKey:@"sourcename"];
    }
    
    model.pushUserCode = [dict objectForKey:@"pushusercode"];
    model.message = [dict objectForKey:@"pushcontent"];
    model.date = [[dict objectForKey:@"pushdate"] substringWithRange:NSMakeRange(0, 16)];
    model.unReadCount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"unreadcount"]];;
    model.totalPage = [[dict objectForKey:@"detailtotalpage"] intValue];
    
    return model;
}

@end
