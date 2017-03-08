//
//  ModifyPwdViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/7.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@property (nonatomic, strong) BaseScrollView *scrollView;   // 基本的滚动视图

@property (nonatomic, strong) UILabel *oLabel; // 旧密码标签
@property (nonatomic, strong) UILabel *nLabel; // 新密码标签
@property (nonatomic, strong) UILabel *rLabel; // 确认新密码标签

@property (nonatomic, strong) BaseTextField *oPwdTextField; // 旧密码文本框
@property (nonatomic, strong) BaseTextField *nPwdTextField; // 新密码文本框
@property (nonatomic, strong) BaseTextField *rPwdTextField; // 确认新密码文本框

@property (nonatomic, strong) UIButton *confirmBtn; // 确认按钮

@end

@implementation ModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    _scrollView = [[BaseScrollView alloc] init];
    
    _oLabel = [self labelWithFrame:CGRectMake(10, 20, WIDTH_SCREEN, 20) text:@"旧密码："];
    [_scrollView addSubview:_oLabel];
    
    _oPwdTextField = [self feildWithFrame:CGRectMake(0, 45, WIDTH_SCREEN, 40)];
    [_scrollView addSubview:_oPwdTextField];
    
    _nLabel = [self labelWithFrame:CGRectMake(10, 90, WIDTH_SCREEN, 20) text:@"新密码："];
    [_scrollView addSubview:_nLabel];
    
    _nPwdTextField = [self feildWithFrame:CGRectMake(0, 115, WIDTH_SCREEN, 40)];
    [_scrollView addSubview:_nPwdTextField];
    
    _rLabel = [self labelWithFrame:CGRectMake(10, 160, WIDTH_SCREEN, 20) text:@"确认密码："];
    [_scrollView addSubview:_rLabel];
    
    _rPwdTextField = [self feildWithFrame:CGRectMake(0, 185, WIDTH_SCREEN, 40)];
    [_scrollView addSubview:_rPwdTextField];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.frame = CGRectMake(15, 255, WIDTH_SCREEN-30, 40);
    _confirmBtn.backgroundColor = [UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1];
    [_confirmBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [_confirmBtn setTintColor:[UIColor whiteColor]];
    _confirmBtn.layer.cornerRadius = 5;// 圆角处理
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_confirmBtn];
    
    [self.view addSubview:_scrollView];
}

- (void)confirmBtnClick:(UIButton *)sender{
    NSString *oPwd = _oPwdTextField.text;
    NSString *nPwd = _nPwdTextField.text;
    NSString *rPwd = _rPwdTextField.text;
    
    [YZAlertView showTipAlertViewWith:self title:nil message:[NSString stringWithFormat:@"获取输入框的值为：\n 旧密码：%@,\n 新密码：%@,\n 确认密码：%@", oPwd, nPwd, rPwd] buttonTitle:@"关闭" buttonStyle:YZAlertActionStyleDefault];
}

#pragma mark - 创建基本的标签样式
- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor grayColor];
    label.text = text;
    return label;
}

#pragma mark - 创建基本的文本输入框
-(BaseTextField *)feildWithFrame:(CGRect)frame{
    BaseTextField *baseTextFeild = [[BaseTextField alloc] initWithFrame:frame];
    baseTextFeild.secureTextEntry = YES;
    baseTextFeild.placeholder = @"6-16个字符，区分大小写";
    return baseTextFeild;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
