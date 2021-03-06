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

+ (instancetype)shareInstance{
    static MessageDetailUtil *messageDetailUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageDetailUtil = [[MessageDetailUtil alloc] init];
    });
    return messageDetailUtil;
}

- (void)loadMsgDataWithParam:(NSDictionary *)param dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:param];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/getMsgDetail";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            dataBlock([self handleDataDict:responseDic]);
        }else if([statusCode isEqualToString:@"500"]){
            [[LoginUtil shareInstance] loginWithTokenSuccess:^{
                [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                    if([[responseDic objectForKey:@"statusCode"] isEqualToString:@"00"]){
                        dataBlock([self handleDataDict:responseDic]);
                    }else{
                        failed([responseDic objectForKey:@"msg"]);
                    }
                } failure:^(NSString *error) {
                    failed(error);
                }];
            } failed:^(NSString *error) {
                RLog(@"Yan -> token登录失败，注销用户，跳转至登录界面[error = %@]", error);
                failed(@"510");
            }];
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
        
    } failure:^(NSString *error) {
        failed(error);
    }];
}

-(void)deleteMsgWithUUID:(NSString *)uuid success:(void (^)())success failed:(void (^)(NSString *))failed{

    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:@[@{@"pushdetailuuid" : uuid}]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/delMsgByItem";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            success();
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
    
}

- (NSDictionary *)handleDataDict:(NSDictionary *)dict{
    NSDictionary *businessData = [dict objectForKey:@"businessData"];
    NSString *totalPage = [businessData objectForKey:@"totalPage"];
    NSArray *results = [businessData objectForKey:@"results"];
    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:totalPage, @"totalPage", results, @"results", nil];
    
    return resDict;
}

@end
