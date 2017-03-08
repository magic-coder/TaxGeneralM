//
//  MessageListModel.m
//  TaxGeneral
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"avatar"  :   @"avatar",
             @"name"    :   @"name",
             @"message" :   @"message",
             @"date"    :   @"date"
             };
}

/*
+ (MessageListModel *)createWithAvatar:(NSString *)avatar name:(NSString *)name message:(NSString *)message date:(NSString *)date{
    MessageListModel *model = [[MessageListModel alloc] init];
    
    model.avatar = avatar;
    model.name = name;
    model.message = message;
    model.date = date;
    return model;
}

+(MessageListModel *)createWithDict:(NSDictionary *)dict{
    MessageListModel *model = [[MessageListModel alloc] init];
    
    model.avatar = [dict objectForKey:@"avatar"];
    model.name = [dict objectForKey:@"name"];
    model.message = [dict objectForKey:@"message"];
    model.date = [dict objectForKey:@"date"];
    
    return model;
}
*/

@end
