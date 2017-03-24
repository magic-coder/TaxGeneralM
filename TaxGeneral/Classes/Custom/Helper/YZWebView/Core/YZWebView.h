/************************************************************
 Class    : YZWebView.h
 Describe : This is Yanzheng custom WebView is easy to use
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

@class YZWebView;

typedef NS_ENUM(NSInteger, YZWebViewNavigationType) {
    YZWebViewNavigationTypeLinkClicked,
    YZWebViewNavigationTypeFormSubmitted,
    YZWebViewNavigationTypeBackForward,
    YZWebViewNavigationTypeReload,
    YZWebViewNavigationTypeFormResubmitted,
    YZWebViewNavigationTypeOther
};
@protocol YZWebViewDelegate <NSObject>
@optional
- (BOOL)webView:(YZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(YZWebViewNavigationType)navigationType;// 发送请求前决定是否跳转
- (BOOL)webView:(YZWebView *)webView shouldStartLoadWithResponse:(NSURLResponse *)response;// 请求响应后决定是否跳转
- (void)webView:(YZWebView *)webView withError:(NSError *)error;
- (void)webViewDidFinshLoad:(YZWebView *)webView;
- (void)webViewDidStartLoad:(YZWebView *)webView;
- (void)webView:(YZWebView *)webVie updateProgress:(NSProgress *)progress;// 更新加载进度条

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
#endif
/**
 * @brief Register JavascriptName
 * @return need names array
 */
- (NSArray <NSString *>*)registerJavascriptName;
/**
 * @brief Register Invoke JavaScript observe
 */
- (NSObject *)registerJavaScriptHandler;
@end
@interface YZWebView : UIView

/*! @abstract The web delegate. */
@property ( nonatomic, weak) id <YZWebViewDelegate> delegate;
@property ( nonatomic, readonly, copy) NSURL *URL;
@property ( nonatomic, readonly, copy) NSString *title;
@property ( nonatomic, readonly) NSProgress *estimatedProgress;
@property ( nonatomic, readonly) UIView *webView;// defult is WKWebView ,WKWebView have't cache ,you can choose UIWebView before ViewDidLoad.
@property ( nonatomic, readonly, strong) UIScrollView *scrollView NS_AVAILABLE_IOS(5_0);
@property ( nonatomic, readonly) BOOL canGoBack;
@property ( nonatomic, readonly) BOOL canGoForward;
@property ( nonatomic, readonly, getter=isLoading) BOOL loading;
/*! @abstract   Allow Registe NatvieHelper JavaScript
 if set No NatvieHelper will not register ,you can register on html,defult is Yes
 */
@property ( nonatomic, getter=isAllowNativeHelperJS) BOOL allowNativeHelperJS;

- ( instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- ( instancetype)initWithUIWebView; // If you want choose UIWebView
- ( instancetype)initWithUIWebView:(CGRect)frame;
/*! @abstract  requested URL.*/
- (void)loadRequest:(  NSURLRequest *)request;
/*! @abstract  requested URL. map NSURLRequest*/
- (void)loadUrl:(NSString *)url;

/*! @abstract Sets the webpage contents and base URL.
 @param string The string to use as the contents of the webpage.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 */
- (void)loadHTMLString:(  NSString *)string baseURL:(NSURL *)baseURL;

/*! @abstract Sets the webpage contents and base URL.
 @param data The data to use as the contents of the webpage.
 @param MIMEType The MIME type of the data.
 @param encodingName The data's character encoding name.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 */
- (void)loadData:(  NSData *)data MIMEType:(  NSString *)MIMEType textEncodingName:(  NSString *)textEncodingName baseURL:(  NSURL *)baseURL;

- (void)invokeJavaScript:(  NSString *)function;

- (void)invokeJavaScript:(  NSString *)function completionHandler:( void (^)(  id, NSError * error))completionHandler;


/*! @abstract Reloads the current page.
 */
- (void)reload;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

@end
