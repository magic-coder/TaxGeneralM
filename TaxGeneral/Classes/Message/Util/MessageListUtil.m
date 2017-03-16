//
//  MessageListUtil.m
//  TaxGeneral
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "MessageListUtil.h"

#define FILE_NAME @"msgData.plist"

@implementation MessageListUtil

- (NSDictionary *)loadMsgDataWithFile{
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    return [sandBoxUtil loadDataWithFileName:FILE_NAME];
}

- (void)loadMsgDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSString *jsonString = [BaseDataUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/getMsgList";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            NSDictionary *businessData = [responseDic objectForKey:@"businessData"];
            NSString *totalPage = [businessData objectForKey:@"totalPage"];
            NSArray *results = [businessData objectForKey:@"results"];
            
            NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:totalPage, @"totalPage", results, @"results", nil];
            if(pageNo == 1){
                BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
                [sandBoxUtil writeData:resDict fileName:FILE_NAME];
            }
            dataBlock(resDict);
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

@end
