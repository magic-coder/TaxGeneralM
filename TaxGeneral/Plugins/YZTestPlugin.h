//
//  YZTestPlugin.h
//  TaxGeneral
//
//  Created by Apple on 16/7/18.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface YZTestPlugin : CDVPlugin
-(void)testMethod:(CDVInvokedUrlCommand*)command;
@end
