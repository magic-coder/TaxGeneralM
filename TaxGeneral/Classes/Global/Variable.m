/************************************************************
 Class    : Variable.m
 Describe : 定义全局变量，该类为单例模式
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-01
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "Variable.h"

@implementation Variable

+(Variable *)shareInstance{
    static Variable *variable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        variable = [[Variable alloc] init];
    });
    return variable;
}

@end
