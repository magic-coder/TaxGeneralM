/************************************************************
 Class    : YZNetworkingManager.m
 Describe : 自己封装的http请求，包括了get、post请求
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-25
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZNetworkingManager.h"

@implementation YZNetworkingManager

/**
 * @breif 实现声明单例方法 GCD
 */
+(YZNetworkingManager *)shareInstance{
    static YZNetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YZNetworkingManager alloc] init];
    });
    return manager;
}

/**
 * @brief 封装Networking请求方法GET、POST
 * @param method 自定义提交方式，url 请求地址，parameters 请求参数
 * @return success 执行成功返回字典，failure 执行失败返回错误信息
 */
-(void)requestMethod:(YZRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.https 请求证书认证
    manager.securityPolicy = [self getCustomHttpsPolicy:manager];
    
    // 3.声明返回的结果类型
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.设置请求类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[manager.requestSerializer setValue:@"gizp" forHTTPHeaderField:@"Content-Encoding"];
    
    // 5.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 20.0;
    
    // 6.设置url请求地址
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", SERVER_URL, url];
    
    // 7.选择请求方式 GET 或 POST
    switch (method) {
            
        case GET:{
            [manager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                // 这里可以获取到目前的数据请求的进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功，解析数据
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                success([self dictionaryWithJsonString:responseStr]);
                
                DLog(@"\n GET请求成功:%@\n\n",responseStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // 请求失败
                failure([self stringWithError:error]);
                
                RLog(@"\n GET请求失败:%@\n\n", [error localizedDescription]);
            }];
        }
            break;
            
        case POST:{
            [manager POST:requestURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                // 这里可以获取到目前的数据请求的进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功，解析数据
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                success([self dictionaryWithJsonString:responseStr]);
                
                DLog(@"\n POST请求成功:%@\n\n",responseStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // 请求失败
                failure([self stringWithError:error]);
                
                RLog(@"\n POST请求失败:%@\n\n",[error localizedDescription]);
                
            }];
        }
            break;
        default:
            break;
    }
}

/**
 * AF3.0单向验证设置
 * https 公钥证书配置
 */
- (AFSecurityPolicy*)getCustomHttpsPolicy:(AFHTTPSessionManager*)manager{
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"root-cert" ofType:@"der"];
    
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    
    NSSet *certSet = [NSSet setWithObject:certData];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    
    policy.allowInvalidCertificates = YES;// 是否允许自建证书或无效证书(重要!!!)
    policy.validatesDomainName = NO;//是否校验证书上域名与请求域名一致
    
    return policy;
}

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    // NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    if(error) {
        DLog(@"json解析失败：%@",error);
        return nil;
    }
    
    return dic;
}

/**
 * @brief 把错误信息转换成文字描述
 * @param error错误信息
 * @return 返回字符串
 */
-(NSString *)stringWithError:(NSError *)error{
    switch (error.code) {
        case YZNetworkingErrorType_TimeOut:
            return @"访问服务器超时，请检查网络！";
            break;
        case YZNetworkingErrorType_UnURL:
            return @"无效的访问地址，请联系管理员！";
            break;
        case YZNetworkingErrorType_NoNetwork:
            return @"网络连接失败，请检查网络！";
            break;
        case YZNetworkingErrorType_404Failed:
            return @"404错误，请稍后再试！";
            break;
        case YZNetworkingErrorType_3840Failed:
            return @"服务器报错了，请稍后再试！";
            break;
        default:
            return @"未知错误异常，请稍后再试！";
            break;
    }
}

@end
