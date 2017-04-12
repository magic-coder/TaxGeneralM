/************************************************************
 Class    : MessageListUtil.m
 Describe : 消息列表工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-16
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageListUtil.h"

#define FILE_NAME @"msgData.plist"

@implementation MessageListUtil

- (NSDictionary *)loadMsgDataWithFile{
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    return [sandBoxUtil loadDataWithFileName:FILE_NAME];
}
/*
- (void)loadMsgDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSString *jsonString = [BaseHandleUtil dataToJsonString:dict];
    
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
*/
- (void)loadMsgDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSString *jsonString = [BaseHandleUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/getMsgList";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        DLog(@"Yan -> 请求处理结果状态值 : statusCode = %@", statusCode);
        DLog(@"%@",[statusCode isEqualToString:@"500"]?@"YES":@"NO");
        if([statusCode isEqualToString:@"00"]){
            dataBlock([self handleDataDict:responseDic]);
        }else if([statusCode isEqualToString:@"500"]){
            [LoginUtil loginWithTokenSuccess:^{
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
                DLog(@"Yan -> token登录失败，注销用户，跳转至登录界面[error = %@]", error);
                failed(@"510");
            }];
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
    
}

#pragma mark - 对返回的数据进行处理
- (NSDictionary *)handleDataDict:(NSDictionary *)dict{
    NSDictionary *businessData = [dict objectForKey:@"businessData"];
    
    NSString *pageNo = [businessData objectForKey:@"pageNo"];
    NSString *totalPage = [businessData objectForKey:@"totalPage"];
    NSArray *results = [businessData objectForKey:@"results"];
    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:totalPage, @"totalPage", results, @"results", nil];
    // 写入本地缓存（SandBox）
    if([pageNo intValue] == 1){
        BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
        [sandBoxUtil writeData:resDict fileName:FILE_NAME];
    }
    
    return resDict;
}

@end
