/************************************************************
 Class    : Marcos.h
 Describe : 这里添加自己定义的全局通用宏
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#ifndef Marcos_h
#define Marcos_h

#define APPDELEGETE         ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#pragma mark - Frame
#define FRAME_SCREEN    [[UIScreen mainScreen] bounds]                                  // 主屏幕Frame
#define WIDTH_SCREEN    [[UIScreen mainScreen] bounds].size.width                       // 主屏幕Width
#define HEIGHT_SCREEN   [[UIScreen mainScreen] bounds].size.height                      // 主屏幕Height
#define HEIGHT_STATUS   [[UIApplication sharedApplication] statusBarFrame].size.height  // 状态栏高度(20)
#define HEIGHT_NAVBAR   44                                                              // NavBar高度(44)
#define HEIGHT_TABBAR   49                                                              // TabBar高度(49)

#pragma mark - Masonry
// define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND           // 只要添加了这个宏，就不用带mas_前缀
// define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS   // 只要添加了这个宏，equalTo就等价于mas_equalTo

#pragma mark - Color
//#define     DEFAULT_NAVBAR_COLOR            WBColor(36.0, 105.0, 211.0, 0.9f)
#define     DEFAULT_BACKGROUND_COLOR        WBColor(239.0, 239.0, 244.0, 1.0f)
#define     DEFAULT_RED_COLOR               WBColor(230.0, 66.0, 66.0, 1.0f)
#define     DEFAULT_BLUE_COLOR              WBColor(69.0, 126.0, 212.0, 1.0f)
#define     DEFAULT_LIGHT_BLUE_COLOR        WBColor(152.0, 189.0, 233.0, 1.0f)
#define     DEFAULT_LINE_GRAY_COLOR         WBColor(188.0, 188.0, 188.0, 0.6f)
#define     DEFAULT_TABBAR_TINTCOLOR        WBColor(0.0, 190.0, 12.0, 1.0f)
#define     DEFAULT_SELECTED_GRAY_COLOR     WBColor(217.0, 217.0, 217.0, 1.0f)

#pragma mark - 设置调试日志输出
#ifdef DEBUG
#define DLog(FORMAT, ...) NSLog((@"%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#pragma mark - ServiceUrl
//#define SERVER_URL      @"http://127.0.0.1:8080/json_demo/" // Yan测试http服务器地址
#define SERVER_URL      @"https://202.100.37.162:8444/mobiletax/" // 测试https服务器地址



#pragma mark - ThirdPart KEY
#define BMAP_APPKEY     @"ZodL7vsmdWTxn83jRO6KX1OSpOVFsnUn"
#define BPUSH_APIKEY    @"ZodL7vsmdWTxn83jRO6KX1OSpOVFsnUn"

#pragma mark - Commons Key
#define LOGIN_SUCCESS   @"loginSuccess"
#define DEVICE_INFO     @"deviceInfo"
#define PUSH_INFO     @"pushInfo"

#pragma mark - Common View
#define SELF_VIEW self.view

#endif /* Marcos_h */
