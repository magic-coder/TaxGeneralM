/************************************************************
 Class    : YZWebView.m
 Describe : This is Yanzheng custom WebView is easy to use
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZWebView.h"
#import "YZWebViewProress.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@interface YZWebView ()<UIWebViewDelegate,YZWebViewProgressDelegate ,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) YZWebViewProress *progressProxy;
@property (nonatomic, strong) NSProgress *estimatedProgress;
#else
@interface YZWebView ()<YZWebViewProgressDelegate ,UIWebViewDelegate,YZWebViewProgressDelegate>
@property (nonatomic, strong) JSContext *context;
#endif
@end
@implementation YZWebView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[self configuretion]];
        [self initialize:(WKWebView *)_webView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _webView = [[WKWebView alloc] initWithFrame:frame configuration:[self configuretion]];

        [self initialize:(WKWebView *)_webView];
    }
    return self;
}
- ( instancetype)initWithUIWebView{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]init];
        [self initializeUIWebView:(UIWebView *)_webView];
    }
    return self;
}
- ( instancetype)initWithUIWebView:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:frame];
        [self initializeUIWebView:(UIWebView *)_webView];
    }
    return self;
}
- (void)loadUrl:(NSString *)url{
    
    NSAssert(url.length, @"Error YZWebView loadURL: is not allow nil or empty");
    NSURLRequest *rquest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self loadRequest:rquest];
}
/*! @abstract  requested URL.*/
- (void)loadRequest:(  NSURLRequest *)request{
    SEL selector = NSSelectorFromString(@"loadRequest:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSURLRequest *) = (void *)imp;
            func(_webView, selector,request);
        });
        
    }
}

/*! @abstract Sets the webpage contents and base URL.
 @param string The string to use as the contents of the webpage.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 */
- (void)loadHTMLString:(  NSString *)string baseURL:(NSURL *)baseURL{
    SEL selector = NSSelectorFromString(@"loadHTMLString:baseURL:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSString *,NSURL *) = (void *)imp;
            func(_webView, selector,string,baseURL);
        });
        
    }
}

/*! @abstract Sets the webpage contents and base URL.
 @param data The data to use as the contents of the webpage.
 @param MIMEType The MIME type of the data.
 @param encodingName The data's character encoding name.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 */
- (void)loadData:(  NSData *)data MIMEType:(  NSString *)MIMEType textEncodingName:(  NSString *)textEncodingName baseURL:(  NSURL *)baseURL{
    SEL selector = NSSelectorFromString(@"loadData:MIMEType:textEncodingName:baseURL:");
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL, NSData *,NSString *,NSString *,NSURL *) = (void *)imp;
            func(_webView, selector,data,MIMEType,textEncodingName,baseURL);
        });
        
    }
}

- (void)invokeJavaScript:(NSString *)function{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)_webView;
        [wk evaluateJavaScript:function completionHandler:^(id a, NSError *e)
         {

         }];
    }else{

        [self.context evaluateScript:function];
    }
    
}
- (void)invokeJavaScript:(NSString *)function completionHandler:(void (^ )( id, NSError * error))completionHandler{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)_webView;
        [wk evaluateJavaScript:function completionHandler:^(id a, NSError *e)
         {
             if (completionHandler) {
                 completionHandler(a,e);
             }
         }];
    }else{
        [self.context evaluateScript:function];
    }

}

/*! @abstract Reloads the current page.
 */
- (void)reload{
    [self invokeName:@"reload"];
}
- (void)stopLoading{
    [self invokeName:@"stopLoading"];
}
- (void)goBack{
    [self invokeName:@"goBack"];
}
- (void)goForward{
    [self invokeName:@"goForward"];
}
- (void)invokeName:(NSString *)name{
    SEL selector = NSSelectorFromString(name);
    if ([_webView respondsToSelector:selector]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IMP imp = [_webView methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(_webView, selector);
        });
        
    }
}

