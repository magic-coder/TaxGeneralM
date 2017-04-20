/************************************************************
 Class    : TouchIDViewController.m
 Describe : 用户指纹解锁视图界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "TouchIDViewController.h"
#import "YZTouchID.h"

#import "MainTabBarController.h"

@interface TouchIDViewController ()

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton setBackgroundImage:[UIImage imageNamed:@"finger_print_locked"] forState:UIControlStateNormal];
    [touchIDButton addTarget:self action:@selector(touchVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width / 2) - 40, (self.view.frame.size.height / 2) - 60, 80, 80);
    [self.view addSubview:touchIDButton];
    
    UILabel *touchIDLabel = [[UILabel alloc] init];
    touchIDLabel.frame = CGRectMake((self.view.frame.size.width / 2) - 60, (self.view.frame.size.height / 2)+30, 120, 30);
    touchIDLabel.textAlignment = NSTextAlignmentCenter;
    touchIDLabel.text = @"点击唤醒指纹验证";
    touchIDLabel.font = [UIFont systemFontOfSize:13.0f];
    touchIDLabel.textColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:touchIDLabel];
    
    [self touchVerification];
}

#pragma mark - 验证TouchID
- (void)touchVerification {
    
    YZTouchID *touchID = [[YZTouchID alloc] init];
    
    [touchID td_showTouchIDWithDescribe:nil BlockState:^(YZTouchIDState state, NSError *error) {
        
        if (state == YZTouchIDStateNotSupport) {    //不支持TouchID
            
            [YZAlertView showAlertWith:self title:nil message:@"对不起，当前设备不支持指纹" callbackBlock:^(NSInteger btnIndex) {
            } cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles: nil];
            
        } else if(state == YZTouchIDStateTouchIDLockout){ // 多次指纹错误被锁定
            
            [YZAlertView showAlertWith:self title:nil message:@"多次错误，指纹已被锁定，请到手机解锁界面输入密码！" callbackBlock:^(NSInteger btnIndex) {
            } cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil];
            
        } else if (state == YZTouchIDStateSuccess) {    //TouchID验证成功
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
