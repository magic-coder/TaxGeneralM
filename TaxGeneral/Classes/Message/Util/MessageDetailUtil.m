/************************************************************
 Class    : MessageDetailUtil.m
 Describe : 消息内容明细工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageDetailUtil.h"
#import "MessageDetailModel.h"

@implementation MessageDetailUtil

- (void)loadMsgDataWithParam:(NSDictionary *)param dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSString *jsonString = [BaseHandleUtil dataToJsonString:param];
    
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
            dataBlock(resDict);
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

@end