#pragma mark - 权限认证受信任代理方法（CA根证书）
-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    DLog(@"Yan -> 验证CA根证书...");
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge previousFailureCount] == 0){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else{
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - <WKWebViewDeleagte> 代理方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    UIViewController *vc = [self fetchVC];
    
    if (vc) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completionHandler) {
                completionHandler();
            }
        }]];
        [vc presentViewController:alert animated:YES completion:NULL];
    }
}
#pragma mark 在发送请求(request)之前，决定是否跳转的代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL decision = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        decision = [self.delegate webView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(YZWebViewNavigationType)navigationAction.navigationType];
    }
    if (!decision) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);// 不允许跳转
        return;
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);// 允许跳转
    }
}
#pragma mark 在收到响应(response)之后，决定是否跳转的代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    DLog(@"%@",navigationResponse.response.URL);
    BOOL decision = YES;
    /*
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        //decision = [self.delegate webView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(YZWebViewNavigationType)navigationAction.navigationType];
    }
    */
    if (!decision) {
        [[UIApplication sharedApplication] openURL:navigationResponse.response.URL];
        decisionHandler(WKNavigationResponsePolicyCancel);// 不允许跳转
        return;
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);// 允许跳转
    }
}

#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:( WKNavigation *)navigation{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}
#pragma mark 当内容开始返回时调用
/*
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    DLog(@"Yan -> 当内容开始返回时调用 : %s", __FUNCTION__);
}
*/
#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    WKWebView *web = (WKWebView *)_webView;
    web.configuration.userContentController = [[WKUserContentController alloc] init];
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerJavascriptName)]) {
        [[self.delegate registerJavascriptName] enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
            [web.configuration.userContentController removeScriptMessageHandlerForName:name];
            [web.configuration.userContentController addScriptMessageHandler:self name:name];
        }];
    }
    if (self.isAllowNativeHelperJS){
        [self registerNativeHelperJS];
    }
    if ([self.delegate respondsToSelector:@selector(webViewDidFinshLoad:)]) {
        [self.delegate webViewDidFinshLoad:self];
    }
}
#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if ( [self.delegate respondsToSelector:@selector(webView:withError:)]) {
        [self.delegate webView:self withError:error];
    }
}
#pragma mark 接收到服务器跳转请求之后调用
/*
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"Yan -> 接收到服务器跳转请求之后调用 : %s", __FUNCTION__);
}
*/
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
        [self invokeIMPFunction:message.body name:message.name];
}

#pragma mark - <UIWebViewDelegate> 代理方法
#pragma mark 在发送请求之前，决定是否跳转的代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
           return  [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:(YZWebViewNavigationType)navigationType];
    }else{
        return YES;
    }
}

#pragma mark 页面开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}
#pragma mark 页面加载完成之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    if ([self.delegate respondsToSelector:@selector(webViewDidFinshLoad:)]) {
        UIWebView *web = (UIWebView *)_webView;
        self.context=[web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        if([self.delegate respondsToSelector:@selector(registerJavascriptName)]){
            [[self.delegate registerJavascriptName] enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
                __weak typeof(self) weakSelf = self;
                self.context[name] = ^(id body){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf invokeIMPFunction:body name:name];
                };
            }];
        }
        if (self.isAllowNativeHelperJS){
            [self registerNativeHelperJS];
        }

        [self.delegate webViewDidFinshLoad:self];
        
    }
}
#pragma mark 页面加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ( [self.delegate respondsToSelector:@selector(webView:withError:)]) {
        [self.delegate webView:self withError:error];
    }
}

#pragma mark - <YZWebViewProgressDelegate> 代理方法
- (void)updateProgress:(NSProgress *)progress webViewProgress:(YZWebViewProress *)webViewProgress{
    if ([self.delegate respondsToSelector:@selector(webView:updateProgress:)]) {
        self.estimatedProgress = progress;
        [self.delegate webView:self updateProgress:progress];
    }
}

#pragma mark - <KVO> 监听方法
- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"estimatedProgress", @"title", nil];
}
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [_webView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}
- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        @try {
            [_webView removeObserver:self forKeyPath:keyPath];
        } @catch (NSException *exception) {
            DLog(@"%d %s %@",__LINE__,__PRETTY_FUNCTION__,[exception description]);
        }
        
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForWKWebView:) withObject:object waitUntilDone:NO];
    } else {
        [self updateUIForWKWebView:object];
    }
}

