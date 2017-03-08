/************************************************************
 Class    : NewsModel.h
 Describe : 定义税文结构模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

#pragma mark - 自定义枚举类型
#pragma mark 新闻类型ENUM
typedef NS_ENUM(NSInteger, NewsModelType) {
    NewsModelTypeRecommend, // 推荐
    NewsModelTypeHot,       // 热点
    NewsModelTypeOther      // 其他
};
#pragma mark 新闻样式ENUM
typedef NS_ENUM(NSInteger, NewsModelStyle) {
    NewsModelStyleText,     // 纯文本的新闻类型样式
    NewsModelStyleFewImage, // 图片小于3张的新闻类型样式
    NewsModelStyleMoreImage // 图片大于等于3张的新闻类型样式
};
@interface NewsModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *title;          // 标题
@property (nonatomic, strong) NSArray *images;          // 图片（以数组的形式存放）
@property (nonatomic, strong) NSString *source;         // 来源（如：来自国税、地税、其他等...）
@property (nonatomic, strong) NSString *datetime;       // 发布时间
@property (nonatomic, strong) NSString *url;            // 明细页url
@property (nonatomic, assign) CGFloat cellHeight;       // cell高度
@property (nonatomic, assign) NewsModelType type;       // 类型
@property (nonatomic, assign) NewsModelStyle style;     // 样式

/************************ 类方法 ************************/
+ (NewsModel *)createWithTitle:(NSString *)title images:(NSArray *)images source:(NSString *)source datetime:(NSString *)datetime url:(NSString *)url type:(NewsModelType)type;
+ (NewsModel *)createWithDict:(NSDictionary *)dict;

@end
