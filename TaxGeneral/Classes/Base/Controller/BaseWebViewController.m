//
//  BaseWebViewController.m
//  TaxGeneral
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
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
