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
#import "MainTabBarController.h"
#import "DeviceInfoModel.h"

#import "ViewController.h"
#import "MessageListViewController.h"
#import "MessageDetailViewController.h"
#import "MapListViewController.h"

#import "SettingUtil.h"
#import "MapListUtil.h"
#import "MessageListUtil.h"

#import "BPush.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <EventKit/EventKit.h>
#import "Reachability.h"

@interface AppDelegate () <BMKGeneralDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) MainTabBarController *mainTabBarController;

@property (strong, nonatomic) BMKMapManager *mapManager;

@property (nonatomic, strong) CLLocationManager *locationManager;// 定位权限管理器

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 隐藏顶部状态栏设为NO
    // [UIApplication sharedApplication].statusBarHidden = NO;
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置主window视图
    _window = [[UIWindow alloc] initWithFrame:FRAME_SCREEN];
    _window.backgroundColor = [UIColor clearColor];
    
    // 判断系统版本是否支持
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"对不起，当前系统版本过低" message:@"请在iPhone的\"设置-通用-软件更新\"中升级您的操作系统至ios8.0以上再使用。" delegate:self cancelButtonTitle:@"退出应用" otherButtonTitles: nil];
    alertView.tag = 0;
    [alertView show];
#endif
    
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
    // 角标清0
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    [self deviceInfo];  // 获取设备基本信息
    [[SettingUtil alloc] initSettingData];// 初始化默认值的setting数据(写入SandBox)
    [self inspectPermission];// 获取权限（网络访问、定位）
    
    // 初始化地图数据结构，写入SandBox
    [[MapListUtil alloc] loadMapDataBlock:^(NSMutableArray *dataArray) {
        DLog(@"Yan -> 初始化地图Tree数据成功");
    } failed:^(NSString *error) {
        DLog(@"Yan -> 初始化地图Tree数据失败：error = %@", error);
    }];
    
    _viewController = [[ViewController alloc] init];
    _mainTabBarController = [MainTabBarController shareInstance];
    
    [_window setRootViewController:_viewController];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self register3DTouch];// 注册3DTouch方法
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if( nil == userDict){
        // 清除应用角标
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self saveCookies];// 写入cookie
    
    [self register3DTouch];// 注册3DTouch方法
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
         touchVC.title = @"通知公告";
     }
     if ([shortcutItem.type isEqualToString:@"item2"]){
         touchVC = [[MapListViewController alloc] init];
         touchVC.title = @"办税地图";
     }
     if ([shortcutItem.type isEqualToString:@"item3"]){
         touchVC = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@litter/initLitter", SERVER_URL]];
         touchVC.title = @"通讯录";
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
            //UITabBarItem * item = [_mainTabBarController.tabBar.items objectAtIndex:2];
            //item.badgeValue = [NSString stringWithFormat:@"%d",1];
            int badge = [Variable shareInstance].unReadCount + 1;
            [BaseHandleUtil setBadge:badge];
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
            YZWebViewController *webVC = [[YZWebViewController alloc] initWithURL:userInfo[@"url"]];
            webVC.title = @"明细信息";
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
        // 注册BPush成功后，绑定推送设备
        [self registerPushID:result];
        
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

#pragma mark - 权限检查（网络权限、定位权限）
- (void)inspectPermission{
    
    // 检测网络连接
    Reachability *reachability = [Reachability reachabilityWithHostName:SERVER_URL];
    switch([reachability currentReachabilityStatus]){
        case NotReachable:{
            UIAlertView *networkingAlert =[[UIAlertView alloc]initWithTitle:@"没有网络" message:@"请在iPhone的\"设置-无限局域网/蜂窝移动网\"中打开网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            networkingAlert.tag = 1;
            [networkingAlert show];
            DLog(@"没有网络");
            break;
        }
        case ReachableViaWWAN:
            DLog(@"3G/4G");
            break;
        case ReachableViaWiFi:
            DLog(@"Wifi网络");
            break;
    }
    
    // 检测定位权限
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    /*
    // 获取相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
    
    // 获取相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
    
    // 日历权限
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
    */
    
}

#pragma mark - 保存写入cookie
- (void)saveCookies{
    // 初始化完毕存储Cookie(用于自动登录的会话共享)
    NSURL *cookieHost = [NSURL URLWithString:SERVER_URL];
    NSDictionary *propertiesDict = [NSDictionary dictionaryWithObjectsAndKeys:[cookieHost host], NSHTTPCookieDomain, [cookieHost path], NSHTTPCookiePath, @"COOKIE_NAME", NSHTTPCookieName, @"COOKIE_VALUE", NSHTTPCookieValue, nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:propertiesDict];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    // 设置cookie的接受政策
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
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

#pragma mark - 获取BPush推送注册信息,写入BSUserDefaults中
- (void)registerPushID:(NSDictionary *)result{
    NSString *errorCode = [result objectForKey:@"error_code"];
    NSString *appId = [result objectForKey:@"app_id"];
    NSString *userId = [result objectForKey:@"user_id"];
    NSString *channelId = [result objectForKey:@"channel_id"];
    NSString *phoneProduct = @"Apple";
    NSNumber *deviceType = [NSNumber numberWithInt:4];
    
    NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:errorCode, @"errorCode", appId, @"appId", userId, @"userId", channelId, @"channelId", phoneProduct, @"phoneProduct", deviceType, @"deviceType", nil];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_INFO];
    if(nil == data){
        DLog(@"Yan -> 开始写入BPush推送基本信息");
        [[NSUserDefaults standardUserDefaults] setObject:pushDict forKey:PUSH_INFO];
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

#pragma mark - 3DTouch注册
- (void)register3DTouch{
    // App图片添加3DTouch按压方法 ->Start<-
    // type 该item 唯一标识符
    // localizedTitle ：标题
    // localizedSubtitle：副标题
    // icon：icon图标 可以使用系统类型 也可以使用自定义的图片
    // userInfo：用户信息字典 自定义参数，完成具体功能需求
    // 定义 shortcutItem
    //UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    // 获取单例模式中的用户信息自动登录
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Notification"];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"notification" localizedTitle:@"通知公告" localizedSubtitle:@"" icon:icon1 userInfo:nil];
        
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Map"];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"map" localizedTitle:@"办税地图" localizedSubtitle:@"" icon:icon2 userInfo:nil];
        
        UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_Contacts"];
        UIApplicationShortcutItem *item3= [[UIApplicationShortcutItem alloc] initWithType:@"contacts" localizedTitle:@"通讯录" localizedSubtitle:@"" icon:icon3 userInfo:nil];
        
        // 将items 添加到app图标
        
        [UIApplication sharedApplication].shortcutItems = @[item1,item2,item3];
    }else{
        [UIApplication sharedApplication].shortcutItems = nil;
    }
    // App图片添加3DTouch按压方法 ->End<-
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
