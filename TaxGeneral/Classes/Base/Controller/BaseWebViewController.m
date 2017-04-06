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

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 需要在跳转之前进行操作
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onClickBtn:)];
    
}

- (void)onClickBtn:(UIBarButtonItem *)sender{
    [YZAlertView showBottomTipViewWith:self title:@"url" message:self.webView.URL.absoluteString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回方法的数组，如：@[@"oneMethod", @"twoMethod", @"threeMethod"]
- (NSArray<NSString *> *)registerJavascriptName{
    return _registerMethod;
}

@end
