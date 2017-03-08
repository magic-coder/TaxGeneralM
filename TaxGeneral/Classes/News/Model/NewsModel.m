/************************************************************
 Class    : NewsModel.m
 Describe : 定义税文结构模型
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsModel.h"

@implementation NewsModel

+ (NewsModel *)createWithTitle:(NSString *)title images:(NSArray *)images source:(NSString *)source datetime:(NSString *)datetime url:(NSString *)url type:(NewsModelType)type{
    
    NewsModel *model = [[NewsModel alloc] init];
    model.title = title;
    model.images = images;
    model.source = source;
    model.datetime = datetime;
    model.url = url;
    model.type = type;
    
    if(model.images.count == 0){
        model.style = NewsModelStyleText;
    }
    
    if(model.images.count > 0 && images.count < 3){
        model.style = NewsModelStyleFewImage;
    }
    
    if(model.images.count >= 3){
        model.style = NewsModelStyleMoreImage;
    }
    
    return model;
}

+ (NewsModel *)createWithDict:(NSDictionary *)dict{
    
    NewsModel *model = [[NewsModel alloc] init];
    model.title = [dict objectForKey:@"TITLE"];
    model.images = [dict objectForKey:@"IMAGES"];
    //model.source = [dict objectForKey:@"SOURCE"];
    model.datetime = [dict objectForKey:@"RELEASEDATE"];
    model.url = [dict objectForKey:@"URL"];
    //model.type = [[dict objectForKey:@"TYPE"] integerValue];
    
    if(model.images.count == 0){
        model.style = NewsModelStyleText;
    }
    
    if(model.images.count > 0 && model.images.count < 3){
        model.style = NewsModelStyleFewImage;
    }
    
    if(model.images.count >= 3){
        model.style = NewsModelStyleMoreImage;
    }
    
    return model;
}

@end
