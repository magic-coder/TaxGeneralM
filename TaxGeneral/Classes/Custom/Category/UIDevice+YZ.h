/************************************************************
 Class    : UIDevice+YZ.h
 Describe : 在UIDevice的基础上扩展了获取设备屏幕尺寸的方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-04
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

// 定义屏幕尺寸枚举类型
typedef NS_ENUM(NSInteger, DeviceScreenInch){
    DeviceScreenInch_3_5,    // 3.5英寸 320x480 (4、4s)
    DeviceScreenInch_4_0,    // 4.0英寸 320x568 (5、5s、5se)
    DeviceScreenInch_4_7,    // 4.7英寸 375x667 (6、6s)
    DeviceScreenInch_5_5     // 5.5英寸 414x736 (6 plus、6s plus)
};
@interface UIDevice (YZ)

+ (DeviceScreenInch)deviceScreenInch;

@end
