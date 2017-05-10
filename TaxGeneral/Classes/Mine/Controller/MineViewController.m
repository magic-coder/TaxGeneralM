/************************************************************
 Class    : MineViewController.h
 Describe : 我的界面首页项目内容
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-03
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineViewController.h"
#import "MineUtil.h"

#import "AccountViewController.h"
#import "SafeViewController.h"
#import "ScheduleViewController.h"
#import "ServiceViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
#import "LogViewController.h"

#import "AccountHeaderView.h"

@interface MineViewController () <UINavigationControllerDelegate, AccountHeaderViewDelegate>

@property (nonatomic, strong) BaseWebViewController *webViewController;
@property (nonatomic, strong) AccountHeaderView *headerView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.data = [[MineUtil shareInstance] getMineItems];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];// 去除导航栏底部黑线
    _headerView = [[AccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 160)];
    _headerView.delegate = self;
    
    self.tableView.tableHeaderView = _headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 获取用户名
    NSString *nameText = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS] objectForKey:@"userName"];
    if(nameText.length <= 0){
        nameText = @"未登录";
    }
    _headerView.nameText = nameText;
    
    self.data = [[MineUtil shareInstance] getMineItems];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    /*
    if ([item.title isEqualToString:@"账户管理"]) {
        if([self isLogin]){
            AccountViewController *accountViewController = [[AccountViewController alloc] init];
            viewController = accountViewController;
        }else{
            [self goToLogin];
        }
    }
    */
    if([item.title isEqualToString:@"安全中心"]){
        if([self isLogin]){
            SafeViewController *safeViewController = [[SafeViewController alloc] init];
            viewController = safeViewController;
        }else{
            [self goToLogin];
        }
    }
    if([item.title isEqualToString:@"我的日程"]){
        //ScheduleViewController *scheduleViewController = [[ScheduleViewController alloc] init];
        //viewController = scheduleViewController;
        [YZAlertView showAlertWith:self title:@"我的日程" message:[NSString stringWithFormat:@"\"%@\"想要打开\"日历\"", [Variable shareInstance].appName] callbackBlock:^(NSInteger btnIndex) {
            if(btnIndex == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开", nil];
    }
    if([item.title isEqualToString:@"我的客服"]){
        ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
        viewController = serviceViewController;
    }
    if ([item.title isEqualToString:@"设置"]) {
        if([self isLogin]){
            SettingViewController *settingViewController = [[SettingViewController alloc] init];
            viewController = settingViewController;
        }else{
            [self goToLogin];
        }
    }
    if ([item.title isEqualToString:@"关于"]) {
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        viewController = aboutViewController;
    }
    if ([item.title isEqualToString:@"测试"]) {
        
        [YZActionSheet showActionSheetWithTitle:@"Which logs do you want to see? Pelase choose!" cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Crash Logs" otherButtonTitles:@[@"Runtime Logs"] handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(index == -1){
                LogViewController *logViewController = [[LogViewController alloc] init];
                logViewController.log = [Variable shareInstance].crashLog;
                logViewController.title = @"Crash Logs";
                [self.navigationController pushViewController:logViewController animated:YES];
            }
            if(index == 1){
                LogViewController *logViewController = [[LogViewController alloc] init];
                logViewController.log = [Variable shareInstance].runtimeLog;
                logViewController.title = @"Runtime Logs";
                [self.navigationController pushViewController:logViewController animated:YES];
            }
        }];
        
    }
    
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <AccountHeaderViewDelegate>代理方法
- (void)accountHeaderViewDidSelectedInfo{
    if([self isLogin]){
        AccountViewController *accountViewController = [[AccountViewController alloc] init];
        accountViewController.title = @"账户管理";
        [self.navigationController pushViewController:accountViewController animated:YES];
    }else{
        [self goToLogin];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect = _headerView.imageView.frame;
        rect.origin.y = offset.y;
        rect.size.height = 160 - offset.y;
        _headerView.imageView.frame = rect;
    }
}

#pragma mark - 判断是否登录，及跳转登录
#pragma mark 判断是否登录了
-(BOOL)isLogin{
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 跳转至登录页面
-(void)goToLogin{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - <UINavigationControllerDelegate>代理方法（隐藏导航栏）
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowPage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowPage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
