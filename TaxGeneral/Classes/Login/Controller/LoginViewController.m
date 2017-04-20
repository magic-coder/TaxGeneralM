/************************************************************
 Class    : LoginViewController.m
 Describe : 用户登录视图界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-25
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "LoginViewController.h"
#import "MainTabBarController.h"

#define LABELSIZE CGSizeMake(70, 20)
#define TEXTFIELDSIZE CGSizeMake(180, 30)

typedef NS_ENUM(NSInteger, LoginShowType) {
    LoginShowType_NONE,
    LoginShowType_USER,
    LoginShowType_PASS
};
@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) MainTabBarController *mainTabBarController;

@property (nonatomic, assign) LoginShowType showType;

@property (nonatomic, strong) UIVisualEffectView *smallView;

@property (nonatomic, strong) UIImageView* imgLeftHand;
@property (nonatomic, strong) UIImageView* imgRightHand;

@property (nonatomic, strong) UIImageView* imgLeftHandGone;
@property (nonatomic, strong) UIImageView* imgRightHandGone;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage imageNamed:@"login_bg"];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    // 背景模糊（毛玻璃效果）
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectview.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    [_imageView addSubview:effectview];
    
    // 顶部税徽标志
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-90, 26, 180, 137)];
    titleView.image = [UIImage imageNamed:@"login_emblem"];
    [effectview addSubview:titleView];
    
    //猫头
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 211 / 2, 150-99, 211, 108)];
    imgLogin.image = [UIImage imageNamed:@"login_head_bak"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    //捂眼的左右爪
    _imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(1, 90, 40, 65)];
    _imgLeftHand.image = [UIImage imageNamed:@"login_arm_left_bak"];
    [imgLogin addSubview:_imgLeftHand];
    
    _imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)];
    _imgRightHand.image = [UIImage imageNamed:@"login_arm_right_bak"];
    [imgLogin addSubview:_imgRightHand];
    
    //展开的左右爪
    _imgLeftHandGone = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 150-22, 40, 40)];
    _imgLeftHandGone.image = [UIImage imageNamed:@"login_hand_bak"];
    [self.view addSubview:_imgLeftHandGone];
    
    
    _imgRightHandGone = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 62,  150-22, 40, 40)];
    _imgRightHandGone.image = [UIImage imageNamed:@"login_hand_bak"];
    [self.view addSubview:_imgRightHandGone];
    
    
    _smallView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _smallView.frame = CGRectMake(20, 150, self.view.frame.size.width-40, self.view.frame.size.width-40);
    _smallView.layer.cornerRadius = 5;
    _smallView.layer.masksToBounds = YES;
    [self.view addSubview:_smallView];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, _smallView.frame.size.width-20, 20)];
    self.titleLabel.text = @"用户登录";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [_smallView addSubview:self.titleLabel];
    
    self.usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+15, _smallView.frame.size.width-40, 40)];
    self.usernameTextField.delegate = self;
    self.usernameTextField.layer.cornerRadius = 5;
    self.usernameTextField.layer.borderWidth = .5;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.usernameTextField.placeholder = @"请输入账号";
    self.usernameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.usernameTextField.frame), CGRectGetHeight(self.usernameTextField.frame))];
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"login_username"];
    [self.usernameTextField.leftView addSubview:imgUser];
    //self.usernameTextField.text = @"26100010001";
    [_smallView addSubview:self.usernameTextField];
    
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.usernameTextField.frame), CGRectGetMaxY(self.usernameTextField.frame)+10, CGRectGetWidth(self.usernameTextField.frame), CGRectGetHeight(self.usernameTextField.frame))];
    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.cornerRadius = 5;
    self.passwordTextField.layer.borderWidth = .5;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.passwordTextField.frame), CGRectGetHeight(self.passwordTextField.frame))];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
    imgPwd.image = [UIImage imageNamed:@"login_password"];
    [self.passwordTextField.leftView addSubview:imgPwd];
    //self.passwordTextField.text = @"111";
    [_smallView addSubview:self.passwordTextField];
    
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.passwordTextField.frame)+10, _smallView.frame.size.width-20, 40)];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1]];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_smallView addSubview:self.loginBtn];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.passwordTextField.frame)+60, _smallView.frame.size.width-20, 40)];
    [self.cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    self.cancelBtn.layer.cornerRadius = 5;
    [self.cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_smallView addSubview:self.cancelBtn];
    
    _smallView.frame = CGRectMake(20, 150, self.view.frame.size.width-40, CGRectGetMaxY(self.loginBtn.frame)+15+45);
}

#pragma mark - <UITextFieldDelegate>代理方法
// 捂脸移动动画
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.usernameTextField]) {
        if (_showType != LoginShowType_PASS)
        {
            _showType = LoginShowType_USER;
            return;
        }
        _showType = LoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            _imgLeftHand.frame = CGRectMake(_imgLeftHand.frame.origin.x - 60, _imgLeftHand.frame.origin.y + 30, _imgLeftHand.frame.size.width, _imgLeftHand.frame.size.height);
            
            _imgRightHand.frame = CGRectMake(_imgRightHand.frame.origin.x + 48, _imgRightHand.frame.origin.y + 30, _imgRightHand.frame.size.width, _imgRightHand.frame.size.height);
            
            
            _imgLeftHandGone.frame = CGRectMake(_imgLeftHandGone.frame.origin.x - 70, _imgLeftHandGone.frame.origin.y, 40, 40);
            
            _imgRightHandGone.frame = CGRectMake(_imgRightHandGone.frame.origin.x + 30, _imgRightHandGone.frame.origin.y, 40, 40);
            
            
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:self.passwordTextField]) {
        if (_showType == LoginShowType_PASS)
        {
            _showType = LoginShowType_PASS;
            return;
        }
        _showType = LoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            _imgLeftHand.frame = CGRectMake(_imgLeftHand.frame.origin.x + 60, _imgLeftHand.frame.origin.y - 30, _imgLeftHand.frame.size.width, _imgLeftHand.frame.size.height);
            _imgRightHand.frame = CGRectMake(_imgRightHand.frame.origin.x - 48, _imgRightHand.frame.origin.y - 30, _imgRightHand.frame.size.width, _imgRightHand.frame.size.height);
            
            
            _imgLeftHandGone.frame = CGRectMake(_imgLeftHandGone.frame.origin.x + 70, _imgLeftHandGone.frame.origin.y, 0, 0);
            
            _imgRightHandGone.frame = CGRectMake(_imgRightHandGone.frame.origin.x - 30, _imgRightHandGone.frame.origin.y, 0, 0);
            
        } completion:^(BOOL b) {
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.passwordTextField]) {
        if (_showType == LoginShowType_PASS)
        {
            _showType = LoginShowType_USER;
            [UIView animateWithDuration:0.5 animations:^{
                _imgLeftHand.frame = CGRectMake(_imgLeftHand.frame.origin.x - 60, _imgLeftHand.frame.origin.y + 30, _imgLeftHand.frame.size.width, _imgLeftHand.frame.size.height);
                
                _imgRightHand.frame = CGRectMake(_imgRightHand.frame.origin.x + 48, _imgRightHand.frame.origin.y + 30, _imgRightHand.frame.size.width, _imgRightHand.frame.size.height);
                
                _imgLeftHandGone.frame = CGRectMake(_imgLeftHandGone.frame.origin.x - 70, _imgLeftHandGone.frame.origin.y, 40, 40);
                
                _imgRightHandGone.frame = CGRectMake(_imgRightHandGone.frame.origin.x + 30, _imgRightHandGone.frame.origin.y, 40, 40);
                
            } completion:^(BOOL b) {
            }];
        }
    }
}

//点击空白处隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//登录方法
-(void)loginAction:(UIButton *)sender{
    
    [YZProgressHUD showHUDView:self.view Mode:LOCKMODE Text:@"登录中..."];
    
    NSString *userCode = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    DLog(@"userCode=%@，password=%@",userCode, password);
    
    if(userCode.length > 0 && password.length > 0){

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:userCode forKey:@"userCode"];
        [dict setObject:password forKey:@"password"];
        
        [LoginUtil loginWithAppDict:dict success:^{
            [YZProgressHUD hiddenHUDForView:self.view];
            
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0f;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";
            //animation.type = kCATransitionMoveIn;
            animation.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:animation forKey:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failed:^(NSString *error) {
            [YZProgressHUD hiddenHUDForView:self.view];
            [YZProgressHUD showHUDView:self.view Mode:SHOWMODE Text:error];
        }];
    }else{
        [YZProgressHUD hiddenHUDForView:self.view];
        [YZProgressHUD showHUDView:self.view Mode:SHOWMODE Text:@"用户名、密码不能为空！"];
    }

    [self.view endEditing:YES];
}

// 取消方法
- (void)cancelAction:(UIButton *)sender{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    if(self.isLogin){
        MainTabBarController *mainTabBarController = [MainTabBarController shareInstance];
        mainTabBarController.selectedIndex = [Variable shareInstance].lastSelectedIds;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
