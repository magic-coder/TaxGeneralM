//
//  BaseWebViewController.h
//  TaxGeneral
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "YZWebViewController.h"

@interface BaseWebViewController : YZWebViewController

// js方法注册
@property (nonatomic, strong) NSArray<NSString *> *registerMethod;

@end
