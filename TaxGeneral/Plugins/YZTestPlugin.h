/************************************************************
 Class    : YZTestPlugin.h
 Describe : Cordova自定义插件类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-24
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "Cordova/CDVPlugin.h"

@interface YZTestPlugin : CDVPlugin
-(void)testMethod:(CDVInvokedUrlCommand*)command;
@end
