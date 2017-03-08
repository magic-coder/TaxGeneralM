/************************************************************
 Class    : UIDevice+YZ.m
 Describe : 在UIDevice的基础上扩展了获取设备屏幕尺寸的方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-04
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "UIDevice+YZ.h"

@implementation UIDevice (YZ)

#pragma mark - 获取屏幕尺寸信息
+(DeviceScreenInch)deviceScreenInch{
    
    if(WIDTH_SCREEN == 320 && HEIGHT_SCREEN == 480){
        return DeviceScreenInch_3_5;
    }else if (WIDTH_SCREEN == 320 && HEIGHT_SCREEN == 568){
        return DeviceScreenInch_4_0;
    }else if (WIDTH_SCREEN == 375 && HEIGHT_SCREEN == 667) {
        return DeviceScreenInch_4_7;
    }else if (WIDTH_SCREEN == 414 && HEIGHT_SCREEN == 736){
        return DeviceScreenInch_5_5;
    }
    
    return DeviceScreenInch_3_5;
}

@end