#pragma mark - <Private> 私有方法
- (void)initialize:(WKWebView *)webView{
    webView.allowsBackForwardNavigationGestures =YES;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    _allowNativeHelperJS = YES;
    [self addSubview:webView];
    [self registerForKVO];
    [self layout];
}
- (void)initializeUIWebView:(UIWebView *)webView{
    _progressProxy = [[YZWebViewProress alloc]init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    webView.delegate = _progressProxy;
    webView.backgroundColor = [UIColor whiteColor];
    _allowNativeHelperJS = YES;
    [self addSubview:webView];
    [self layout];
}
- (void)layout{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //layout 子view
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    [self addConstraints:array];
}
- (UIViewController *)fetchVC{
    UIViewController *result = [UIApplication sharedApplication].keyWindow.rootViewController;
    return result;
}
- (void)registerNativeHelperJS{
    NSString *file = [[NSBundle mainBundle]pathForResource:@"nativehelper" ofType:@"js"];
    if (file) {
        NSString *js = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        [self invokeJavaScript:js];
    }else{
        NSURL *url = [[YZWebView bundleForName:@"YZWebView"] URLForResource:@"nativehelper" withExtension:@"js"];
        NSString *js = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self invokeJavaScript:js];
    }
}
- (void)updateUIForWKWebView:(WKWebView *)web {
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    [progress setCompletedUnitCount:web.estimatedProgress*100];
    if ([self.delegate respondsToSelector:@selector(webView:updateProgress:)]) {
        [self.delegate webView:self updateProgress:progress];
    }
}
- (void)invokeIMPFunction:(id)body name:(NSString *)name{
    NSObject *observe  = [self.delegate registerJavaScriptHandler];
    if (observe) {
        SEL selector;
        BOOL isParameter = YES;
        if ([body isKindOfClass:[NSString class]]) {
            isParameter = ![body isEqualToString:@""];
        }
        if ( isParameter && body) {
            selector = NSSelectorFromString([name stringByAppendingString:@":"]);
        }else{
            selector = NSSelectorFromString(name);
        }
        if ([observe respondsToSelector:selector]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                IMP imp = [observe methodForSelector:selector];
                if (body) {
                    void (*func)(id, SEL, id) = (void *)imp;
                    func(observe, selector,body);
                }else{
                    void (*func)(id, SEL) = (void *)imp;
                    func(observe, selector);
                }
            });
        }
    }
}

#pragma mark - Getter & Setter
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _webView.frame = self.bounds;
}
- (WKWebViewConfiguration *)configuretion{
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc] init];
    configuretion.preferences = [[WKPreferences alloc]init];
    configuretion.preferences.minimumFontSize = 10;
    configuretion.preferences.javaScriptEnabled = true;
    configuretion.processPool = [[WKProcessPool alloc]init];
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    return configuretion;
}
- (NSString *)title{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)_webView;
        return wk.title;
    }else{
        UIWebView *web = (UIWebView *)_webView;
        return [web stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (NSURL *)URL{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)_webView;
        return wk.URL;
    }else{
        UIWebView *web = (UIWebView *)_webView;
        return web.request.URL;
    }
}
- (NSProgress *)estimatedProgress{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)_webView;
        NSProgress *prgress = [NSProgress progressWithTotalUnitCount:100];
        [prgress setCompletedUnitCount:wk.estimatedProgress*100];
        return prgress;
    }else{
        return _estimatedProgress;
    }
}
+ (NSBundle *)bundleForName:(NSString *)bundleName{
    NSString *pathComponent = [NSString stringWithFormat:@"%@.bundle", bundleName];
    NSString *bundlePath =[[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:pathComponent];
    NSBundle *customizedBundle = [NSBundle bundleWithPath:bundlePath];
    return customizedBundle;
    
}
- (void)removeFromSuperview{
    [super removeFromSuperview];
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [self unregisterFromKVO];
    }
}
-(void)dealloc{
}
@end
