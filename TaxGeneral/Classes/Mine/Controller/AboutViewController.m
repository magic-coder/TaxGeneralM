//
//  AboutViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    
    BaseScrollView *scrollView = [[BaseScrollView alloc] init];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-30, 30, 60, 60)];
    logoImageView.image = [UIImage imageNamed:@"about_logo"];
    [scrollView addSubview:logoImageView];
    
    //第一步，让label铺满整个scrollView显示的区域
    UILabel *infoLabel = [self labelWithFrame:CGRectMake(0, 120, scrollView.frame.size.width, 20)];
    infoLabel.text = @"互联网+税务 iPhone客户端 V1.0";
    [scrollView addSubview:infoLabel];
    
    UILabel *desLabel = [self labelWithFrame:CGRectMake(20, 160, scrollView.frame.size.width-40, 60)];
    desLabel.text = @"互联网+税务 平台分为三个版本分别是：管理端、企业端、自然人端，该app是为税务干部及纳税人提供便捷服务的应用程序，其中包含了办税地图、全局通讯录、税企文化、会议通知、运维监控、网络云盘等一系列的个性化便捷的功能。";
    [scrollView addSubview:desLabel];
    
    [self.view addSubview:scrollView];
    
}

#pragma mark - 创建基本通用样式的Label
- (UILabel *)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    label.font = [UIFont systemFontOfSize:13.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
