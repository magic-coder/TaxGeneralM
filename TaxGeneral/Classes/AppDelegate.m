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

#import "MessageListViewController.h"
#import "NewsListViewController.h"

#import "SettingUtil.h"
#import "MapListUtil.h"
#import "AppUtil.h"
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

@interface AppDelegate () <BMKGeneralDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *splashView;  // 欢迎页动画效果
@property (nonatomic, strong) MainTabBarController *mainTabBarController;

@property (strong, nonatomic) BMKMapManager *mapManager;

@property (nonatomic, strong) CLLocationManager *locationManager;// 定位权限管理器

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
        
    // 初始化log日志信息(目前只记录上次运行日志，不然记录太多)
    [Variable shareInstance].runtimeLog = [[[BaseSandBoxUtil shareInstance] loadDataWithFileName:@"runtimeLog.plist"] objectForKey:@"runtimeLog"]; // 运行时日志
    [Variable shareInstance].crashLog = [[[BaseSandBoxUtil shareInstance] loadDataWithFileName:@"crashLog.plist"] objectForKey:@"crashLog"];   // 崩溃日志
    
    
    // 隐藏顶部状态栏设为NO
    //[UIApplication sharedApplication].statusBarHidden = NO;
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置主window视图
    _window = [[UIWindow alloc] initWithFrame:FRAME_SCREEN];
    _window.backgroundColor = [UIColor clearColor];
    
    // 判断系统版本是否支持
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *supportAlert =[[UIAlertView alloc]initWithTitle:@"对不起，当前系统版本过低" message:@"请在iPhone的\"设置-通用-软件更新\"中升级您的操作系统至ios8.0以上再使用。" delegate:self cancelButtonTitle:@"退出应用" otherButtonTitles: nil];
    supportAlert.tag = 0;
    [supportAlert show];
