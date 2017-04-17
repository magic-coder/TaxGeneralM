/************************************************************
 Class    : ViewController.m
 Describe : 将该视图作为了欢迎页面与LaunchScreen配合使用
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-18
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "ViewController.h"
#import "AppDelegate.h"

#import "MainTabBarController.h"
#import "TouchIDViewController.h"
#import "WUGesturesUnlockViewController.h"
#import "YZCircleProgressButton.h"

#import "SettingUtil.h"
#import "MessageListUtil.h"
#import "AppUtil.h"

@interface ViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) MainTabBarController *mainTabBarController;
@property (nonatomic, strong) YZCircleProgressButton *yzCircleView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeLong;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"launch"];
    imageView.frame = FRAME_SCREEN;
    [self.view addSubview:imageView];
    
    [self initialize];
}

- (void)removeProgress{
    // 指纹验证解锁
    NSDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
    if([[settingDict objectForKey:@"touchID"] boolValue]){
        TouchIDViewController *touchIDVC = [[TouchIDViewController alloc] init];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [_appDelegate.window setRootViewController:touchIDVC];
    }else{
        NSString *gesturePwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturespassword"];
        if(gesturePwd.length > 0){  // 手势验证解锁
            WUGesturesUnlockViewController *gesturesUnlockVC= [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeLoginPwd];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [_appDelegate.window setRootViewController:gesturesUnlockVC];
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [_appDelegate.window setRootViewController:_mainTabBarController];
        }
    }
}

- (void)initialize{
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _mainTabBarController = [MainTabBarController shareInstance];
    
    // 获取单例模式中的用户信息自动登录
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        
        [LoginUtil loginWithTokenSuccess:^{
            DLog(@"Yan -> login成功");
            // 加载app列表
            [[AppUtil alloc] initDataWithType:AppItemsTypeNone dataBlock:^(NSMutableArray *dataArray) {
            } failed:^(NSString *error) {
                DLog(@"初始化应用列表失败error=%@", error);
            }];
            
            // 获取未读条数
            [[MessageListUtil alloc] getMsgUnReadCountSuccess:^(int unReadCount) {
                // 将未读条数存储到全局变量中
                [Variable shareInstance].unReadCount = unReadCount;
                
                [BaseHandleUtil setBadge:unReadCount];
            }];
            
            /*
            // 加载消息列表
            [[MessageListUtil alloc] loadMsgDataWithPageNo:1 pageSize:100 dataBlock:^(NSDictionary *dataDict) {
                NSArray *results = [dataDict objectForKey:@"results"];
                for(NSDictionary *dict in results){
                    _unReadcount = _unReadcount + [[dict objectForKey:@"unreadcount"] intValue];
                }
                
                [BaseHandleUtil setBadge:_unReadcount];
                
            } failed:^(NSString *error) {
                DLog(@"初始化消息列表信息失败error=%@", error);
            }];
            */
        } failed:^(NSString *error) {
            DLog(@"Yan -> login失败 error = %@", error);
        }];
        
        // 添加等待圈
        _yzCircleView = [[YZCircleProgressButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55, 30, 40, 40)];
        _yzCircleView.lineWidth = 2;
        [_yzCircleView setTitle:@"跳过" forState:UIControlStateNormal];
        [_yzCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yzCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
        [_yzCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
        // 倒计时跳过回调
        [_yzCircleView startAnimationDuration:3.0 withBlock:^{
            [self removeProgress];
        }];
        [self.view addSubview:_yzCircleView];
        
    }else{
        // 加载完成后显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [_appDelegate.window setRootViewController:_mainTabBarController];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [BaseHandleUtil setBadge:[Variable shareInstance].unReadCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
