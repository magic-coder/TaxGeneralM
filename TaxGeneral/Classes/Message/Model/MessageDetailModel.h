//
//  MessageDetailModel.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *title;      // 标题
@property (nonatomic, strong) NSString *date;       // 时间
@property (nonatomic, strong) NSString *content;    // 内容
@property (nonatomic, strong) NSString *url;        // 详情页

@property (nonatomic, assign) CGFloat cellHeight;   // cell高度

/************************ 类方法 ************************/
+ (MessageDetailModel *)createWithTitle:(NSString *)title date:(NSString *)date content:(NSString *)content url:(NSString *)url;
+ (MessageDetailModel *)createWithDict:(NSDictionary *)dict;

@end
