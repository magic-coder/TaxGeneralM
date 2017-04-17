/************************************************************
 Class    : MessageDetailModel.h
 Describe : 消息内容展示模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-14
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MessageDetailModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *uuid;       // 消息主键
@property (nonatomic, strong) NSString *title;      // 标题
@property (nonatomic, strong) NSString *date;       // 时间
@property (nonatomic, strong) NSString *content;    // 内容
@property (nonatomic, strong) NSString *url;        // 详情页

@property (nonatomic, assign) CGFloat cellHeight;   // cell高度

/************************ 类方法 ************************/
+ (MessageDetailModel *)createWithDict:(NSDictionary *)dict;

@end
