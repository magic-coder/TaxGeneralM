/************************************************************
 Class    : BaseDataUtil.m
 Describe : 基本的数据转换工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseDataUtil.h"

@implementation BaseDataUtil

+ (NSString *)dataToJsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if(jsonData){
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        DLog(@"Yan -> 转换失败 error : %@",error);
    }
    
    return jsonString;
}

@end
