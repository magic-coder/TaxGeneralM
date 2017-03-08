/************************************************************
 Class    : YZNetworkingManager.h
 Describe : 自己封装的http请求，包括了get、post请求
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-25
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// 请求方式
typedef NS_ENUM (NSInteger, YZRequestMethod) {
    GET = 0, // GET请求
    POST = 1  // POST请求
};

// 错误状态码 ios-sdk里面的 NSURLError.h文件
typedef NS_ENUM (NSInteger, YZNetworkingErrorType) {
    YZNetworkingErrorType_TimeOut = NSURLErrorTimedOut,                 // -1001 请求超时
    YZNetworkingErrorType_UnURL = NSURLErrorUnsupportedURL,             // -1002 不支持的URL
    YZNetworkingErrorType_NoNetwork = NSURLErrorNotConnectedToInternet, // -1009 断网
    YZNetworkingErrorType_404Failed = NSURLErrorBadServerResponse,      // -1011 404错误
    
    YZNetworkingErrorType_3840Failed = 3840                             // 请求或返回不是纯json格式
};

@interface YZNetworkingManager : NSObject

/**
 * @breif 实现声明单例方法 GCD
 */
+(YZNetworkingManager *)shareInstance;

/**
 * @brief 封装Networking请求方法GET、POST
 * @param method 自定义提交方式，url 请求地址，parameters 请求参数
 * @return success 执行成功返回字典，failure 执行失败返回错误信息
 */
-(void)requestMethod:(YZRequestMethod)method
                  url:(NSString *)url
           parameters:(NSDictionary *)parameters
              success:(void (^)(NSDictionary *responseDic))success
              failure:(void (^)(NSString *error))failure;

@end
