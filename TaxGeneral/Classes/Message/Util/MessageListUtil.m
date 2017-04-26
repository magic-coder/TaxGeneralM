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

+ (instancetype)shareInstance{
    static MessageListUtil *messageListUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageListUtil = [[MessageListUtil alloc] init];
    });
    return messageListUtil;
}

- (NSDictionary *)loadMsgDataWithFile{
    return [[BaseSandBoxUtil shareInstance] loadDataWithFileName:FILE_NAME];
}

- (int)getMsgUnReadCountSuccess:(void (^)(int))success{
    
    NSString *url = @"message/getUnreadCount";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:nil success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            NSDictionary *businessData = [responseDic objectForKey:@"businessData"];
            int unReadCount = [[businessData objectForKey:@"unReadCount"] intValue];
            success(unReadCount);
        }else{
            success(0);
        }
    } failure:^(NSString *error) {
        success(0);
    }];
    
    return 0;
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
                [[BaseSandBoxUtil shareInstance] writeData:resDict fileName:FILE_NAME];
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
    
    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/getMsgList";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        DLog(@"Yan -> 请求处理结果状态值 : statusCode = %@", statusCode);
        DLog(@"%@",[statusCode isEqualToString:@"500"]?@"YES":@"NO");
        if([statusCode isEqualToString:@"00"]){
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

- (void)deleteMsgWithSourceCode:(NSString *)sourceCode pushOrgCode:(NSString *)pushOrgCode success:(void (^)())success failed:(void (^)(NSString *))failed{
    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:@{@"sourcecode" : sourceCode, @"swjgdm" : pushOrgCode}];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    NSString *url = @"message/delMsgBySource";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        DLog(@"Yan -> 请求处理结果状态值 : statusCode = %@", statusCode);
        if([statusCode isEqualToString:@"00"]){
            success();
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
    
    NSArray *results = [businessData objectForKey:@"results"];
    if(results.count <= 0){
        // 删除msg列表信息
        [[BaseSandBoxUtil shareInstance] removeFileName:@"msgData.plist"];
    }
    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys: results, @"results", nil];
    // 写入本地缓存（SandBox）
    [[BaseSandBoxUtil shareInstance] writeData:resDict fileName:FILE_NAME];
    
    return resDict;
}

@end
