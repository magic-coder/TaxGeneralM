/************************************************************
 Class    : MainTabBarController.h
 Describe : 主界面TabBar添加各个视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-28
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@protocol MainTabBarControllerDelegate <NSObject>

- (void)autoRefreshData;    // 自动刷新代理方法

@end

@interface MainTabBarController : UITabBarController

@property (nonatomic, weak) id<MainTabBarControllerDelegate> customDelegate;

@end
