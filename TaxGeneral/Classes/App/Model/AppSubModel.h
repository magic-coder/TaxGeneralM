/************************************************************
 Class    : AppSubModel.h
 Describe : 应用第二级菜单数据模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-29
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface AppSubModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *no;     // 应用NO
@property (nonatomic, strong) NSString *pno;     // 应用父PNO
@property (nonatomic, strong) NSString *level;     // 应用级别
@property (nonatomic, strong) NSString *title;  // 应用名称
@property (nonatomic, strong) NSString *webImg;  // 服务器应用图标
@property (nonatomic, strong) NSString *localImg;  // 本地默认logo
@property (nonatomic, strong) NSString *url;    // 应用链接URL（Web应用）

/************************ 类方法 ************************/
+ (AppSubModel *)createWithDict:(NSDictionary *)dict;

@end
