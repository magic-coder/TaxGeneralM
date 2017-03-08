//
//  DeviceInfoModel.h
//  TaxGeneral
//
//  Created by Apple on 2016/12/30.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

// iPhone屏幕尺寸类型
/*
typedef NS_ENUM(NSInteger, IPhoneInch) {
    IPhone_3_5_inch,    // 3.5英寸
    IPhone_4_0_inch,    // 4.0英寸
    IPhone_4_7_inch,    // 4.7英寸
    IPhone_5_5_inch,    // 5.5英寸
    IPad_inch           // 非iphone屏幕尺寸
};
*/
@interface DeviceInfoModel : NSObject <NSCoding>

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *deviceIdentifier;   // 设备唯一标示
@property (nonatomic, strong) NSString *deviceName;     // 设备名称
@property (nonatomic, strong) NSString *deviceModel;    // 设备型号
@property (nonatomic, strong) NSString *systemName;     // 系统名称
@property (nonatomic, strong) NSString *systemVersion;  // 系统版本
@property (nonatomic, assign) DeviceScreenInch deviceInch;  // 设备屏幕英寸

/************************ 类方法 ************************/
- (instancetype) getDeviceInfoModel;

@end
