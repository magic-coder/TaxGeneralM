/************************************************************
 Class    : BaseWebViewController.h
 Describe : 基本的WebView视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-18
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface BaseWebViewController () <UIWebViewDelegate, NSURLConnectionDataDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *imagesViewBG;     // 等待界面视图
@property (nonatomic, strong) UILabel *loadLabel;       // 加载等待文字
@property (nonatomic, strong) UIWebView *webViewBG;     // 加载等待GIF图

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

// 计算时间
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeLong;

@end

@implementation BaseWebViewController

- (instancetype)initWithURL:(NSString *)url{
    if (self = [super init]) {
        _url = [NSURL URLWithString:url];
    }
    return self;
}
- (instancetype)initWithFile:(NSString *)url{
    if (self = [super init]) {
        _url = [NSURL fileURLWithPath:url];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 需要在跳转之前进行操作
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightItemClick:)];
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    
    [self addLeftButton];
    
    [self showLoadingView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    _timeLong = 0;
}

#pragma mark - <UIWebViewDelegate> 代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *scheme = [[request URL] scheme];
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
#pragma mark 加载完执行方法（设置webView的title为导航栏的title）
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.timer invalidate];
    self.timer = nil;
    _timeLong = 0;
    
    [_imagesViewBG removeFromSuperview];
    
    if(self.title == nil || [self.title isEqualToString:@""]){
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }
    
    // 加载完成后注入js
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    "window.scrollBy(0, 0);";
    [self.context evaluateScript:injectionJSString];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}
#pragma mark - <NSURLConnectionDelegate> 代理方法
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }else{
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self showLoadingFailedView];
    //[YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:[NSString stringWithFormat:@"网络连接异常！error.code=%ld", error.code]];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.isAuthed = YES;
    
    // 如果响应的地址是指定域名，则允许跳转
    if ([response.URL.absoluteString rangeOfString:@"account/initLogin"].location != NSNotFound) {
        // 启动/挂起恢复时进行登录操作
        [[LoginUtil shareInstance] loginWithTokenSuccess:^{
            [self.webView loadRequest:self.request];
        } failed:^(NSString *error) {
            [YZAlertView showAlertWith:self title:@"登录失效" message:@"您当前登录信息已失效，请重新登录！" callbackBlock:^(NSInteger btnIndex) {
                // 注销方法
                [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"注销中..."];
                [[AccountUtil shareInstance] accountLogout:^{
                    DLog(@"用户注销成功");
                    [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                    
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
                } failed:^(NSString *error) {
                    DLog(@"用户注销失败，error=%@", error);
                    [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                    [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
                }];
                
            } cancelButtonTitle:@"重新登录" destructiveButtonTitle:nil otherButtonTitles: nil];
        }];
    }else{
        [self.webView loadRequest:self.request];
    }
    [connection cancel];
    
}

#pragma mark - 设置加载等待动画界面
- (void)showLoadingView{
    // 添加等待背景视
    /*
    NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"dropdown_loading_01"], [UIImage imageNamed:@"dropdown_loading_02"], [UIImage imageNamed:@"dropdown_loading_03"], nil];
    
    _imagesView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frameWidth/2-50, 30, 100, 100)];
    _imagesView.animationImages = imagesArray; //动画图片数组
    _imagesView.animationDuration = 0.5; //执行一次完整动画所需的时长
    // _imagesView.animationRepeatCount = 0;  //动画重复次数 0表示无限次，默认为0
    [_imagesView startAnimating];
    */
    
    _imagesViewBG = [[UIView alloc] initWithFrame:self.view.frame];
    _imagesViewBG.backgroundColor = [UIColor whiteColor];
    _imagesViewBG.userInteractionEnabled = NO;
    
    // 提示文字
    _loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frameHeight/2-104, self.view.frameWidth, 20)];
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    _loadLabel.textColor = WBColor(169.0, 183.0, 183.0, 1.0f);
    _loadLabel.font = [UIFont systemFontOfSize:14.0f];
    _loadLabel.numberOfLines = 0;
    _loadLabel.text = @"努力加载中...";
    [_imagesViewBG addSubview:_loadLabel];
    
    // 添加加载等待图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:filePath];
    _webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.frameWidth/2-50, self.view.frameHeight/2-74, 100, 20)];
    NSURL *baseUrl = nil;
    [_webViewBG loadData:gifData MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:baseUrl];
    _webViewBG.userInteractionEnabled = NO;
    [_imagesViewBG addSubview:_webViewBG];
    
    [self.view addSubview:_imagesViewBG];
}

#pragma mark - 设置加载失败界面
- (void)showLoadingFailedView{
    // 移除现有组件
    [_loadLabel removeFromSuperview];
    [_webViewBG removeFromSuperview];
    
    // 重置背景颜色
    _imagesViewBG.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    // 加载失败图片
    UIImageView *imagesView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frameWidth/2-40, 100, 80, 80)];
    imagesView.image = [UIImage imageNamed:@"loading_failed"];
    [_imagesViewBG addSubview:imagesView];
    
    // 提示文字
    UILabel *failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imagesView.frame)+10, self.view.frameWidth, 40)];
    failedLabel.textAlignment = NSTextAlignmentCenter;
    failedLabel.textColor = [UIColor lightGrayColor];
    failedLabel.font = [UIFont systemFontOfSize:15.0f];
    failedLabel.numberOfLines = 0;
    failedLabel.text = @"呃，页面加载失败了！\n 请检查网络是否正常，并退出后重新尝试！";
    [_imagesViewBG addSubview:failedLabel];
    
    [self.view addSubview:_imagesViewBG];
    
}

#pragma mark - 添加关闭按钮
- (void)addLeftButton{
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)timerCallback{
    _timeLong ++;
    DLog(@"进入Timer - > 次数:%ld",_timeLong);
    if(_timeLong == 100){
        
        [self showLoadingFailedView];
        
        [self.timer invalidate];
        self.timer = nil;
        _timeLong = 0;
    }
}

#pragma mark - 点击返回的方法
- (void)backNative{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        //self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}
#pragma mark - 关闭H5页面，直接回到原生页面
- (void)closeNative{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重写Getter方法
- (NSMutableURLRequest *)request{
    if (!_request) {
        // 设置请求超时时间为10秒
        //_request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        
        // 对request中携带cookie进行请求
        _request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.f];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        NSDictionary *cookieHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [_request setHTTPShouldHandleCookies:YES];
        [_request setAllHTTPHeaderFields:cookieHeader];
    }
    return _request;
}

- (UIWebView *)webView{
    if(_webView == nil){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, self.view.frameHeight-HEIGHT_STATUS-HEIGHT_NAVBAR)];
        
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
    }
    return _webView;
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"back_arrow"];
        UIImage *imageHL = [UIImage imageNamed:@"back_arrowHL"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:imageHL forState:UIControlStateHighlighted];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        //[btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.frame = CGRectMake(0, 0, 50, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        _closeItem.tintColor = [UIColor whiteColor];
    }
    return _closeItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
