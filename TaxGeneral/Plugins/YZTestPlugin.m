//
//  YZTestPlugin.m
//  TaxGeneral
//
//  Created by Apple on 16/7/18.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

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
