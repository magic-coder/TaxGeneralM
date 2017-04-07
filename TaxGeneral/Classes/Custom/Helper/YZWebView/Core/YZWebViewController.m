/************************************************************
 Class    : YZWebViewController.m
 Describe : 自定义包含调用页面js方法的WebViewController
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZWebViewController.h"
#import "YZWebViewProress.h"
#import "YZWebProgressView.h"

@interface YZWebViewController ()<YZWebViewDelegate>

@property (nonatomic ,assign) BOOL hiddenNavtionBar;
@end

@implementation YZWebViewController{
    BOOL _isFile;
    YZWebProgressView *_progressView;
    YZWebViewProress *_progressProxy;
}
- (instancetype)initWithURL:(NSString *)url
{
    if (self = [super init]) {
        _url = [NSURL URLWithString:url];
        
    }
    return self;
}
- (instancetype)initWithFile:(NSString *)url{
    if (self = [super init]) {
        _url = [NSURL fileURLWithPath:url];
        _isFile = YES;
    }
    return self;
}

- (NSMutableURLRequest *)req{
    if (!_req) {
        // 设置请求超时时间为10秒
        //_req = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        
        // 携带cookie进行请求
        _req = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        NSDictionary *cookieHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [_req setHTTPShouldHandleCookies:YES];
        [_req setAllHTTPHeaderFields:cookieHeader];
    }
    return _req;
}
#pragma mark Activity
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self layout];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_hiddenProgressView) {
        [_progressView removeFromSuperview];
    }
//    self.navigationController.navigationBarHidden = [self isNavigationHidden];
//    self.automaticallyAdjustsScrollViewInsets = ![self isNavigationHidden];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)initialize{
    CGRect rect = CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height);
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    //#else
    //#endif
    if (self.useUIWebView) {
        _webView = [[YZWebView alloc] initWithUIWebView:rect];
    }else{
        _webView = [[YZWebView alloc] initWithFrame:rect];
    }
    [_webView loadRequest:self.req];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _progressView = [[YZWebProgressView alloc]initWithFrame:CGRectMake(0, [self isNavigationHidden]?0:64, self.view.frame.size.width, 2)];
    _tintColor = [UIColor orangeColor];
    if(_tintColor){
        _progressView.color = _tintColor;
    }
    if([self isNavigationHidden]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_progressView];
    
    
}
- (void)layout{
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //layout 子view
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    [self.view addConstraints:array];
}

#pragma mark - WebViewDelegate
-(BOOL)webView:(YZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(YZWebViewNavigationType)navigationType{
    DLog(@"Yan -> %@", webView.URL.absoluteString);
    
    // 如果响应的地址是指定域名，则允许跳转
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        return NO;
    }else{
        return YES;
    }
}
-(BOOL)webView:(YZWebView *)webView shouldStartLoadWithResponse:(NSURLResponse *)response{
    //DLog(@"Yan -> %@", webView.URL.absoluteString);

    DLog(@"_url absoluteString = %@",[_url absoluteString]);
    
    // 如果响应的地址是指定域名，则允许跳转
    if ([response.URL.absoluteString rangeOfString:@"account/initLogin"].location != NSNotFound) {
        // 启动/挂起恢复时进行登录操作
        [LoginUtil loginWithTokenSuccess:^{
            DLog(@"Yan -> 初始化登录成功！");
            [self.webView loadUrl:[_url absoluteString]];
            // 写入cookie
        } failed:^(NSString *error) {
            DLog(@"Yan -> 初始化登录失败 error = %@", error);
            
            [YZAlertView showAlertWith:self title:@"登录失效" message:@"您当前登录信息已失效，请重新登录！" callbackBlock:^(NSInteger btnIndex) {
                // 注销方法
                [YZProgressHUD showHUDView:NAV_VIEW Mode:LOCKMODE Text:@"注销中..."];
                [AccountUtil accountLogout];
                [YZProgressHUD hiddenHUDForView:NAV_VIEW];
                
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.isLogin = YES;
                
                // 水波纹动画效果
                CATransition *animation = [CATransition animation];
                animation.duration = 1.0f;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.type = @"rippleEffect";
                //animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:animation forKey:nil];
                
                [self presentViewController:loginVC animated:YES completion:nil];
                
            } cancelButtonTitle:@"重新登录" destructiveButtonTitle:nil otherButtonTitles: nil];
        }];
        
        return NO;
    }else{
        return YES;
    }
}
- (void)webViewDidStartLoad:(YZWebView *)webView{
    DLog(@"Yan -> 页面开始加载时调用 : didStartProvisionalNavigation");
}
- (void)webViewDidFinshLoad:(YZWebView *)webView{
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    "window.scrollBy(0, 0);";
    [webView invokeJavaScript:injectionJSString];
    
    if (self.title.length == 0) {
        self.title = webView.title;
    }
}
- (void)webView:(YZWebView *)webView withError:(NSError *)error{
    if(error.code < 0 && error.code != NSURLErrorCancelled && error.code != NSURLErrorServerCertificateUntrusted){
        [YZProgressHUD showHUDView:NAV_VIEW Mode:SHOWMODE Text:@"网络连接异常！"];
    }
    //DLog(@"Yan ->  页面加载失败 : %@", error.localizedDescription);
}
- (void)webView:(YZWebView *)webVie updateProgress:(NSProgress *)progress{
    [_progressView setProgress:progress];
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler){
            completionHandler();
        }
    }]];
    if (self) {
        [self presentViewController:alert animated:YES completion:NULL];
    }
}

/**
 * @brief Register Invoke JavaScript observe
 */
- (NSObject *)registerJavaScriptHandler{
    return self;
}
- (NSArray <NSString *>*)registerJavascriptName{
    return nil;
}
#pragma mark Public

- (void)invokeJavaScript:(NSString *)function{
    [self.webView invokeJavaScript:function];
    
}

- (void)invokeJavaScript:(NSString *)function completionHandler:(void (^)( id, NSError * error))completionHandler{
    [self.webView invokeJavaScript:function completionHandler:completionHandler];
}

#pragma makr Private
- (BOOL)isNavigationHidden{
    return !self.navigationController
            || !self.navigationController.navigationBar.isTranslucent
            || !self.navigationController.navigationBar;
}


-(void)dealloc{
    
}
@end
