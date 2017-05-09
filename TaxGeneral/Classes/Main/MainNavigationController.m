/************************************************************
 Class    : MainNavigationController.h
 Describe : 主界面Navigation导航栏
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-17
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;                    // 设置顶部导航栏不透明
    //self.navigationBar.barTintColor = DEFAULT_BLUE_COLOR;   // 设置导航栏的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];    // 设置导航栏ItemBar字体为白色
    //[self.navigationBar setBackgroundImage:[[BaseHandleUtil shareInstance] imageWithColor:DEFAULT_BLUE_COLOR] forBarMetrics:UIBarMetricsDefault];// 设置导航栏背景图
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_navigation_bg" scaleToSize:CGSizeMake(WIDTH_SCREEN, 64)] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setBackgroundImage:[[BaseHandleUtil shareInstance] imageWithColor:DEFAULT_BLUE_COLOR] forBarMetrics:UIBarMetricsDefault];
    

    // 设置导航栏标题颜色
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

// 重写pushViewController:方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];// 隐藏底部TabBar
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
