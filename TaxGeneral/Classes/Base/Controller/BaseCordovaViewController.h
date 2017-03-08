/************************************************************
 Class    : BaseCordovaViewController.h
 Describe : 基础Cordova界面视图控制器
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-10
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@interface BaseCordovaViewController : CDVViewController

@property (nonatomic, strong) NSString *pagePath;
@property (nonatomic, strong) NSString *currentTitle;

@end