#endif
    
    // BaiduMap 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BMAP_APPKEY generalDelegate:self];
    if (!ret) {
        RLog(@"Yan -> BaiduMapManager Start Failed!");
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
    [BPush registerChannel:launchOptions apiKey:BPUSH_APIKEY pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"taxPush" useBehaviorTextInput:YES isDebug:YES];
    
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
    
    [self checkUpdates];    // 获取服务器版本信息
    [self deviceInfo];  // 获取设备基本信息
    [[SettingUtil shareInstance] initSettingData];// 初始化默认值的setting数据(写入SandBox)
    [self inspectPermission];// 获取权限（网络访问、定位）
    
    // 初始化地图数据结构，写入SandBox
    [[MapListUtil shareInstance] loadMapDataBlock:^(NSMutableArray *dataArray) {
        DLog(@"Yan -> 初始化地图Tree数据成功");
    } failed:^(NSString *error) {
        RLog(@"Yan -> 初始化地图Tree数据失败：error = %@", error);
    }];
    
    //_viewController = [[ViewController alloc] init];
    //_mainTabBarController = [MainTabBarController shareInstance];
    //[_window setRootViewController:_viewController];
    
    _mainTabBarController = [MainTabBarController shareInstance];
    _mainTabBarController.view.userInteractionEnabled = NO;// 加载期间不允许永不与视图交互
    
    [_window setRootViewController:_mainTabBarController];
    // 若用户登录则进行初始化登录数据
    [self loginInitialize];
    
    [_window makeKeyAndVisible];
    
    // 添加欢迎页动画效果
    [self welcomeView];
    
    // 记录Crash信息
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // 进入后台
    //[self register3DTouch];// 注册3DTouch方法
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if( nil == userDict){
        // 清除应用角标
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    if([[settingDict objectForKey:@"night"] boolValue]){
        [[UIScreen mainScreen] setBrightness:[Variable shareInstance].brightness];
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 应用已经进入后台
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timerCallback) userInfo:nil repeats:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // 应用激活
    
    [self saveCookies];// 写入cookie
    
    //[self register3DTouch];// 注册3DTouch方法
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 进入前台
    
    if([self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    if([[settingDict objectForKey:@"night"] boolValue]){
        [[UIScreen mainScreen] setBrightness:0];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 即将杀掉进程
    
    [[BaseHandleUtil shareInstance] writeLogsToFile];
    // 写入夜间(护眼)模式为NO
    NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    [settingDict setObject:[NSNumber numberWithBool:NO] forKey:@"night"];
    [[SettingUtil shareInstance] writeSettingData:settingDict];
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
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
        /*
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        */
        
        // 读取系统设置文件内容(声音/震动)
        NSDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
        BOOL voiceOn = [[settingDict objectForKey:@"voice"] boolValue];
        BOOL shakeOn = [[settingDict objectForKey:@"shake"] boolValue];
        
        if(voiceOn){
            // 调用声音代码
            AudioServicesPlaySystemSound(1007); //其中1007是系统声音的编号，其他的可用编号：
        }
        if(shakeOn){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 调用震动代码
        }
        
        int badge = [Variable shareInstance].unReadCount + 1;
        [[BaseHandleUtil shareInstance] setBadge:badge];
        if(_mainTabBarController.selectedIndex == 2){
            MessageListViewController *messageListVC = (MessageListViewController *)[[BaseHandleUtil shareInstance] getCurrentVC];
            [messageListVC autoLoadData];
        }
        
    }
    else {  // 杀死状态下 或者后台开启状态下，直接跳转到跳转页面。
        
        int badge = [Variable shareInstance].unReadCount + 1;
        [[BaseHandleUtil shareInstance] setBadge:badge];
        
        _mainTabBarController.selectedIndex = 2;
        if([userInfo[@"url"] length] > 0){
            BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:userInfo[@"url"]];
            if([userInfo[@"sourceCode"] isEqualToString:@"01"]){
                webVC.title = @"用户推送";
            }
            if([userInfo[@"sourceCode"] isEqualToString:@"02"]){
                webVC.title = @"会议通知";
            }
            [_mainTabBarController.selectedViewController pushViewController:webVC animated:YES];
        }else{
            MessageListViewController *messageListVC = (MessageListViewController *)[[BaseHandleUtil shareInstance] getCurrentVC];
            [messageListVC autoLoadData];
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
            DLog(@"Yan -> BPush : myChannel_id = %@",myChannel_id);
            
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    DLog(@"Yan -> BPush : result ============== %@",result);
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
    RLog(@"Yan -> DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    DLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
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

#pragma mark - 权限检查（网络权限、定位权限）
- (void)inspectPermission{
    
    // 检测网络连接
    Reachability *reachability = [Reachability reachabilityWithHostName:SERVER_URL];
    switch([reachability currentReachabilityStatus]){
        case NotReachable:{
            RLog(@"没有网络");
            UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"没有网络" message:@"请在iPhone的\"设置-无限局域网/蜂窝移动网\"中打开网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            noNetworkAlert.tag = 1;
            [noNetworkAlert show];
            break;
        }
        case ReachableViaWWAN:
            RLog(@"3G/4G");
            break;
        case ReachableViaWiFi:
            RLog(@"Wifi网络");
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
     DLog(@"Authorized");
     }else{
     DLog(@"Denied or Restricted");
     }
     }];
     
     // 获取相册权限
     [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
     if (status == PHAuthorizationStatusAuthorized) {
     DLog(@"Authorized");
     }else{
     DLog(@"Denied or Restricted");
     }
     }];
     
     // 日历权限
     EKEventStore *store = [[EKEventStore alloc]init];
     [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
     if (granted) {
     DLog(@"Authorized");
     }else{
     DLog(@"Denied or Restricted");
     }
     }];
     */
    
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

#pragma mark - 3DTouch方法注册
/*
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
*/
#pragma mark - 3D Touch代理方法
/*
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
 */

#pragma mark - 获取是否更新标志
- (void)checkUpdates{

    NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:@{@"deviceType" : @"4"}];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
    
    NSString *url = @"appManager/getVersion";
    [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
        if([[responseDic objectForKey:@"CHECKUPDATES"] isEqualToString:@"Y"]){
            [Variable shareInstance].isUpdates = YES;
        }else{
            [Variable shareInstance].isUpdates = NO;
        }
    } failure:^(NSString *error) {
        RLog(@"Yan -> 获取检测标志失败 error : %@", error);
    }];
}

#pragma mark - 登录用户初始化数据
- (void)loginInitialize{
    // 加载完毕写入加载标志
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:LOAD_FINISH];
    [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
    
    // 获取单例模式中的用户信息自动登录
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        
        // 登录用户加载数据
        [[LoginUtil shareInstance] loginWithTokenSuccess:^{
            DLog(@"Yan -> login成功");
            // 加载app列表
            [[AppUtil shareInstance] initDataWithType:AppItemsTypeNone dataBlock:^(NSMutableArray *dataArray) {
            } failed:^(NSString *error) {
                RLog(@"Yan -> 初始化应用列表失败 error = %@", error);
            }];
            
            // 获取未读条数
            [[MessageListUtil shareInstance] getMsgUnReadCountSuccess:^(int unReadCount) {
                // 将未读条数存储到全局变量中
                [Variable shareInstance].unReadCount = unReadCount;
                [[BaseHandleUtil shareInstance] setBadge:unReadCount];
            }];
            
        } failed:^(NSString *error) {
            RLog(@"Yan -> login失败 error = %@", error);
        }];
        
        // 判断推送是否绑定成功
        BOOL registerPush = [[[NSUserDefaults standardUserDefaults] objectForKey:REGISTER_PUSH] boolValue];
        if(registerPush){
            // 绑定推送设备
            NSDictionary *pushDict = [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_INFO];
            if(nil != pushDict){
                NSString *jsonString = [[BaseHandleUtil shareInstance] dataToJsonString:pushDict];
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
                NSString *url = @"push/registerPush";
                [[YZNetworkingManager shareInstance] requestMethod:POST url:url parameters:parameters success:^(NSDictionary *responseDic) {
                    // 绑定成功删除标志推送注册标志
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_PUSH];
                    DLog(@"Yan -> 绑定推送设备信息成功：responseDic = %@", responseDic);
                } failure:^(NSString *error) {
                    // 绑定失败设置注册推送为YES
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:REGISTER_PUSH];
                    [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
                    RLog(@"Yan -> 绑定推送设备信息失败：error = %@", error);
                }];
            }
        }
        
    }
}

