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

@interface BaseWebViewController : YZWebViewController

// js方法注册
@property (nonatomic, strong) NSArray<NSString *> *registerMethod;

@end
