/************************************************************
 Class    : AppDelegate.m
 Describe : This is AppDelegate
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-18
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "MainTabBarController.h"
#import "DeviceInfoModel.h"

#import "ViewController.h"
#import "LoginViewController.h"
#import "TouchIDViewController.h"
#import "WUGesturesUnlockViewController.h"
#import "MessageListViewController.h"
#import "MessageDetailViewController.h"
#import "MapListViewController.h"

#import "AppUtil.h"
#import "SettingUtil.h"

#import "BPush.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate () <BMKGeneralDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) MainTabBarController *mainTabBarController;

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 加载完毕后显示顶部状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 判断系统版本是否支持
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"对不起，当前系统版本过低" message:@"请在“设置”-“通用”-“软件更新”中升级您的操作系统至ios8.0以上再使用" delegate:self cancelButtonTitle:@"退出应用" otherButtonTitles: nil];
    alertView.tag = 0;
    [alertView show];
#endif
    
    [self deviceInfo];  // 获取设备基本信息
    [[AppUtil alloc] initAppDataFlag:NO];// 初始化构建应用菜单（写入SandBox中）
    [[SettingUtil alloc] initSettingData];// 初始化默认值的setting数据(写入SandBox)
    
    // BaiduMap 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BMAP_APPKEY generalDelegate:self];
    if (!ret) {
        DLog(@"manager start failed!");
    }
    
    // BaiduPush 注册消息推送服务
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    } else {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BPUSH_APIKEY pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    _window = [[UIWindow alloc] initWithFrame:FRAME_SCREEN];
    _window.backgroundColor = [UIColor clearColor];
    
    _viewController = [[ViewController alloc] init];
    _loginViewController = [[LoginViewController alloc] init];
    _mainTabBarController = [[MainTabBarController alloc] init];
    
    // 获取单例模式中的用户信息自动登录
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        // 若用户开启指纹解锁，进行指纹验证
        NSDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
        if([[settingDict objectForKey:@"touchID"] boolValue]){
            TouchIDViewController *touchIDVC = [[TouchIDViewController alloc] init];
            [_window setRootViewController:touchIDVC];
        }else{
            NSString *gesturePwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturespassword"];
            if(gesturePwd.length > 0){
                WUGesturesUnlockViewController *gesturesUnlockVC= [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeLoginPwd];
                [_window setRootViewController:gesturesUnlockVC];
            }else{
                [_window setRootViewController:_mainTabBarController];
            }
        }
    }else{
        [_window setRootViewController:_mainTabBarController];
        //[_window setRootViewController:_loginViewController];
    }
    
    // App图片添加3DTouch按压方法 ->Start<-
    // type 该item 唯一标识符
    // localizedTitle ：标题
    // localizedSubtitle：副标题
    // icon：icon图标 可以使用系统类型 也可以使用自定义的图片
    // userInfo：用户信息字典 自定义参数，完成具体功能需求
    // 定义 shortcutItem
    //UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    if(nil != userDict){
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Notification"];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"notification" localizedTitle:@"通知公告" localizedSubtitle:@"" icon:icon1 userInfo:nil];
        
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Map"];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"map" localizedTitle:@"办税地图" localizedSubtitle:@"" icon:icon2 userInfo:nil];
        
        UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Contacts"];
        UIApplicationShortcutItem *item3= [[UIApplicationShortcutItem alloc] initWithType:@"contacts" localizedTitle:@"通讯录" localizedSubtitle:@"" icon:icon3 userInfo:nil];
        
        // 将items 添加到app图标
        application.shortcutItems = @[item1,item2,item3];
    }else{
        application.shortcutItems = nil;
    }
    // App图片添加3DTouch按压方法 ->End<-
    
    /*
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        NSString *url = @"loginUser.action";
        
        [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:userDict success:^(NSDictionary *responseDic) {
            // 获取请求状态值
            NSString * responseCode = [responseDic objectForKey:@"repcode"];
            // 判断请求状态：1、表示成功，0、表示失败
            if([responseCode isEqualToString:@"1"]){
                // 登录成功，界面跳转到主页
                [_window setRootViewController:_mainTabBarController];
            }else{
                // 登录失败跳转到登录页
                [_window setRootViewController:_loginViewController];
                NSString *msg = [responseDic objectForKey:@"returnMessage"];
                [YZProgressHUD showHUDView:_loginViewController.view Mode:SHOWMODE Text:msg];
            }
        } failure:^(NSString *error) {
            // 登录失败跳转到登录页
            [_window setRootViewController:_loginViewController];
            [YZProgressHUD showHUDView:_loginViewController.view Mode:SHOWMODE Text:error];
        }];
        [_window setRootViewController:_viewController];
    }else{
        [_window setRootViewController:_loginViewController];
    }
    */
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Notification"];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"item1" localizedTitle:@"通知公告" localizedSubtitle:@"" icon:icon1 userInfo:nil];
        
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Map"];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"item2" localizedTitle:@"办税地图" localizedSubtitle:@"" icon:icon2 userInfo:nil];
        
        UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Contacts"];
        UIApplicationShortcutItem *item3= [[UIApplicationShortcutItem alloc] initWithType:@"item3" localizedTitle:@"通讯录" localizedSubtitle:@"" icon:icon3 userInfo:nil];
        
        // 将items 添加到app图标
        application.shortcutItems = @[item1,item2,item3];
    }else{
        application.shortcutItems = nil;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 3D Touch代理方法
 -(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
     
     _mainTabBarController.selectedIndex = 1;
     [_window setRootViewController:_mainTabBarController];
     UIViewController *touchVC = nil;
     if ([shortcutItem.type isEqualToString:@"item1"]){
         touchVC = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@public/notice/index", SERVER_URL]];
     }
     if ([shortcutItem.type isEqualToString:@"item2"]){
         touchVC = [[MapListViewController alloc] init];
     }
     if ([shortcutItem.type isEqualToString:@"item3"]){
         touchVC = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@litter/initLitter", SERVER_URL]];
     }
     
     if(touchVC != nil){
         [_mainTabBarController.selectedViewController pushViewController:touchVC animated:YES];
     }
     
 }

#pragma mark - Baidu Map SDK
/*
- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        DLog(@"BaiduMap -> 联网成功");
    } else {
        DLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        DLog(@"BaiduMap -> 授权成功");
    } else {
        DLog(@"onGetPermissionState %d",iError);
    }
}
*/

#pragma mark - Baidu Push SDK
// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    completionHandler(UIBackgroundFetchResultNewData);
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
        /*
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        */
        
        // 读取系统设置文件内容(声音/震动)
        NSDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
        BOOL voiceOn = [[settingDict objectForKey:@"voice"] boolValue];
        BOOL shakeOn = [[settingDict objectForKey:@"shake"] boolValue];
        
        if(voiceOn){
            // 调用声音代码
            AudioServicesPlaySystemSound(1007); //其中1007是系统声音的编号，其他的可用编号：
        }
        if(shakeOn){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 调用震动代码
        }
        
        if([userInfo[@"type"] integerValue] == 0){
            UITabBarItem * item = [_mainTabBarController.tabBar.items objectAtIndex:0];
            item.badgeValue = [NSString stringWithFormat:@"%d",1];
        }
        if([userInfo[@"type"] integerValue] == 1){
            UITabBarItem * item = [_mainTabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue = [NSString stringWithFormat:@"%d",1];
            if(_mainTabBarController.selectedIndex == 2){
                MessageListViewController *messageListVC = (MessageListViewController *)[self getCurrentVC];
                [messageListVC autoLoadData];
            }
        }
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        //AppleViewController *skipCtr = [[AppleViewController alloc] initWithURL:@"http://www.qq.com"];
        //[_mainTabBarController.selectedViewController pushViewController:skipCtr animated:YES];
        if([userInfo[@"type"] integerValue] == 0){
            _mainTabBarController.selectedIndex = 0;
            BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:userInfo[@"url"]];
            [_mainTabBarController.selectedViewController pushViewController:webVC animated:YES];
        }
        if([userInfo[@"type"] integerValue] == 1){
            _mainTabBarController.selectedIndex = 2;
        }
    }
    
    DLog(@"Yan -> 输出：%@",userInfo);
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        DLog(@"Yan -> 输出：%@", [NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]);
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            DLog(@"myChannel_id = %@",myChannel_id);
            
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    DLog(@"result ============== %@",result);
                }
            }];
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    DLog(@"设置tag成功");
                }
            }];
        }
    }];
    
    // 打印到日志
    DLog(@"Yan -> 输出：%@", [NSString stringWithFormat:@"Register use deviceToken : %@",deviceToken]);
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    DLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - 获取设备的基本信息并存入NSUserDefaults中
- (void)deviceInfo{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_INFO];
    //DeviceInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //DLog(@"Yan -> model.deviceIdentifier = %@", model.deviceIdentifier);
    
    if(nil == data){
        DLog(@"Yan -> 开始写入设备基本信息");
        DeviceInfoModel *deviceInfoModel = [[DeviceInfoModel alloc] getDeviceInfoModel];
        NSData *deviceInfoData = [NSKeyedArchiver archivedDataWithRootObject:deviceInfoModel];
        [[NSUserDefaults standardUserDefaults] setObject:deviceInfoData forKey:DEVICE_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma makr - alert点击方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // 退出应用
    if(alertView.tag == 0){
        [UIView animateWithDuration:1.0f animations:^{
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0f;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";
            //animation.type = kCATransitionMoveIn;
            animation.subtype = kCATransitionFromBottom;
            [_window.layer addAnimation:animation forKey:nil];
         } completion:^(BOOL finished) {
             exit(0);
         }];
    }
}

#pragma mark - 获取当前展示的视图
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];//  这方法下面有详解
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        // UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
@end
