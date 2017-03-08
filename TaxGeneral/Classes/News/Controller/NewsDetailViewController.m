//
//  NewsDetailViewController.m
//  TaxGeneral
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    _scrollView.backgroundColor = [UIColor redColor];
    // 是否支持滑动最顶端
    // _scrollView.scrollsToTop = NO;
    // _scrollView.delegate = self;
    // 设置内容大小
    _scrollView.contentSize = CGSizeMake(WIDTH_SCREEN, HEIGHT_SCREEN);
    // 是否反弹
    // scrollView.bounces = NO;
    // 是否分页
    // scrollView.pagingEnabled = YES;
    // 是否滚动
    // scrollView.scrollEnabled = NO;
    // scrollView.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    // scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    // scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    // scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [_scrollView flashScrollIndicators];
    // 是否同时运动,lock
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"学习scrolleview";
    [_scrollView addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
