//
//  TestWebViewController.m
//  TaxGeneral
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "TestWebViewController.h"
#import "AppleViewController.h"

@interface TestWebViewController ()

@end

@implementation TestWebViewController

-(void)loginMethod:(NSDictionary *)dict{
    DLog(@"loginMethod : %@", dict);
    AppleViewController *appleWebVC = [[AppleViewController alloc] initWithURL:@"http://www.apple.com"];
    [self.navigationController pushViewController:appleWebVC animated:YES];
}
-(void)registerMethod:(NSDictionary *)dict{
    DLog(@"registerMethod : %@", dict);
    AppleViewController *appleWebVC = [[AppleViewController alloc] initWithURL:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"];
    [self.navigationController pushViewController:appleWebVC animated:YES];
}
-(void)changeMethod{
    DLog(@"changeMethod");
    AppleViewController *appleWebVC = [[AppleViewController alloc] initWithURL:@"https://www.icloud.com"];
    [self.navigationController pushViewController:appleWebVC animated:YES];
}
-(void)testMethod:(NSDictionary *)dict{
    DLog(@"testMethod : %@", dict);
    AppleViewController *appleWebVC = [[AppleViewController alloc] initWithURL:@"https://192.168.30.233:7103/test/"];
    [self.navigationController pushViewController:appleWebVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerMethod = @[@"loginMethod", @"registerMethod", @"changeMethod", @"testMethod"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
