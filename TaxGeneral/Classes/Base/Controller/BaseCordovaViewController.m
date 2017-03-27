/************************************************************
 Class    : BaseCordovaViewController.h
 Describe : 基础Cordova界面视图控制器
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-10
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseCordovaViewController.h"

@interface BaseCordovaViewController ()//<UIWebViewDelegate>

@end

@implementation BaseCordovaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.webView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    self.title = _currentTitle;
    //[YZProgressHUD showHUDView:NAV_VIEW Mode:LOCKMODE Text:@"加载中..."];
}

/*
#pragma mark - <UIWebViewDelegate>代理方法
#pragma mark 在webView加载完毕时调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [YZProgressHUD hiddenHUDForView:self.view];
    
    NSString *title = nil;
    if(_currentTitle == nil){
        title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }else{
        title = _currentTitle;
    }
    self.title = title;
}

#pragma mark 在webView加载失败出错时调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [YZProgressHUD hiddenHUDForView:self.view];
}
*/

#pragma mark - 重写pagePath的setter方法
- (void)setPagePath:(NSString *)pagePath{
    if(pagePath == nil){
        _pagePath = @"index.html";
    }else{
        //_pagePath = [NSString stringWithFormat:@"app/html/%@", pagePath];
        _pagePath = [NSString stringWithFormat:@"app/demo/html/%@", pagePath];
    }
    self.startPage = _pagePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
