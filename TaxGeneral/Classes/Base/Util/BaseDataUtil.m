//
//  BaseDataUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

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
