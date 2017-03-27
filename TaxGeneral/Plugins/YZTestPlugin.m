/************************************************************
 Class    : YZTestPlugin.m
 Describe : Cordova自定义插件类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-24
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZTestPlugin.h"

@implementation YZTestPlugin
-(void)testMethod:(CDVInvokedUrlCommand *)command{
    CDVPluginResult* pluginResult = nil;
    NSString* arg = [command.arguments objectAtIndex:0];
    DLog(@"Yan -> arg = %@", arg);
    if (arg != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
