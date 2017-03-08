//
//  MessageDetailModel.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

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
    model.title = [dict objectForKey:@"title"];
    model.date = [dict objectForKey:@"date"];
    model.content = [dict objectForKey:@"content"];
    model.url = [dict objectForKey:@"url"];
    
    return model;
}

@end
