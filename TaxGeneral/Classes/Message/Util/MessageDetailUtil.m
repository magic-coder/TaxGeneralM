//
//  MessageDetailUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MessageDetailUtil.h"
#import "MessageDetailModel.h"

#define FILE_NAME @"msgDetailData.plist"

@implementation MessageDetailUtil

- (void)loadMsgDataWithParam:(NSDictionary *)param dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSString *jsonString = [BaseDataUtil dataToJsonString:param];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/getMsgDetail";
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
            if([[param objectForKey:@"pageNo"] intValue] == 1){
                BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
                [sandBoxUtil writeData:resDict fileName:FILE_NAME];
            }
            
            dataBlock(resDict);
        }else{
            failed(@"收取消息失败！");
        }
        dataBlock(responseDic);
    } failure:^(NSString *error) {
        failed(error);
    }];
}

@end
