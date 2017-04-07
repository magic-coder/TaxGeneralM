/************************************************************
 Class    : BaseWebViewController.h
 Describe : 基本的WebView视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-18
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZWebViewController.h"

@interface BaseWebViewController : UIViewController

@property (nonatomic, strong)NSURL *url;
@property (nonatomic ,strong) NSMutableURLRequest *request;

/**
 * @brief 根据远端URL地址加载
 */
- (instancetype)initWithURL:(NSString *)url;
/**
 * @brief 根据本地文件路径加载
 */
- (instancetype)initWithFile:(NSString *)url;

@end
