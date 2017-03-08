//
//  MessageListModel.h
//  TaxGeneral
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *avatar;      // 头像
@property (nonatomic, strong) NSString *name;           // 名称
@property (nonatomic, strong) NSString *message;        // 消息
@property (nonatomic, strong) NSString *date;           // 时间

/************************ 类方法 ************************/
//+ (MessageListModel *)createWithAvatar:(NSString *)avatar name:(NSString *)name message:(NSString *)message date:(NSString *)date;
//+ (MessageListModel *)createWithDict:(NSDictionary *)dict;

@end
