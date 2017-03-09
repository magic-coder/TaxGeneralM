//
//  MineViewController.m
//  TaxGeneral
//
//  Created by Apple on 16/8/3.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "MineViewController.h"
#import "MineUtil.h"

#import "LoginViewController.h"

#import "AccountViewController.h"
#import "SafeViewController.h"
#import "ScheduleViewController.h"
#import "ServiceViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"

@interface MineViewController ()

@property (nonatomic, strong) BaseWebViewController *webViewController;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.data = [MineUtil getMineItems];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    if ([item.title isEqualToString:@"账户管理"]) {
        if([self isLogin]){
            AccountViewController *accountViewController = [[AccountViewController alloc] init];
            viewController = accountViewController;
        }else{
            [self goToLogin];
        }
    }
    if([item.title isEqualToString:@"安全中心"]){
        if([self isLogin]){
            SafeViewController *safeViewController = [[SafeViewController alloc] init];
            viewController = safeViewController;
        }else{
            [self goToLogin];
        }
    }
    if([item.title isEqualToString:@"我的日程"]){
        ScheduleViewController *scheduleViewController = [[ScheduleViewController alloc] init];
        viewController = scheduleViewController;
    }
    if([item.title isEqualToString:@"我的客服"]){
        ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
        viewController = serviceViewController;
    }
    if ([item.title isEqualToString:@"设置"]) {
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        viewController = settingViewController;
    }
    if ([item.title isEqualToString:@"关于"]) {
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        viewController = aboutViewController;
    }
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