#pragma mark - 添加欢迎动画效果页
- (void)welcomeView{
    _splashView = [[UIImageView alloc] initWithFrame:FRAME_SCREEN];
    [_splashView setImage:[UIImage imageNamed:@"launch"]];
    [_window addSubview:_splashView];
    [_window bringSubviewToFront:_splashView];
    
    [self performSelector:@selector(launch_1) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(launch_2) withObject:nil afterDelay:1.5f];
    [self performSelector:@selector(launch_3) withObject:nil afterDelay:2.5f];
    [self performSelector:@selector(launch_last) withObject:nil afterDelay:3.5f];
}

#pragma mark - 欢迎页动态方法
- (void)launch_1{
    UIImageView *round_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, (int)HEIGHT_SCREEN*0.48, WIDTH_SCREEN, (int)239*(WIDTH_SCREEN/1242))];
    round_1.image = [UIImage imageNamed:@"launch_1"];
    [_splashView addSubview:round_1];
    [self setAnimation:round_1];
}
- (void)launch_2{
    UIImageView *round_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, (int)HEIGHT_SCREEN*0.64, WIDTH_SCREEN, (int)190*(WIDTH_SCREEN/1242))];
    round_2.image = [UIImage imageNamed:@"launch_2"];
    [_splashView addSubview:round_2];
    [self setAnimation:round_2];
}
- (void)launch_3{
    UIImageView *round_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, (int)HEIGHT_SCREEN*0.42, WIDTH_SCREEN, (int)224*(WIDTH_SCREEN/1242))];
    round_3.image = [UIImage imageNamed:@"launch_3"];
    [_splashView addSubview:round_3];
    [self setAnimation:round_3];
}
- (void)launch_last{
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (int)HEIGHT_SCREEN*0.22, WIDTH_SCREEN, (int)154*(WIDTH_SCREEN/1242))];
    lastView.image = [UIImage imageNamed:@"launch_4"];
    [_splashView addSubview:lastView];
    
    lastView.alpha = .0f;
    [UIView animateWithDuration:1.0f delay:.0f options:UIViewAnimationOptionCurveLinear animations:^{
        lastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 完成后执行code
        [NSThread sleepForTimeInterval:1.0f];
        _mainTabBarController.view.userInteractionEnabled = YES;    // 动画加载完毕视图可以进行交互
        
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
        if(nil != userDict){
            [UIApplication sharedApplication].statusBarHidden = NO;
        }
        [_splashView removeFromSuperview];
    }];
}
- (void)setAnimation:(UIImageView *)view{
    view.alpha = .0f;
    [UIView animateWithDuration:.7f delay:.0f options:UIViewAnimationOptionCurveLinear animations:^{
        view.alpha = 1.0f;
        // 执行的动画code
        [view setFrame:CGRectMake(view.originX, view.originY, view.frameWidth, view.frameHeight)];
    } completion:^(BOOL finished) {
        // 完成后执行code
        //[view removeFromSuperview];
    }];
}

#pragma mark - alert点击方法
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

#pragma mark - 计时器方法
- (void)timerCallback{
    // 应用挂起300s后杀掉进程
    exit(0);
}

#pragma mark - 记录Crash信息
void UncaughtExceptionHandler(NSException *exception) {

    // 删除news列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"newsData.plist"];
    // 删除app列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"appData.plist"];
    // 删除msg列表信息
    [[BaseSandBoxUtil shareInstance] removeFileName:@"msgData.plist"];
    
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    NSString *stack = [[exception callStackSymbols] componentsJoinedByString:@"\n"];
    // 或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    NSString *crashInfo = [NSString stringWithFormat:@"[DATE] = %@ \n [NAME] = %@ \n [REASON] = %@ \n [STACK TRACE] = %@", [[BaseHandleUtil shareInstance] getCurrentDate], name, reason, stack];
    CLog(@"Yan -> Crash : \n %@", crashInfo);
}


@end
