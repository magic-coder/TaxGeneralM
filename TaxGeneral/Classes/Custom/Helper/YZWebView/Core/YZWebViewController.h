/************************************************************
 Class    : YZWebViewController.h
 Describe : 自定义包含调用页面js方法的WebViewController
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "YZWebView.h"

@interface YZWebViewController : UIViewController

@property (nonatomic, strong)NSURL *url;

@property (nonatomic ,strong) NSMutableURLRequest *req;

@property (nonatomic, strong)UIColor *tintColor;

@property (nonatomic, readonly)YZWebView *webView;
@property (nonatomic, assign ,getter= isUseUIWebView)BOOL useUIWebView;

@property (nonatomic, assign ,getter= isHiddenProgressView)BOOL hiddenProgressView; // defult is NO ,if you set Yes the progressBar will not show .
/**
 * @brief 根据远端URL地址加载
 */
- (instancetype)initWithURL:(NSString *)url;
/**
 * @brief 根据本地文件路径加载
 */
- (instancetype)initWithFile:(NSString *)url;

- (void)invokeJavaScript:(NSString *)function;

- (void)invokeJavaScript:(NSString *)function completionHandler:(void (^)( id, NSError * error))completionHandler;
/**
 * @brief 注册js调用oc的名称
 * @return 子类需要返回注册的名称，以及实现方法
 */
- (NSArray <NSString *>*)registerJavascriptName;

@end
