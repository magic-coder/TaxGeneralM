/************************************************************
 Class    : NewsUtil.m
 Describe : 税文列表内容获取方法类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsUtil.h"
#import "NewsModel.h"

#define FILE_NAME @"newsData.plist"

@implementation NewsUtil

- (NSMutableDictionary *)loadData{
    BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
    NSMutableDictionary *newsDict = [sandBoxUtil loadDataWithFileName:FILE_NAME];
    return newsDict;
}

- (void)initDataWithPageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSString *jsonString = [BaseDataUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    
    NSString *url = @"public/photonews/index";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            NSDictionary *businessData = [responseDic objectForKey:@"businessData"];
            NSArray *loopData = [businessData objectForKey:@"loopData"];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            NSMutableArray *releasedates = [[NSMutableArray alloc] init];
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            NSMutableArray *urls = [[NSMutableArray alloc] init];
            for(NSDictionary *loopDict in loopData){
                [images addObject:[loopDict objectForKey:@"IMAGE"]];
                [releasedates addObject:[loopDict objectForKey:@"RELEASEDATE"]];
                [titles addObject:[loopDict objectForKey:@"TITLE"]];
                [urls addObject:[loopDict objectForKey:@"URL"]];
            }
            NSDictionary *loopResult = [NSDictionary dictionaryWithObjectsAndKeys:images, @"images", releasedates, @"releasedates", titles, @"titles", urls, @"urls", nil];
            NSDictionary *newsData = [businessData objectForKey:@"newsData"];
            NSArray *newsResult = [newsData objectForKey:@"results"];
            NSString *totalPage = [newsData objectForKey:@"totalPage"];
            
            NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:loopResult, @"loopResult", newsResult, @"newsResult", totalPage, @"totalPage", nil];
            
            BaseSandBoxUtil *sandBoxUtil = [[BaseSandBoxUtil alloc] init];
            [sandBoxUtil writeData:resDict fileName:FILE_NAME];
            dataBlock(resDict);
        }else{
            failed([responseDic objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

- (void)moreDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSArray *))dataBlock failed:(void (^)(NSString *))failed{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSString *jsonString = [BaseDataUtil dataToJsonString:dict];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    
    NSString *url = @"public/photonews/queryPhotoNewsList";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        // 获取请求状态值
        DLog(@"statusCode = %@", [responseDic objectForKey:@"statusCode"]);
        NSString *statusCode = [responseDic objectForKey:@"statusCode"];
        if([statusCode isEqualToString:@"00"]){
            DLog(@"请求报文成功，开始进行处理...");
            NSDictionary *businessData = [responseDic objectForKey:@"businessData"];
            NSArray *dataArray = [businessData objectForKey:@"results"];
            dataBlock(dataArray);
        }
    } failure:^(NSString *error) {
        failed(error);
    }];
}

@end
