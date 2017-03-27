/************************************************************
 Class    : MessageListModel.h
 Describe : 消息列表模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-15
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *sourceCode;     // 来源代码
@property (nonatomic, strong) NSString *pushUserCode;   // 推送用户代码
@property (nonatomic, strong) NSString *avatar;         // 头像
@property (nonatomic, strong) NSString *name;           // 名称
@property (nonatomic, strong) NSString *message;        // 消息
@property (nonatomic, strong) NSString *date;           // 时间
@property (nonatomic, strong) NSString *unReadCount;    // 未读条数
@property (nonatomic, assign) int totalPage;            // 最大页码

/************************ 类方法 ************************/
+ (MessageListModel *)createWithDict:(NSDictionary *)dict;

@end
